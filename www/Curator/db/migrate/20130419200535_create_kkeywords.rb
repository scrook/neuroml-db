class CreateKkeywords < ActiveRecord::Migration
  def change
    create_table :kkeywords do |t|
      t.string :keyword_name
      t.integer :category_id

      t.timestamps
    end
  end
end
