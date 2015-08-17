# File: app/inputs/user_firm_radio_buttons_input.rb

class UserFirmRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput

  # Creates a radio button set for use with review form, part relating to user - firm relationship

  def input
    label_method, value_method = detect_collection_methods
    iopts = {
      :checked => 1,
      :item_wrapper_tag => 'div',
      # span
      :item_wrapper_class => 'field',
      # checkbox
      :collection_wrapper_tag => 'div',
      :collection_wrapper_class => 'grouped inline fields'
      # form-group check_boxes optional review_user_firm_relationship
     }
    return @builder.send(
      "collection_radio_buttons",
      attribute_name,
      collection,
      value_method,
      label_method,
      iopts,
      input_html_options,
      &collection_block_for_nested_boolean_style
    )
  end # method

  protected

  def build_nested_boolean_style_item_tag(collection_builder)
    tag = String.new
    tag << '<div class="radio checkbox">'.html_safe
    tag << collection_builder.radio_button
    tag << '<div class="row">'.html_safe
    tag << '<div class="col-xs-3 text-center">'.html_safe
    tag << '<i class="fa fa-check"></i>'.html_safe
    tag << '</div>'
    tag << '<div class="col-xs-9">'.html_safe
    tag << '<p>'
    tag << collection_builder.label
    tag << '</p>'
    tag << '</div>'.html_safe
    tag << '</div>'
    return tag.html_safe
  end # method

end # class