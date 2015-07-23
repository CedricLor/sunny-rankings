ActiveAdmin.register LowLevelIndustry do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  index do
    selectable_column
    column :naf_code
    column :naf_title_fr
    column :naf_title_en
    column :top_level_industry_id
    actions
  end

  permit_params :naf_code,
                :naf_title_fr,
                :naf_title_en,
                :top_level_industry_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
