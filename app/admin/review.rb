ActiveAdmin.register Review do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id,
              :firm_id,
              :user_firm_relationship,
              :confirmed_t_and_c,
              :validated
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

# t.references :user, index: true, foreign_key: true
# t.references :firm, index: true, foreign_key: true
# t.string :user_firm_relationship
# t.boolean :confirmed_t_and_c, default: false
# t.boolean :validated, default: false
