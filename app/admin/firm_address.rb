ActiveAdmin.register FirmAddress do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  index do
    selectable_column
    column :type_of_address
    column :firm_id
    column :address_id
    actions
  end

  permit_params :type_of_address,
                :firm_id,
                :address_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

      # t.references :firm, index: true, foreign_key: true
      # t.references :address, index: true, foreign_key: true
      # t.string :type_of_address
