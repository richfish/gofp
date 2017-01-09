module BookableAssetHelper

  def bookable_asset_formatted(bookable_asset, opts={})
    confirmed_text = if opts[:confirmed]
       bookable_asset.confirmed ? "- confirmed" : "- unconfirmed"
    else "" end
    note_to_provider_text = opts[:truncate] ? truncate(bookable_asset.note_to_provider, length: 100) : bookable_asset.note_to_provider
    note_to_provider = opts[:note] ? "- <i>#{note_to_provider_text.presence || 'no note given'}</i>" : ""
    amount = bookable_asset.beers ? "You get Beer" : number_to_currency((bookable_asset.amount_cents.to_i)/100)
    ret = <<-END
      <div class='bookable_asset_basic_info'>
        #{bookable_asset.local_date} - #{bookable_asset.local_time} - #{bookable_asset.num_hours} hours - #{amount} <i>#{confirmed_text.capitalize}</i>
        #{note_to_provider}
        <p>#{iconf('map-marker')} #{bookable_asset.location.location }</p>
      </div>
    END
    refund_amount = bookable_asset.refund.try(:amount_cents)
    if refund_amount
      refund_amount = number_to_currency(refund_amount.to_f/100)
      ret += <<-END
        <div class='dispute_refund'>
          &emsp; Dispute plus refund: #{refund_amount}
        </div>
      END
    end
    return ret.html_safe
  end

  def bookable_asset_formatted_customer(bookable_asset)
    artist_name = bookable_asset.artist.full_name
    name_and_link = "<a href=#{user_path(id: bookable_asset.artist.id)}>#{artist_name}</a>"
    full_location = bookable_asset.location.location + ', ' + bookable_asset.artist.city
    ret = <<-END
      <div class='bookable_asset_basic_info'>
        #{name_and_link} - #{bookable_asset.local_date} - #{bookable_asset.local_time} - #{bookable_asset.num_hours} hours
        <p><a href='#{regular_map_url(full_location)}' target='_blank'>#{iconf('map-marker')} #{full_location}</a></p>
      </div>
    END
    return ret.html_safe
  end

end