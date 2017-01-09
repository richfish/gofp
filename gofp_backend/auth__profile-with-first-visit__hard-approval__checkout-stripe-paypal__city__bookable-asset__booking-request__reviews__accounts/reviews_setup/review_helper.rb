module ReviewHelper

  def star_group
    star = iconf('star')
    empty_star = iconf('star-o')
    ret = <<-END
    <span class='star_group'>
      <span class="stars stars5">
        <span data-rating="1">
          #{star}
        </span>
        <span data-rating="2">
          #{star}
        </span>
        <span data-rating="3">
          #{star}
        </span>
        <span data-rating="4">
          #{star}
        </span>
        <span data-rating="5">
          #{star}
        </span>
        <span data-no-click='true'>Excellent</span>
      </span>
      <span class="stars stars4" style="display:none">
        <span data-rating="1">
          #{star}
        </span>
        <span data-rating="2">
          #{star}
        </span>
        <span data-rating="3">
          #{star}
        </span>
        <span data-rating="4">
          #{star}
        </span>
        <span data-rating="5">
          #{empty_star}
        </span>
        <span data-no-click='true'>Pretty Good</span>
      </span>
      <span class="stars stars3" style="display:none">
        <span data-rating="1">
          #{star}
        </span>
        <span data-rating="2">
          #{star}
        </span>
        <span data-rating="3">
          #{star}
        </span>
        <span data-rating="4">
          #{empty_star}
        </span>
        <span data-rating="5">
          #{empty_star}
        </span>
        <span data-no-click='true'>Good</span>
      </span>
      <span class="stars stars2" style="display:none">
        <span data-rating="1">
          #{star}
        </span>
        <span data-rating="2">
          #{star}
        </span>
        <span data-rating="3">
          #{empty_star}
        </span>
        <span data-rating="4">
          #{empty_star}
        </span>
        <span data-rating="5">
          #{empty_star}
        </span>
        <span data-no-click='true'>Not so Good</span>
      </span>
      <span class="stars stars1" style="display:none">
        <span data-rating="1">
          #{star}
        </span>
        <span data-rating="2">
          #{empty_star}
        </span>
        <span data-rating="3">
          #{empty_star}
        </span>
        <span data-rating="4">
          #{empty_star}
        </span>
        <span data-rating="5">
          #{empty_star}
        </span>
        <span data-no-click='true'>Pretty Bad</span>
      </span>
    </span>
    END
    return ret.html_safe
  end

  def num_to_stars(num)
    num = num || 0
    star = "#{iconf('star')}"
    empty_star = "#{iconf('star-o')}"
    half_star = "#{iconf('star-half-full')}"
    num = 1 if num < 1

    ret = ""
    if num % 1 == 0
      ret += star * num
      empty = 5 - num
      if empty > 0
        ret += empty_star * empty
      end
    else
      num = ("%.1f" % num)
      whole_stars_num = num.to_s.first.to_i
      decimal_digit = num.to_s.last.to_i
      ret += star * whole_stars_num
      if (5 - decimal_digit).abs < 3
        ret += half_star
      elsif (10 - decimal_digit) < 5
        ret += star
      else
        ret += empty_star
      end
      empty_num = 5 - (whole_stars_num + 1)
      ret += empty_star * empty_num
    end
    ret.html_safe
  end

  def take_and_sort_recent_reviews(reviews)
    reviews.reverse.take(ReviewDisplayPolicy::DISPLAY_SAMPLE_NUM).sort_by{|x| x.booking.local_time_raw }
  end

  # def review_meta_data_formatted(artist)
  #   star_display = num_to_stars(artist.avg_rating)
  #   rating_s = artist.reviews_count == 1 ? "rating" : "ratings"
  #   ret = <<-END
  #     <div class='title_small'>
  #       #{star_display} <span class='small_italic'> on <b>#{artist.reviews_count}</b> #{rating_s}</span>
  #     </div>
  #   END
  #   ret.html_safe
  # end
end






