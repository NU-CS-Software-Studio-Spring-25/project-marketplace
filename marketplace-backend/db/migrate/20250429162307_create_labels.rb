class CreateLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :labels do |t|
      t.string :name

      t.timestamps
    end
    add_index :labels, :name, unique: true
  end
end
