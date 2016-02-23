class CreateCurationusers < ActiveRecord::Migration
  def change
    create_table :curationusers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
  end
end
