ActiveAdmin.register TopLevelIndustry do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :naf_code,
              :naf_title_fr,
              :naf_title_en

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

      # t.string :naf_code
      # t.string :naf_title_fr
      # t.string :naf_title_en
