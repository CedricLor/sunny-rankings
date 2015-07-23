ActiveAdmin.register Test do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :test_question,
              :test_long_question,
              :select_options,
              :positive_negative_switch

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end

# t.string :test_question
# t.string :test_long_question
# t.string :select_options
# t.string :positive_negative_switch
