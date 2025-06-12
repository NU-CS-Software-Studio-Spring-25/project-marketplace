class CreateUserLabels < ActiveRecord::Migration[8.0]
  def change
    create_table :user_labels do |t|
      t.references :user, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end

    # Add a unique index so each user-tag pair is unique (optional but recommended)
    add_index :user_labels, [:user_id, :label_id], unique: true
  end
end