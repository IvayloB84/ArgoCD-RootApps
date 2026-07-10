class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    # FIXED: Enforces that everyone registers as a normal subscriber by default
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
