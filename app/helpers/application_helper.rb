module ApplicationHelper
  # The following comes from Le Wagon slides
  # This allows to feed the title in the navigator with various stuffs
  def yield_with_default(holder, default)
    content_for?(holder) ? content_for(holder).squish : default
  end
end
