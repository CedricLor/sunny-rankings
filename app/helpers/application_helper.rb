module ApplicationHelper
  # The following comes from Le Wagon slides
  # This allows to feed the title in the navigator with various stuffs
  def yield_with_default(holder, default)
    content_for?(holder) ? content_for(holder).squish : default
  end

  def trend_arrow(test_index)
    @css_class_for_arrow = {up: "rotate-right-up", down: "rotate-right-down", neutral: "rotate-neutral"}
    arrow_direction_setter(@current_period_averages, @previous_period_averages, test_index)
  end

  def voting_stage_params_setter(test_index)
    unless @current_stage == :first_time_vote
      @new_average_including_voter = ( (@total_by_test.fetch(test_index + 1) + @review.answers[test_index].user_rating ).to_f / (@answer_count_by_test.fetch(test_index + 1) + 1) ).to_f
      @new_average_including_voter_rounded = @new_average_including_voter.round(1)
      arrow_direction_setter(@new_average_including_voter, @avg_ratings_by_test, test_index)
      @arrow_direction_including_voter = @arrow_direction
    end
    @voting_stages = {
      first_time_vote: {
        text: t('.potential_impact', default: "Your potential impact"),
        css_hidden_switch: "my-hidden-class",
        new_average_including_voter: "",
        arrow_direction_including_voter: :neutral},
      review_vote: {
        text: t('.potential_impact', default: "Your potential impact"),
        css_hidden_switch: "",
        new_average_including_voter: @new_average_including_voter_rounded,
        arrow_direction_including_voter: @arrow_direction_including_voter},
      archived_vote: {
        text: t('.real_impact', default: "Your impact"),
        css_hidden_switch: "",
        new_average_including_voter: @new_average_including_voter_rounded,
        arrow_direction_including_voter: @arrow_direction_including_voter}
    }
  end

  private
    def arrow_direction_setter(current_period_averages, previous_period_averages, test_index)
      @arrow_direction = :neutral
      unless current_period_averages.empty? || previous_period_averages.empty?
        arrow_direction_setter_if_data_available(current_period_averages.fetch(test_index), previous_period_averages.fetch(test_index))
      end
    end

    def arrow_direction_setter_if_data_available(current_period_averages, previous_period_averages)
      @arrow_direction = :up if current_period_averages.to_f > previous_period_averages.to_f
      @arrow_direction = :down if current_period_averages.to_f < previous_period_averages.to_f
      @arrow_direction = :neural if current_period_averages.to_f == previous_period_averages.to_f
    end
end
