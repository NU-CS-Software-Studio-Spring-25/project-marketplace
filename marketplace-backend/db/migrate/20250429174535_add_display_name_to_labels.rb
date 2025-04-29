class AddDisplayNameToLabels < ActiveRecord::Migration[8.0]
  def change
    add_column :labels, :display_name, :string
  end
end
