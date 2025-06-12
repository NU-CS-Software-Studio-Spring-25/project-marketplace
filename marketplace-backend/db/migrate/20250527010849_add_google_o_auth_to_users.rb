class AddGoogleOAuthToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :profile_picture_url, :string
  end
end
