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
          SELECT m.*, mt.Name as Type
          FROM models m
          JOIN model_types mt ON mt.ID = m.Type
          WHERE m.Model_ID = '#{idClean}'
        ").first

    if model == nil
      return nil
    end

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
          JOIN model_metadata_associations mma ON mma.Metadata_ID = p.Publication_ID
          WHERE mma.Model_ID = '#{idClean}'
        ").first

    authors = ActiveRecord::Base.connection.exec_query(
        "
          SELECT p.Person_First_Name, p.Person_Last_Name, ala.is_translator
          FROM author_list_associations ala
          JOIN model_metadata_associations mma ON ala.AuthorList_ID = mma.Metadata_ID
          JOIN people p ON p.Person_ID = ala.Person_ID
          WHERE mma.Model_ID = '#{idClean}'
          ORDER BY is_translator, author_sequence
        ")

    references = ActiveRecord::Base.connection.exec_query(
        "
          SELECT rs.*, rf.Reference_URI
          FROM refers rf
          JOIN resources rs ON rs.Resource_ID = rf.Reference_Resource_ID
          JOIN model_metadata_associations mma ON mma.Metadata_ID = rf.Reference_ID
          WHERE mma.Model_ID = '#{idClean}'
        ")

    keywords = ActiveRecord::Base.connection.exec_query(
        "
          SELECT k.*
          FROM other_keywords k
          JOIN model_metadata_associations mma ON mma.Metadata_ID = k.Other_Keyword_ID
          WHERE mma.Model_ID = '#{idClean}'
        ")

    neurolexes = ActiveRecord::Base.connection.exec_query(
        "
          SELECT n.*
          FROM neurolexes n
          JOIN model_metadata_associations mma ON mma.Metadata_ID = n.Neurolex_ID
          WHERE mma.Model_ID = '#{idClean}'
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
        parents: parents
    }
  end

  def self.GetAllModelsForModelDB()
    models = ActiveRecord::Base.connection.exec_query(
        "
        SELECT
          CAST(
            REPLACE(
            REPLACE(
            LOWER(Reference_URI),
            'http://senselab.med.yale.edu/modeldb/showmodel.asp?model=',''),
            'https://senselab.med.yale.edu/modeldb/showmodel.cshtml?model=','')
            AS UNSIGNED) as ModelDB_ID,
            mma.Model_ID as NeuroMLDB_ID,
            REPLACE(REPLACE(amv.File, mma.Model_ID, ''), '/var/www/NeuroMLmodels//','') as File
        FROM refers
        JOIN model_metadata_associations as mma ON metadata_id = reference_ID
        JOIN all_models_view as amv ON amv.Model_ID = mma.Model_ID
        WHERE Reference_Resource_ID = 2
        ORDER BY ModelDB_ID, NeuroMLDB_ID;
        ")

    return models
  end

  def self.GetModelShortPub(modelID)
    shortPub = ActiveRecord::Base.connection.exec_query(
      "
      SELECT p.Person_Last_Name as lastName, pub.Year as year FROM people p
      JOIN author_list_associations ala ON ala.Person_ID = p.Person_ID
      JOIN model_metadata_associations mma ON mma.Metadata_ID = ala.AuthorList_ID
      JOIN model_metadata_associations mma2 ON mma2.Model_ID = mma.Model_ID
      JOIN publications pub ON pub.Publication_ID = mma2.Metadata_ID
      WHERE mma2.model_ID = '#{modelID}' AND mma2.Metadata_Id like '600%' AND ala.is_translator != '1'
      ORDER BY ala.author_sequence
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

    return "MISSING REF"
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
