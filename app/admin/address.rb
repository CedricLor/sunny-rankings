ActiveAdmin.register Address do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  index do
    selectable_column
    column :id
    column :street
    column :number
    column :addr_complement
    column :city
    column :zip_code
    column :country
    column :fuzzy_address
    column :latitude
    column :longitude
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Physical address" do
      f.input :street
      f.input :number
      f.input :addr_complement
      f.input :city
      f.input :zip_code
      f.input :country
      f.input :fuzzy_address
    end
    f.inputs "Admin" do
      f.input :latitude
      f.input :longitude
    end
    f.actions
  end

  permit_params :city,
                :street,
                :number,
                :zip_code,
                :country,
                :addr_complement,
                :fuzzy_address,
                :latitude,
                :longitude

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
end

# t.string :city
# t.string :street
# t.string :number
# t.string :zip_code
# t.string :country
# t.string :addr_complement
# t.string :fuzzy_address

# add_column :addresses, :latitude, :float
# add_column :addresses, :longitude, :float
