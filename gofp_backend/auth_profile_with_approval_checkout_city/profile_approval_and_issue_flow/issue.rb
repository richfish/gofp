class Issue < ActiveRecord::Base
  after_create :issueable_setup

  #must be after, because profile.issues.unresolved
  after_save :issueable_conclude, if: ->{ self.resolved_changed? && self.resolved }

  belongs_to :issueable, polymorphic: true

  scope :unresolved, ->{ where(resolved: false) }
  scope :resolved, ->{ where(resolved: true) }

  validates_presence_of :issueable, :description

  def issueable_setup
    if self.issueable.is_a?(Profile)
      ProfilePublishManager.new(self.issueable).profile_issue_setup
    end
  end

  def issueable_conclude
    if self.issueable.is_a?(Profile)
      ProfilePublishManager.new(self.issueable).grant_profile_approval_and_publish
    end
  end
end
