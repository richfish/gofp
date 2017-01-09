module BootstrapHelper

  class Modal < ApplicationHelper::ObjectHelperBase
    attr_accessor :header, :body, :footer

    def header(&block)
      @header = @ctx.capture(&block)
      return nil
    end

    def body(&block)
      @body = @ctx.capture(&block)
      return nil
    end

    def footer(&block)
      @footer = @ctx.capture(&block)
      return nil
    end

    def to_s
      additional_attributes = @opts.map{|k,v| "#{k}='#{v}'"}.join(' ')
      ret = ""
      ret += <<-END
        <div class="modal fade" id="#{@id}" tabindex="-1" aria-labelledby="#{@uuid}" role="dialog" aria-hidden="true" #{additional_attributes}>
          <div class="modal-dialog #{@opts[:size]} #{('modal_flat' if @opts[:flat])}">
            <div class="modal-content">
      END
      if @header
        ret += <<-END
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="#{@uuid}">#{@header}</h4>
          </div>
        END
      end
      ret += <<-END
        <div class="modal-body">
          #{@body}
        </div>
      END
      if @footer
        ret += <<-END
          <div class="modal-footer">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
              #{@footer}
            </button>
          </div>
        END
      end
      ret += "</div></div></div>"
      ret.html_safe
    end
  end


  class Accordion < ApplicationHelper::ObjectHelperBase
    attr_accessor :id

    def initialize(id=nil, &block)
      @group_count = 0
      @groups = ""
      super(id, &block)
    end

    def group(title, opts={}, &block)
      @group_count += 1
      group_id = "#{@uuid}_#{@group_count}"
      @groups += <<-END
        <div class="panel panel-default">
          <div class="panel-heading">
            <h4 class="panel-title">
              <a data-toggle="collapse" data-parent="##{id}" href="##{group_id}">
                #{opts[:icon]}
                #{title}
              </a>
            </h4>
          </div>
          <div id="#{group_id}" class="panel-collapse collapse #{opts[:class]}">
            <div class="panel-body">
              #{@ctx.capture(&block)}
            </div>
          </div>
        </div>
      END
      return nil
    end

    def to_s
      ret =<<-END
        <div class="panel-group" id="#{@id}">
          #{@groups}
        </div>
      END
      ret.html_safe
    end
  end

end
