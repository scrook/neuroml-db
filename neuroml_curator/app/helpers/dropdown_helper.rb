module DropdownHelper
  def author_lists

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT AuthorList_ID, ala.Person_ID, ala.is_translator, p.Person_Last_Name FROM author_list_associations ala '\
      'JOIN people p ON p.Person_ID = ala.Person_ID '\
      'ORDER BY AuthorList_ID DESC, is_translator, Person_ID; '\
    )}

    @authorLists = [{ :ID => records.first["AuthorList_ID"].to_s, :Authors => [] }]

    records.each do |record|
      if @authorLists.last[:ID] != record["AuthorList_ID"].to_s
        @authorLists.push({ :ID => record["AuthorList_ID"].to_s })
        @authorLists.last[:Authors] = []
      end

      @authorLists.last[:Authors].push({ :ID => record["Person_ID"], :Translator => record["is_translator"], :LastName => record["Person_Last_Name"] })
    end

  end

  def authors

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Person_ID, Person_First_Name, Person_Last_Name FROM people ' \
      'ORDER BY Person_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Person_ID"], \
        :FirstName => record["Person_First_Name"], \
        :LastName => record["Person_Last_Name"] \
      })
    end

    @authors = result

  end

  def publications

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Publication_ID, Pubmed_Ref, Full_Title FROM publications ' \
      'ORDER BY Publication_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Publication_ID"], \
        :Pubmed => record["Pubmed_Ref"], \
        :Title => record["Full_Title"] \
      })
    end

    @publications = result

  end

  def references

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Reference_ID, Reference_Resource, Reference_URI FROM refers ' \
      'ORDER BY Reference_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Reference_ID"], \
        :Source => record["Reference_Resource"], \
        :URL => record["Reference_URI"] \
      })
    end

    @references = result

  end

  def modelsources

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT ID, Name FROM resources ' \
      'ORDER BY Name' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["ID"], \
        :Name => record["Name"]
      })
    end

    @modelsources = result

  end

  def neurolexterms

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT NeuroLex_ID, NeuroLex_URI, NeuroLex_Term FROM neurolexes ' \
      'ORDER BY NeuroLex_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["NeuroLex_ID"], \
        :URI => record["NeuroLex_URI"], \
        :Term => record["NeuroLex_Term"],
      })
    end

    @neurolexterms = result

  end

  def channels

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Channel_ID, Channel_Name, pubs.Full_Title FROM channels ' \
      'LEFT OUTER JOIN  ' \
      '( ' \
      '    SELECT mma.Model_ID, p.Full_Title FROM model_metadata_associations mma ' \
      '    JOIN publications p ON p.Publication_ID = mma.Metadata_ID ' \
      ') pubs ' \
      'ON pubs.Model_ID = Channel_ID ' \
      'ORDER BY Channel_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Channel_ID"], \
        :Name => record["Channel_Name"], \
        :PubTitle => record["Full_Title"],
      })
    end

    @channels = result

  end



  def networks

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Network_ID, Network_Name, pubs.Full_Title FROM networks '\
      'LEFT OUTER JOIN  '\
      '( '\
      '	   SELECT mma.Model_ID, p.Full_Title FROM model_metadata_associations mma '\
      '    JOIN publications p ON p.Publication_ID = mma.Metadata_ID '\
      ') pubs '\
      'ON pubs.Model_ID = Network_ID '\
      'ORDER BY Network_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Network_ID"], \
        :Name => record["Network_Name"], \
        :PubTitle => record["Full_Title"],
      })
    end

    @networks = result

  end


  def synapses

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Synapse_ID, Synapse_Name, pubs.Full_Title FROM synapses '\
      'LEFT OUTER JOIN  '\
      '( '\
      '	   SELECT mma.Model_ID, p.Full_Title FROM model_metadata_associations mma '\
      '    JOIN publications p ON p.Publication_ID = mma.Metadata_ID '\
      ') pubs '\
      'ON pubs.Model_ID = Synapse_ID '\
      'ORDER BY Synapse_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Synapse_ID"], \
        :Name => record["Synapse_Name"], \
        :PubTitle => record["Full_Title"],
      })
    end

    @synapses = result

  end

  def cells

    records = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query( \
      'SELECT Cell_ID, Cell_Name, pubs.Full_Title FROM cells '\
      'LEFT OUTER JOIN  '\
      '( '\
      '	   SELECT mma.Model_ID, p.Full_Title FROM model_metadata_associations mma '\
      '    JOIN publications p ON p.Publication_ID = mma.Metadata_ID '\
      ') pubs '\
      'ON pubs.Model_ID = Cell_ID '\
      'ORDER BY Cell_ID DESC' \
    )}

    result = []

    records.each do |record|
      result.push({ \
        :ID => record["Cell_ID"], \
        :Name => record["Cell_Name"], \
        :PubTitle => record["Full_Title"],
                  })
    end

    @cells = result

  end

end
