ActiveAdmin.register GrantedAward do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  index do
    selectable_column
    column :award_id
    column :firm_id
    column :details
    actions
  end

  permit_params :award_id,
                :firm_id,
                :details

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

      # t.references :award, index: true, foreign_key: true
      # t.references :firm, index: true, foreign_key: true
      # t.text :details
