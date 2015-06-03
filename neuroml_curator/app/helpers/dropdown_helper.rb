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

end
