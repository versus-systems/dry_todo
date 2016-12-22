class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :project, type: :uuid, foreign_key: true
      t.string :name
      t.string :description
      t.integer :state
      t.integer :points

      t.timestamps
    end
  end
end
