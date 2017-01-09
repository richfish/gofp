class ProfilePublishManager

  attr_accessor :profile

  def initialize(profile=nil)
    @profile = profile
  end

  def publish
    if profile.unpublished? || profile.fixing_issue_unpublished?
      profile.update_attribute(:status, Profile::STATUS_PENDING_APPROVAL)
      AdminMailer.delay.approval_notice(profile)
    else
      profile.status = Profile::STATUS_PUBLISHED
      profile.save
    end
  end

  def unpublish
    profile.status = Program::STATUS_NEW
    profile.save
  end

  def grant_profile_approval_and_publish
    raise Exceptions::UnresolvedIssues if profile.issues.unresolved.present?
    program = profile.user.find_pending_approval_program

    ProfileMailer.delay.publish_notice_to_user(profile, program)
    profile.status = Profile::STATUS_PUBLISHED
    profile.flagged = false
    profile.save

    program.status = Program::STATUS_PUBLISHED
    program.save
  end

  def profile_issue_setup
    profile.flagged = true
    profile.status = Profile::STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
    profile.save

    program = profile.user.find_pending_approval_program
    program.update_column(:status, Program::STATUS_NEW)

    ProfileMailer.delay.alert_user_of_profile_issue(profile)
  end

  def reject_profile
    profile.status = Profile::STATUS_REJECTED
    profile.save

    AdminMailer.followup_on_rejection_of_user(profile).delay
  end

  def emergency_block
    profile.status = Profile::STATUS_BLOCKED
    profile.save
  end
  #
  # private
  #
  # def approval_fields_changed?
  #   Profile::APPROVAL_FIELDS.any?{ |field| profile.send("#{field}_changed?".to_sym) }
  # end

end
