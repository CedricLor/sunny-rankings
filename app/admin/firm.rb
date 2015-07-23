ActiveAdmin.register Firm do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name,
              :url,
              :country,
              :headcount,
              :business_description,
              :industry,
              :icon_name,
              :reg_number,
              :naf_code
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

# t.string :name
# t.string :url
# t.string :country
# t.integer :headcount
# t.text :business_description
# t.string :industry
# t.string :icon_name
# t.string :reg_number
