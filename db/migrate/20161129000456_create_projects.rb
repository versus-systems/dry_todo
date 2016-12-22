class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name
      t.string :description
      t.integer :state

      t.timestamps
    end
  end
end
