class ConversationDecorator < Draper::Decorator
  delegate_all

  include ActionView::Helpers

  def instructor_name
    "Test User-Name"
    #bootcamp.user.full_name
  end

  def display_title
    "Test Title Here"
    # bc_name = bootcamp.name
    # guest_name = self.guest_name
    # ret = "<span>#{bc_name}</span><span>#{guest_name}</span>"
    # ret.html_safe
  end

  def display_date
    "Jan 20, 2016"
    # local_time = h.local_time_for_user(bootcamp.user, self.created_at)
    # local_time.strftime(Program::DATEFORMAT)
  end

  def bootcamp_display_date
    "Jan 20, 2016"
    # ret = self.bootcamp.rolling ? "Proposed Start Date <b>#{self.potential_date}</b>" : "Start Date: #{self.bootcamp.start_date}"
    # ret.html_safe
  end

  def cost
    "$9.00"
    # number_to_currency(self.bootcamp.amount_cents.to_f/100, precision: 0)
  end

end
