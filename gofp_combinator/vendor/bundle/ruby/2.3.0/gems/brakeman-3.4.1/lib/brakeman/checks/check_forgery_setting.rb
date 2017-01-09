require 'brakeman/checks/base_check'

#Checks that +protect_from_forgery+ is set in the ApplicationController.
#
#Also warns for CSRF weakness in certain versions of Rails:
#http://groups.google.com/group/rubyonrails-security/browse_thread/thread/2d95a3cc23e03665
class Brakeman::CheckForgerySetting < Brakeman::BaseCheck
  Brakeman::Checks.add self

  @description = "Verifies that protect_from_forgery is enabled in direct subclasses of ActionController::Base"

  def run_check
    tracker.controllers
    .select { |_, controller| controller.parent == :"ActionController::Base" }
    .each do |name, controller|
      if controller and not controller.protect_from_forgery?
        csrf_warning :controller => name,
          :warning_code => :csrf_protection_missing,
          :message => "'protect_from_forgery' should be called in #{name}",
          :file => controller.file,
          :line => controller.top_line
      elsif version_between? "4.0.0", "100.0.0" and forgery_opts = controller.options[:protect_from_forgery]
        unless forgery_opts.is_a?(Array) and sexp?(forgery_opts.first) and
          access_arg = hash_access(forgery_opts.first.first_arg, :with) and symbol? access_arg and
          access_arg.value == :exception

          args = {
            :controller => name,
            :warning_type => "Cross-Site Request Forgery",
            :warning_code => :csrf_not_protected_by_raising_exception,
            :message => "protect_from_forgery should be configured with 'with: :exception'",
            :confidence => CONFIDENCE[:med],
            :file => controller.file
          }

          args.merge!(:code => forgery_opts.first) if forgery_opts.is_a?(Array)

          csrf_warning args
        end

      end

      if controller.options[:protect_from_forgery]
        check_cve_2011_0447
      end
    end
  end

  def csrf_warning opts
    opts = {
      :controller => :ApplicationController,
      :warning_type => "Cross-Site Request Forgery",
      :confidence => CONFIDENCE[:high]
    }.merge opts

    warn opts
  end

  def check_cve_2011_0447
    @warned_cve_2011_0447 ||= false
    return if @warned_cve_2011_0447

    if version_between? "2.1.0", "2.3.10"
      new_version = "2.3.11"
    elsif version_between? "3.0.0", "3.0.3"
      new_version = "3.0.4"
    else
      return
    end

    @warned_cve_2011_0447 = true # only warn once

    csrf_warning :warning_code => :CVE_2011_0447,
      :message => "CSRF protection is flawed in unpatched versions of Rails #{rails_version} (CVE-2011-0447). Upgrade to #{new_version} or apply patches as needed",
      :gem_info => gemfile_or_environment,
      :file => nil,
      :link_path => "https://groups.google.com/d/topic/rubyonrails-security/LZWjzCPgNmU/discussion"
  end
end
