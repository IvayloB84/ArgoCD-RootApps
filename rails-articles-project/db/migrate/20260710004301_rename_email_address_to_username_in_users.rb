class RenameEmailAddressToUsernameInUsers < ActiveRecord::Migration[8.0]
  def change
    # FIXED: Instructs SQLite to map the authentication string to username natively
    rename_column :users, :email_address, :username
  end
end