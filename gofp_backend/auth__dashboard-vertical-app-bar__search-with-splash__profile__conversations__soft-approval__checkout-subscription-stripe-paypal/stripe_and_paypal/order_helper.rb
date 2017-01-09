module OrderHelper
  def summary_section_checkout_page(header, &block)
    ret = <<-END
      <div class='row margin-bottom-30px'>
        <div class='col-sm-12'>
          <div class='row'>
            <div class='col-sm-12'>
              <div class='heading_summary'>
                #{header}
              </div>
            </div>
          </div>
          <hr />
          <div class='row'>
            <div class='col-sm-12'>
              #{capture(&block)}
            </div>
          </div>
        </div>
      </div>
    END
    return ret.html_safe
  end

  def cc_with_only_last_4(last_4)
    ast = "#{iconf('asterisk', nil, 'font-size:11px')}"
    "#{ast*4} #{ast*4} #{ast*4} #{last_4}".html_safe
  end

end