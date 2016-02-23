class CreateKcategories < ActiveRecord::Migration
  def change
    create_table :kcategories do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
