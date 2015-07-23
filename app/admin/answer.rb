ActiveAdmin.register Answer do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

  index do
    selectable_column
    column :user_rating
    column :test_id
    column :review_id
    column :created_at
    actions
  end

  permit_params :user_rating,
                :review_id,
                :test_id

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

# t.integer :user_rating
# t.references :review, index: true, foreign_key: true
# t.references :test, index: true, foreign_key: true
