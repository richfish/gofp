ActiveAdmin.register Profile do

  #permit_params :status, :vip_status

  show do |profile|
    attributes_table do
      row :status
      row :first_name
      row :last_name
      row :flagged
      row :created_at
      row :updated_at
      row :avatar_file_name
      row "Pic medium" do
        image_tag URI.unescape(profile.avatar.url(:medium))
      end
      row "link to original" do
        link_to profile.avatar.url, URI.unescape(profile.avatar.url), target: "_blank"
      end

      row "Profile Issues" do
        table_for profile.issues do |issue|
          issue.column('Description') { |issue| issue.description }
          issue.column('Resolved') { |issue| issue.resolved ? 'YES' : 'NO' }
          issue.column('RESOLVE IT') do |issue|
            if issue.resolved
              "(resolved)"
            else
              link_to 'RESOLVE IT BE CAREFUL', resolve_issue_tibetan_sherpa_access_profile_path(profile), method: :put
            end
          end
        end
      end

      row "CREATE ISSUE" do
        render :file => "#{Rails.root}/app/admin/views/create_issue", locals: {profile: profile}
      end

      row "BELOW IS IMPORTANT" do
      end

      row "APPROVE THIS USER" do
        if profile.unpublished_pending_approval?
          link_to "APPROVE OFFICIALLY", approve_profile_tibetan_sherpa_access_profile_path(profile), method: :get
       else "(approved)" end
      end

      row "BELOW IS ALSO IMPORTANT" do
      end

      row "EMERGENCY BLOCK THIS USER FROM PUBLIC" do
        link_to "EMERGENCY BLOCK", emergency_block_tibetan_sherpa_access_profile_path(profile), method: :get
      end

      row "BELOW IS ALSO IMPORTANT" do
      end

      row "REJECT THIS USER" do
        link_to "REJECT USER", reject_profile_tibetan_sherpa_access_profile_path(profile), method: :get
      end

    end
  end

  member_action :emergency_block, method: :get do
    profile = Profile.find(params[:id])
    ProfilePublishManager.new(profile).emergency_block
    flash[:notice] = "Profile blocked from public appearance - emergency situation"
    redirect_to tibetan_sherpa_access_profile_path(profile)
  end

  member_action :approve_profile, method: :get do
    profile = Profile.find(params[:id])
    ProfilePublishManager.new(profile).grant_profile_approval_and_publish
    flash[:notice] = "Approved user - they are now in the search results"
    redirect_to tibetan_sherpa_access_profile_path(profile)
  end

  member_action :reject_profile, method: :put do
    profile = Profile.find(params[:id])
    ProfilePublishManager.new(profile).reject_profile
    flash[:notice] = "Profile/ User Rejected"
    redirect_to tibetan_sherpa_access_profile_path(profile)
  end

  member_action :resolve_issue, method: :put do
    profile = Profile.find(params[:id])
    issues = profile.issues.unresolved
    raise Exceptions::UnresolvedIssues if issues.size > 1
    return if issues.size == 0

    issue = issues.first
    issue.resolved = true
    issue.save
    flash[:notice] = "Resolved Issue"
    redirect_to tibetan_sherpa_access_profile_path(profile)
  end

  member_action :create_issue, method: :post do
    profile = Profile.find(params[:id])
    issues_count = profile.issues.unresolved.size
    raise Exceptions::UnresolvedIssues if issues_count > 0

    Issue.create(issueable: profile, description: params[:description])
    flash[:notice] = "Issue Created"
    redirect_to tibetan_sherpa_access_profile_path(profile)
  end

end
