ONLY ONE TIME YOU ATTEMPT TO PUBLISH; NEVER LEAVES SEARCH RESULTS AFTER PUBLISH UNLESS MARKED ON EDIT PROFILE
CANNOT EDIT AFTER SUBMITTING TO PUBLISH FIRST OR SUBSEQUENT TIMES UNTIL APPROVAL
PROFILE CAN ONLY HAVE 1 PENDING_PROFILE_EDITS OBJECT AT MOST (DELETE AFTER USE)

class ProfilePublishManager

  attr_accessor :profile

  def initialize(profile)
    @profile = profile
  end

  def first_publish
    profile.status = Profile::STATUS_UNPUBLISHED_PENDING_APPROVAL
    profile.save
    AdminMailer.delay.approval_notice(profile)
  end

  # def subsequent_updates
  #   if profile.valid?
  #     if profile.fixing_issue_published?
  #       ProfileMailer.delay.resolve_published_user_issue_notice(profile)
  #     end
  #     if profile.published? && (approval_fields_changed? || profile.image_changed)
  #       ProfileMailer.delay.re_approval_notice(profile)
  #       profile.image_changed = false
  #     end
  #     profile.save
  #   else false end
  # end
  #
  def grant_profile_approval_and_publish
    raise Exceptions::UnresolvedIssues if profile.issues.unresolved.present?
    ProfileMailer.delay.publish_notice_to_user(profile) unless profile.fixing_issue_published?
    profile.status = Profile::STATUS_PUBLISHED
    profile.flagged = false
    profile.save
  end

  def profile_issue_setup
    profile.flagged = true
    profile.status = Profile::STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
    profile.save
    ProfileMailer.delay.alert_user_of_profile_issue(profile)
  end

  def reject_profile
    profile.status = Profile::STATUS_REJECTED
    profile.save

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