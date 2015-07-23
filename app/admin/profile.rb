ActiveAdmin.register Profile do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :first_name,
              :last_name,
              :mother_maiden_name,
              :address,
              :phone_number,
              :country,
              :employer_name,
              :current_position,
              :age,
              :gender,
              :real_email,
              :validated,
              :first_time_login_upon_firm_review

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

# t.string :first_name
# t.string :last_name
# t.string :mother_maiden_name
# t.string :address
# t.string :phone_number
# t.string :country
# t.string :employer_name
# t.string :current_position
# t.integer :age
# t.string :gender
# t.string :real_email
# t.boolean :validated
# t.boolean :first_time_login_upon_firm_review
