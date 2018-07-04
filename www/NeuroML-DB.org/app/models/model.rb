require 'zip/zip'

class Model < ActiveRecord::Base
  attr_accessible :Model_ID, :Type, :Name, :File, :Notes

  self.primary_key = "Model_ID"

  belongs_to :ModelType,
              class_name: "ModelType",
              foreign_key: "Type"

  has_and_belongs_to_many :parents,
                          class_name: "Model",
                          foreign_key: "Child_ID",
                          join_table: "model_model_associations",
                          association_foreign_key: "Parent_ID"

  has_and_belongs_to_many :children,
                          class_name: "Model",
                          foreign_key: "Parent_ID",
                          join_table: "model_model_associations",
                          association_foreign_key: "Child_ID"

  def self.SearchKeyword(search_text)
    @search_text = search_text

    connection           = ActiveRecord::Base.connection

    # use regex to find " surrounded phares: / ?"(.*?)" ?/ the group in all matches will contain just the phrases
    # all other text is unquoted
    quotedRegex = / ?"(.*?)" ?/
    phrases = Array.new

    quotedMatches = @search_text.to_enum(:scan, quotedRegex).map { Regexp.last_match }


    if quotedMatches.length == 0

      words = @search_text.split(' ')
      phrases.push(*words)

    else

      # Scan from the begginging of the query
      index = 0

      for match in quotedMatches
        # Get the unquoted text before the match
        matchStart, matchFinish = match.offset(0)

        if matchStart > 0
          unquoted = @search_text[index..matchStart-1]
          words = unquoted.split(' ')
          phrases.push(*words)

        end

        index = matchFinish # will contain the index of char just after the match

        # Get the text inside the quotes
        capture = match.captures[0]

        phrases.push(capture)
      end

      # Till the end of the query
      if index < @search_text.length-1
        unquoted = @search_text[index..@search_text.length-1]
        words = unquoted.split(' ')
        phrases.push(*words)

      end

    end

    # Remove any blank phrases
    phrases.reject! {|p| p.nil? || p.length == 0}

    # Escape each phrase
    phrases.map! {|p| connection.quote_string(p)}

    # Use the sql syntax to construct the query, using +s and putting qoutes around everything "" even single terms
    phrases.map! do |p|
      if p.length >= 4
        '+"' + p +  '"' # add +s and quotes
      else
        '"' + p +  '"' # don't add the plus for <4 char phrases
      end
    end

    fullTextSearchString = phrases.join(" ")

    sql = "call keyword_search('#{fullTextSearchString}')"

    @dbResult = connection.exec_query(sql);

    ActiveRecord::Base.clear_active_connections!

    return @dbResult
  end

  def self.GetAllModels()
    models = ActiveRecord::Base.connection.exec_query(
        "
          SELECT *
          FROM models
          ORDER BY Model_ID
        ")

    return models
  end

  def self.GetModelDetails(id)

    idClean = Model.connection.quote_string(id)

    model = ActiveRecord::Base.connection.exec_query(
        "
          SELECT m.*, mt.Name as Type, c.*, ch.*, mrc.*,
            IF(c.Stability_Range_Low is NULL, ch.Stability_Range_Low, c.Stability_Range_Low) as Stability_Range_Low_Corr,
            IF(c.Stability_Range_High is NULL, ch.Stability_Range_High, c.Stability_Range_High) as Stability_Range_High_Corr
          FROM models m
          JOIN model_types mt ON mt.ID = m.Type
          LEFT JOIN cells c on c.Model_ID = m.Model_ID
          LEFT JOIN channels ch on ch.Model_ID = m.Model_ID
          LEFT JOIN model_relative_complexity mrc on mrc.Model_ID = m.Model_ID
          WHERE m.Model_ID = '#{idClean}'
          LIMIT 1
        ").first

    if model == nil
      return nil
    end

    waveform_list = self.GetModelWaveFormList(id)

    children = ActiveRecord::Base.connection.exec_query(
        "
          SELECT c.*, mt.Name as Type
          FROM model_model_associations mma
          JOIN models p ON p.Model_ID = mma.Parent_ID
          JOIN models c ON c.Model_ID = mma.Child_ID
          JOIN model_types mt ON mt.ID = c.Type
          WHERE mma.Parent_ID = '#{idClean}'
          ORDER BY c.Model_ID
        ")

    parents = ActiveRecord::Base.connection.exec_query(
        "
          SELECT p.*, mt.Name as Type
          FROM model_model_associations mma
          JOIN models p ON p.Model_ID = mma.Parent_ID
          JOIN models c ON c.Model_ID = mma.Child_ID
          JOIN model_types mt ON mt.ID = p.Type
          WHERE mma.Child_ID = '#{idClean}'
          ORDER BY c.Model_ID
        ")

    pub = ActiveRecord::Base.connection.exec_query(
        "
          SELECT p.*
          FROM publications p
          JOIN models m ON m.Publication_ID = p.Publication_ID
          WHERE m.Model_ID = '#{idClean}'
        ").first

    authors = ActiveRecord::Base.connection.exec_query(
        "
          (
            SELECT p.Person_First_Name, p.Person_Last_Name, False as is_translator, author_sequence as sequence
            FROM people p
            JOIN publication_authors pa ON p.Person_ID = pa.Author_ID
            JOIN models m ON m.Publication_ID = pa.Publication_ID
            WHERE m.Model_ID = '#{idClean}'

          )

          UNION

          (
            SELECT p.Person_First_Name, p.Person_Last_Name, True as is_translator, translator_sequence as sequence
            FROM people p
            JOIN model_translators mt ON p.Person_ID = mt.Translator_ID
            WHERE mt.Model_ID = '#{idClean}'
          )
          ORDER BY is_translator, sequence
        ")

    references = ActiveRecord::Base.connection.exec_query(
        "
          SELECT rs.*, rf.Reference_URI
          FROM refers rf
          JOIN resources rs ON rs.Resource_ID = rf.Reference_Resource_ID
          JOIN model_references mr ON mr.Reference_ID = rf.Reference_ID
          WHERE mr.Model_ID = '#{idClean}'
        ")

    keywords = ActiveRecord::Base.connection.exec_query(
        "
          SELECT k.*
          FROM other_keywords k
          JOIN model_other_keywords mok ON mok.Other_Keyword_ID = k.Other_Keyword_ID
          WHERE mok.Model_ID = '#{idClean}'
        ")

    neurolexes = ActiveRecord::Base.connection.exec_query(
        "
          SELECT n.*
          FROM neurolexes n
          JOIN model_neurolexes mn ON mn.Neurolex_ID = n.Neurolex_ID
          WHERE mn.Model_ID = '#{idClean}'
        ")

    dt_sensitivity = ActiveRecord::Base.connection.exec_query(
        "
          SELECT mw.dt_or_atol as DT, mw.Percent_Error as Error, mw.Steps as Steps
          FROM neuromldb.model_waveforms mw
          WHERE mw.Protocol_ID in ('DT_SENSITIVITY', 'OPTIMAL_DT_BENCHMARK') AND
          mw.Steps is not null AND
          mw.dt_or_atol is not null AND
          mw.Variable_Name = 'Voltage' AND
          mw.Model_ID = '#{idClean}'
          ORDER BY DT
        ")

    cvode_spikes_vs_steps = ActiveRecord::Base.connection.exec_query(
        "
          SELECT Spikes, Steps FROM model_waveforms mw
          WHERE mw.Protocol_ID  = 'CVODE_STEP_FREQUENCIES' AND
          mw.Variable_Name = 'Voltage' AND
          mw.Model_ID = '#{idClean}'
          ORDER BY Spikes
        ")

    return {
        model: model,
        publication: {
            short: GetModelShortPub(idClean),
            record: pub,
            authors: authors
        },
        references: references,
        keywords: keywords,
        neurolex_ids: neurolexes,
        children: children,
        parents: parents,
        waveform_list: waveform_list,
        complexity: {
            dt_sensitivity: dt_sensitivity,
            cvode_spikes_vs_steps: cvode_spikes_vs_steps
        }
    }
  end

  def self.GetModelWaveFormList(id)

    idClean = Model.connection.quote_string(id)

    return ActiveRecord::Base.connection.exec_query(
        "
          SELECT mw.ID, mw.Protocol_ID, p.Pretty_Name as Protocol, mw.Meta_Protocol_ID, mp.Pretty_Name as Meta_Protocol,
                 mw.Waveform_Label, mw.Time_Start, mw.Time_End, mw.Variable_Name, p.Starts_From_Steady_State, mw.Units
          FROM model_waveforms mw
          LEFT JOIN protocols p ON p.ID = mw.Protocol_ID
          LEFT JOIN protocols mp ON mp.ID = mw.Meta_Protocol_ID
          WHERE mw.Model_ID = '#{idClean}'
          ORDER BY p.Display_Order, mp.Display_Order, mw.ID
        ")

  end

  def self.GetModelWaveForm(waveform_id)

    idClean = Model.connection.quote_string(waveform_id)

    waveform = ActiveRecord::Base.connection.exec_query(
      "
          SELECT mw.*
          FROM model_waveforms mw
          WHERE mw.ID = '#{idClean}'
          LIMIT 1
        ").first


    # Get values from waveform .csv file
    waveform["Times"], waveform["Variable_Values"] = GetWaveformValues(waveform["Model_ID"], waveform["ID"])

    return waveform
  end

  def self.GetWaveformValues(model_id, waveform_id)
      file = "/var/www/NeuroMLmodels/"+model_id+"/waveforms/"+waveform_id.to_s+".csv"

      if File.exists?(file)
        lines = File.readlines(file)
      else
        raise "Waveform was not found in the sever's file system. Make sure 'git pull' has been performed on the server."
      end


      if lines.length == 2
        times = lines[0]
        values = lines[1]
      else
        times = nil
        values = lines[0]
      end


      return times, values
  end

  def self.GetModelPlotWaveForms(model_id, protocol_id, meta_protocol_id)

    model_id = Model.connection.quote_string(model_id)
    protocol_id = Model.connection.quote_string(protocol_id)
    meta_protocol_id = Model.connection.quote_string(meta_protocol_id)

    query = "
      SELECT mw.*
      FROM model_waveforms mw
      WHERE mw.Model_ID = '#{model_id}' AND
            mw.Protocol_ID = '#{protocol_id}' AND
            mw.Meta_Protocol_ID = '#{meta_protocol_id}'
      ORDER BY mw.Protocol_ID, mw.Meta_Protocol_ID, mw.ID
    "

    query = query.gsub("= 'null'","is NULL")

    #logger.warn(query)

    waveforms = ActiveRecord::Base.connection.exec_query(query)

    # Fetch .csv waveform values
    waveforms.each do |waveform|
      waveform["Times"], waveform["Variable_Values"] = GetWaveformValues(waveform["Model_ID"], waveform["ID"])
    end

    return waveforms
  end

  def self.GetModelGifPath(id)

    id = Model.connection.quote_string(id)

    query = "
      SELECT Model_ID
      FROM models m
      WHERE m.Model_ID = '#{id}'
      LIMIT 1
    "

    records = ActiveRecord::Base.connection.exec_query(query)

    if records.rows.length > 0
      model_id = records.first()["Model_ID"]

      file = "/var/www/NeuroMLmodels/"+model_id+"/morphology/cell.gif"
      if File.exist?(file)
        return file
      else
        return nil
      end

    else
      return nil
    end

  end

  def self.GetMorphometrics(id)

    id = Model.connection.quote_string(id)

    query = "
      SELECT cm.*, m.Description, m.Shown_Statistic, IF(m.Units is NULL,'',m.Units) as Units
      FROM neuromldb.cell_morphometrics cm
      JOIN morphometrics m ON m.ID = cm.Metric_ID
      WHERE cm.Cell_ID = '#{id}' AND m.Display = 1
      ORDER BY m.Display_Order
    "

    metrics = ActiveRecord::Base.connection.exec_query(query)

    return metrics
  end


  def self.GetAllModelsForModelDB()
    models = ActiveRecord::Base.connection.exec_query(
        "
        SELECT
          CAST(
            REPLACE(
            REPLACE(
            LOWER(Reference_URI),
            'https://senselab.med.yale.edu/modeldb/showmodel.asp?model=',''),
            'https://senselab.med.yale.edu/modeldb/showmodel.cshtml?model=','')
            AS UNSIGNED) as ModelDB_ID,
            m.Model_ID as NeuroMLDB_ID,
            REPLACE(REPLACE(m.File, m.Model_ID, ''), '/var/www/NeuroMLmodels//','') as File
        FROM refers r
        JOIN model_references mr ON mr.reference_ID = r.reference_ID
        JOIN models m ON m.Model_ID = mr.Model_ID
        WHERE Reference_Resource_ID = 2
        ORDER BY ModelDB_ID, NeuroMLDB_ID;
        ")

    return models
  end

  def self.GetModelShortPub(modelID)
    shortPub = ActiveRecord::Base.connection.exec_query(
      "
      SELECT p.Person_Last_Name as lastName, pub.Year as year
      FROM people p
      JOIN publication_authors pa ON pa.Author_ID = p.Person_ID
      JOIN publications pub ON pub.Publication_ID = pa.Publication_ID
      JOIN models m ON m.Publication_ID = pub.Publication_ID
      WHERE m.model_ID = '#{modelID}'
      ORDER BY pa.author_sequence
      LIMIT 3
      ;
      "
    )

    authorCount = shortPub.rows.length

    # One author - name (year)
    # two authors - first & second (year)
    # three or more - first, et. al. (year)

    if authorCount > 0
      year = " (#{shortPub.rows[0][1]})"
      firstAuthor = shortPub.rows[0][0]
    end

    if authorCount == 1
      return firstAuthor + year
    elsif authorCount == 2
      return firstAuthor + " & " + shortPub.rows[1][0] + year
    elsif authorCount > 2
      return firstAuthor + ", et. al." + year
    end

    return "N/A (missing publication)"
  end

  def self.GetFile(modelID)

    return Model.find_by_Model_ID(modelID).File

  end

  # Recursivelly get the files associated with a model and its children
  def self.GetFiles(modelID)
    result = Array.new

    GetModelFiles(modelID, result)

    return result.uniq
  end

  # Recursivelly get the files associated with a model and its children
  def self.GetModelFiles(modelID, result)

    # Result will keep a list of all files
    if result == NIL
      result = Array.new
    end

    # Add the model file
    result.push({ "ModelID" => modelID, "File" => Model.find_by_Model_ID(modelID).File })

    # Look for model child models
    ModelModelAssociation.where(:Parent_ID => modelID).each do |childRecord|
      GetModelFiles(childRecord.Child_ID, result)
    end

  end

  def self.GetModelZipFilePath(modelID)

    _zipFileName = modelID + '.zip'
    _zipFilePath = '/var/www/NeuroMLmodels/' + modelID + '/' + _zipFileName

    if not File.exist?(_zipFilePath) or File.mtime(_zipFilePath) < 1.month.ago

      filesToZip = GetFiles(modelID)

      begin

        if File.exist?(_zipFilePath)
          File.delete(_zipFilePath)
        end

        Zip::ZipFile.open(_zipFilePath, Zip::ZipFile::CREATE) do |zip|

          filesToZip.each do |record|
            zip.add(File.basename(record["File"]), record["File"])
          end

        end

      rescue

        if File.exist?(_zipFilePath)
          File.delete(_zipFilePath)
        end

        raise

      end
    end

    return _zipFilePath

  end

  def self.GetChannelLEMSZipFilePath(modelID)

    _zipFileName = modelID + '_vclamp_simulation.zip'
    _zipFilePath = '/var/www/NeuroMLmodels/' + modelID + '/' + _zipFileName

    if not File.exist?(_zipFilePath) or File.mtime(_zipFilePath) < 1.month.ago

      filesToZip = GetFiles(modelID)

      # Add the LEMS files to the list of files to zip
      channelFile = File.basename(filesToZip[0]["File"])
      directory = File.dirname(filesToZip[0]["File"])

      lemsFiles = Dir[directory+"/LEMS*"]

      for lemsFile in lemsFiles
        filesToZip.push({ "File" => lemsFile })
      end

      begin

        if File.exist?(_zipFilePath)
          File.delete(_zipFilePath)
        end

        Zip::ZipFile.open(_zipFilePath, Zip::ZipFile::CREATE) do |zip|

          filesToZip.each do |record|
            zip.add(File.basename(record["File"]), record["File"])
          end

        end

      rescue

        if File.exist?(_zipFilePath)
          File.delete(_zipFilePath)
        end

        raise

      end
    end

    return _zipFilePath

  end
end
