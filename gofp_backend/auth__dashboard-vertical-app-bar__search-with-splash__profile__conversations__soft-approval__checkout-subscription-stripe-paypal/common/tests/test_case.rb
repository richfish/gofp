#require 'sidekiq/testing'
#Sidekiq::Testing.inline! #runs jobs immediately, no queue

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  teardown do
    #
  end

  def mailer_size
    ActionMailer::Base.deliveries.size + Sidekiq::Extensions::DelayedMailer.jobs.size
  end

  def clear_mailer
    ActionMailer::Base.deliveries.clear
    Sidekiq::Extensions::DelayedMailer.jobs.clear
  end

  def mail_subject_contains?(str, opts={})
    index = opts[:index] || 0
    delayed = opts[:delayed]
    subject = if delayed
      Sidekiq::Extensions::DelayedMailer.jobs[index]["args"].to_s
    else
      ActionMailer::Base.deliveries[index].subject
    end
    !!subject.downcase[str]
  end

  def performed_at_time(job)
    Time.at job["at"].to_i
  end

  def performated_at_in_range?(time, low, high)
    time > low.from_now && time < high.from_now
  end

  def strf_format
    Schedule::DATEFORMAT + " " + Schedule::TIMEFORMAT
  end

  def local_timezone_wrapper(artist, time)
    city = artist.city
    tz = CITY_TIMEZONE_HASH[city]
    ActiveSupport::TimeZone[tz].parse(time.to_s)
  end

  def nillify_params(params)
    Hash[params.map{|k,v| [k, nil]}]
  end

  def refute_partial(partial)
    assert_template partial: partial, count: 0
  end

  def date_and_time_in_local_timezone(str_time, hour=nil)
    time = ActiveSupport::TimeZone["Pacific Time (US & Canada)"].parse(str_time.to_s)
    time = time.change({hour: hour}) if hour
    return time
  end

end