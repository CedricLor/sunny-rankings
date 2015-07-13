function setSensorsForRatings() {
  $('.rating-input').click(function() {

    var vote_impact_wrapper = $(this).parents(".my-rating-wrapper").next(".vote-impact-wrapper"),
        old_answers_count = parseInt(vote_impact_wrapper.attr("data-prior-answers-count")),
        old_answers_total = parseInt(vote_impact_wrapper.attr("data-prior-answers-total")),
        old_average_rating = old_answers_total / old_answers_count,
        new_answers_count = old_answers_count + 1,
        new_answers_total = old_answers_total + parseInt($(this).attr("value")),
        new_average_rating = new_answers_total / new_answers_count,
        new_average_rating_rounded = (Math.round(new_average_rating * 10)/10).toFixed(1);

    $(vote_impact_wrapper).find(".your-impact").removeClass("my-hidden-class")
    $(vote_impact_wrapper).find(".your-impact .average").text(new_average_rating_rounded);

    if (new_average_rating > old_average_rating) {
      $(vote_impact_wrapper).find(".your-impact .trend-badge i").addClass("rotate-right-up").removeClass("rotate-right-down rotate-neutral");
    } else if (new_average_rating < old_average_rating) {
      $(vote_impact_wrapper).find(".your-impact .trend-badge i").addClass("rotate-right-down").removeClass("rotate-right-up rotate-neutral");
    } else {
      $(vote_impact_wrapper).find(".your-impact .trend-badge i").addClass("rotate-neutral").removeClass("rotate-right-up rotate-right-down");
    }

  });
}
