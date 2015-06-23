module ApplicationHelper
  # The following comes from Le Wagon slides
  # This allows to feed the title in the navigator with various stuffs
  def yield_with_default(holder, default)
    if content_for?(holder)
      content_for(holder).squish
    else
      default
    end
  end

  # Idem: comes from Le Wagon
  # Display flash messages in bootstrap classed divs
  def bootstrap_class_for(flash_type)
    case flash_type
    when :alert   then "alert-error"
    when :notice  then "alert-success"
    end
  end
end
