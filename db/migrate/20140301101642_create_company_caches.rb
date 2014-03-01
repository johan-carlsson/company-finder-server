class CreateCompanyCaches < ActiveRecord::Migration
  def change
    create_table :company_caches do |t|
      t.string :name
      t.string :identity

      t.timestamps
    end
    add_index :company_caches, :name, unique: true
  end
end
