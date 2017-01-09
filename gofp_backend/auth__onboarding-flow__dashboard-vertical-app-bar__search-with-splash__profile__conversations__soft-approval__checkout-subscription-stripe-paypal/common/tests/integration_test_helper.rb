require 'test_helper'
require 'database_cleaner'
require 'capybara/poltergeist'

#Capybara Cheatsheet: https://gist.github.com/zhengjia/428105
Capybara.app = Boilterplate::Application
#Capybara.default_driver = :selenium
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_options: ["--proxy-type=none"])
end
Capybara.default_driver = Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers
  Warden.test_mode!

  self.use_transactional_fixtures = false

  DatabaseCleaner.strategy = :truncation
  teardown do
    Warden.test_reset!
    logout(:user) if @user
    DatabaseCleaner.clean
  end
end

module I18n
  class<< self
    def t(key, options={})
      I18n.translate(key, options)
    end
  end
end

def login_admin_user(admin_user)
  login_as(admin_user, :scope => :admin_user)
end

def login_user(user)
  login_as(user, :scope => :user)
end

def walk_status_code_assert
  code = page.status_code
  20.times do
    unless code
      sleep(0.2)
      code = page.status_code
    end
  end
  assert non_error_status?(code), "STATUS: #{code}\nRESPONSE BODY: #{page.body}"
end

def walk_controller_matcher(controller_name)
  ->(route){ route.defaults[:controller] == controller_name }
end

def walk_starts_with_path_matcher(path, options = {})
  lambda do |route|
    url = route.path.spec.to_s
    exclude = options.fetch(:exclude, []).map{ |pattern| url.starts_with?(pattern) }.inject(:|)
    url.starts_with?(path) && !exclude
  end
end

def walk_js_errors_assert
  if page.driver.respond_to?(:error_messages)
    assert page.driver.error_messages.blank?, page.driver.error_messages.to_s
  end
end

def walk_not_login_page_assert
  if @user
    refute page.has_selector?('#user_password'), "login screen detected although we're supposed to be logged in"
  end
end

def walk_resize_window_assert
  3.times do
    [[200,100],[400,200],[600,300],[800,400],[1000,500]].each do |pair|
      page.driver.resize(pair[0], pair[1])
    end
  end
end

def walk_resource_network_traffic
  resource_status_and_url = page.driver.network_traffic.map do |x|
    (res = x.response_parts.first).nil? ? nil : [res.status, res.url] #occasional, unpredictable nil #network_traffic
  end.compact

  resource_status_and_url.each do |arr|
    next if arr[0] == 401 #skip permission errors (driver limitation), include range of other errors
    assert non_error_status?(arr[0]), "could not retrieve resource: #{arr[1]}, status: #{arr[0]}"
  end
  page.driver.clear_network_traffic
end

def walk_resolve_url(route, ids)
  ret = route.path
  ret = ret.spec.left.to_s
  return ret unless ids

  if ret =~ /(\w+)\/\:id/
    id = "#{$1.singularize}"
    raise "couldnt resolve :id in #{ret}. Need '#{id}' to be present in #{ids}" unless ids[id]
    ret.gsub!(/\:id/, ids[id].to_s)
  end

  [/\:(\w+)_id/, /\:(\w+)/].each do |reg|
    ret.gsub!(reg) do |match|
      replacement = ids[$1]
      raise "couldnt resolve '#{$1}'...needs to be present in #{ids}" unless replacement
      replacement
    end
  end

  return ret
end

def walk(matcher, options = {})
  raise "matcher cant be blank" unless matcher

  urls = Set.new
  Rails.application.routes.routes.each do |route|
    next unless route.verb === "GET"

    if matcher.is_a?(String)
      next unless route.spec.starts_with?(matcher)
    elsif matcher.is_a?(Proc)
      next unless matcher.call(route)
    else
      raise "can't handle matcher class #{matcher.class}"
    end

    url = walk_resolve_url(route, nil)
    fingerprint = "GET_#{url}"
    next if urls.include?(fingerprint)
    urls.add(fingerprint)

    test "[OK] GET #{url}" do
      resolved_url = walk_resolve_url(route, HashWithIndifferentAccess.new(@ids || {}))
      #puts "visiting #{resolved_url}"
      login_user(@user) if @user
      visit resolved_url
      assert_equal(resolved_url, current_path) if options[:no_redirections]
      walk_status_code_assert
      walk_not_login_page_assert
      walk_resize_window_assert
      ##additional possible tests
      #- enter text in boxes => check for js errors
      #- change radios => check for js errors
      #- change selects => check for js errors
      #- clicks => check for js errors
      #- hover over images, links => check for js errors
      walk_js_errors_assert
      walk_resource_network_traffic
    end
  end

  if urls.size == 0
    raise "urls.size==0 - no controller action matched"
  end

  private

  def non_error_status?(code)
    200 <= code && code < 400
  end
end





