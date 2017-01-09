class ProfileAndBookableAssetPublishManager

  attr_accessor :bookable_asset, :profile

  def initialize(bookable_asset=nil, profile=nil)
    @bookable_asset = bookable_asset
    @profile = profile || bookable_asset.user.profile
  end

  def publish
    if profile.unpublished? || profile.fixing_issue_unpublished?
      bookable_asset.status = BookableAsset::STATUS_PENDING_APPROVAL
      profile.status = Profile::STATUS_PENDING_APPROVAL
      bookable_asset.save
      profile.save
      AdminMailer.delay.approval_notice(profile)
    else
      bookable_asset.status = Profile::STATUS_PUBLISHED
      bookable_asset.save
    end
  end

  def unpublish
    bookable_asset.status = BookableAsset::STATUS_NEW
    bookable_asset.save
  end

  def grant_profile_approval_and_publish
    raise Exceptions::UnresolvedIssues if profile.issues.unresolved.present?
    bookable_asset = profile.user.bookable_assets.pending_approval.first

    ProfileMailer.delay.publish_notice_to_user(profile, bookable_asset) #unless profile.fixing_issue_published?
    profile.status = Profile::STATUS_PUBLISHED
    profile.flagged = false
    profile.save

    bookable_asset.status = BookableAsset::STATUS_PUBLISHED
    bookable_asset.save
  end

  def profile_issue_setup
    profile.flagged = true
    profile.status = Profile::STATUS_FIX_ISSUE_WINDOW_UNPUBLISHED
    profile.save

    bookable_asset = profile.user.bookable_assets.pending_approval.first
    bookable_asset.update_column(:status, BookableAsset::STATUS_NEW)

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