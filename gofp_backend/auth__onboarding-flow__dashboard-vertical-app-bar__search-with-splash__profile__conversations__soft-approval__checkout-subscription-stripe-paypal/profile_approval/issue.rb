class Issue < ActiveRecord::Base

  belongs_to :issueable, polymorphic: true

  scope :unresolved, ->{ where(resolved: false) }
  scope :resolved, ->{ where(resolved: true) }

  validates_presence_of :issueable, :description

end
