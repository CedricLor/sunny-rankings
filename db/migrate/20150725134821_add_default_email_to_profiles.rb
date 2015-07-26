class AddDefaultEmailToProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :real_email
    add_column :profiles, :default_email_id, :integer
  end
end
