require 'zip/zip'

class Model < ActiveRecord::Base
  attr_accessible :Model_ID
  set_primary_key "Model_ID"

  def self.GetAllModels()
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
            REPLACE(REPLACE(amv.Model_File, mma.Model_ID, ''), '/var/www/NeuroMLmodels//','') as File
        FROM refers
        JOIN model_metadata_associations as mma ON metadata_id = reference_ID
        JOIN all_models_view as amv ON amv.Model_ID = mma.Model_ID
        WHERE Reference_Resource_ID = 2
        ORDER BY ModelDB_ID, NeuroMLDB_ID;
        ")

    return models
  end

  def self.GetFile(modelID)

    # If network
    if modelID.starts_with?('NMLNT')

      return Network.find_by_Network_ID(modelID).NetworkML_File

    end

    # If cell
    if modelID.starts_with?('NMLCL')

      return Cell.find_by_Cell_ID(modelID).MorphML_File

    end

    # If channel
    if modelID.starts_with?('NMLCH')

      return Channel.find_by_Channel_ID(modelID).ChannelML_File

    end

    # If synapse
    if modelID.starts_with?('NMLSY')

      return Synapse.find_by_Synapse_ID(modelID).Synapse_File

    end

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

    # If network
    if modelID.starts_with?('NMLNT')

      # Add the network file
      result.push({ "ModelID" => modelID, "File" => Network.find_by_Network_ID(modelID).NetworkML_File })

      # Look for network cells and their children
      NetworkCellAssociation.where(:Network_ID => modelID).each do |cellRecord|
        GetModelFiles(cellRecord.Cell_ID, result)
      end

      # Look for network synapses
      NetworkSynapseAssociation.where(:Network_ID => modelID).each do |synapseRecord|
        GetModelFiles(synapseRecord.Synapse_ID, result)
      end

      # Look for network concentrations
      NetworkConcentrationAssociation.where(:Network_ID => modelID).each do |concentrationRecord|
        GetModelFiles(concentrationRecord.Concentration_ID, result)
      end

    end

    # If cell
    if modelID.starts_with?('NMLCL')

      # Add the cell file
      result.push({ "ModelID" => modelID, "File" => Cell.find_by_Cell_ID(modelID).MorphML_File })

      # Add channels
      CellChannelAssociation.where(:Cell_ID => modelID).each do |channelRecord|
        GetModelFiles(channelRecord.Channel_ID, result)
      end

      # Add synnapses
      CellSynapseAssociation.where(:Cell_ID => modelID).each do |synapseRecord|
        GetModelFiles(synapseRecord.Synapse_ID, result)
      end

      # Add concentrations
      CellConcentrationAssociation.where(:Cell_ID => modelID).each do |concentrationRecord|
        GetModelFiles(concentrationRecord.Concentration_ID, result)
      end

    end

    # If channel
    if modelID.starts_with?('NMLCH')

        # Channels only have files, no children
        result.push({ "ModelID" => modelID, "File" => Channel.find_by_Channel_ID(modelID).ChannelML_File })
    end

    # If synapse
    if modelID.starts_with?('NMLSY')

      # Synapses only have files, no children
      result.push({ "ModelID" => modelID, "File" => Synapse.find_by_Synapse_ID(modelID).Synapse_File })

    end

    # If concentration
    if modelID.starts_with?('NMLCN')

      # Concentrations only have files, no children
      result.push({ "ModelID" => modelID, "File" => Concentration.find_by_Concentration_ID(modelID).Concentration_File })

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
