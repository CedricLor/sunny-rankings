ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :email,
              :encrypted_password,
              :validated,
              :real_email,
              :profile_id,
              :admin
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

end

# t.string :email,              null: false, default: ""
# t.string :encrypted_password, null: false, default: ""

# t.boolean :validated, null: false, default: false
# # t.references :user, index: true, foreign_key: true
# # TODO: Quick fix; in reality, should rely on the emails in the profiles
# t.string :real_email

# # Preparing the creation of a profile model
# t.references :profile, index: true, foreign_key: true
# # t.integer :profile_id

# t.timestamps null: false
