class CreateColleges < ActiveRecord::Migration[7.0]
  def change
    create_table :colleges do |t|
      t.string :name
      
      t.timestamps
    end
  end
end
