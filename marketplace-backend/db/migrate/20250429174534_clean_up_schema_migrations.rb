class CleanUpSchemaMigrations < ActiveRecord::Migration[8.0]
  def up
    # Remove the entry for the missing migration file
    ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version = '20250429162333'")
  end

  def down
    # This migration is not reversible
    raise ActiveRecord::IrreversibleMigration
  end
end

