class AddAdminToUsers < ActiveRecord::Migration
  def change
  #admin would be nil (which is still false) by default,
  # but adding, default= false , adds clarity
    add_column :users, :admin, :boolean, default: false
  end
end
