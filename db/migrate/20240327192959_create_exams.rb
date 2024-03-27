class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.string :name
      t.references :college, null: false, foreign_key: true

      t.timestamps
    end
  end
end
