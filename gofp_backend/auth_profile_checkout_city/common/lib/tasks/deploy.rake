#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

ENVIRONMENTS = {
  #add other envs here
  :staging => 'boilerplate-staging'
}

namespace :deploy do
  ENVIRONMENTS.keys.each do |env|
    desc "Deploy to #{env}"
    task env do
      current_branch = `git branch | grep ^* | awk '{ print $2 }'`.strip
      puts current_branch
      Rake::Task['deploy:before_deploy'].invoke(env, current_branch)
      Rake::Task['deploy:update_code'].invoke(env, current_branch)
      Rake::Task['deploy:after_deploy'].invoke(env, current_branch)
    end
  end

  task :before_deploy, :env, :branch do |t, args|
    puts "Deploying #{args[:branch]} to #{args[:env]}"

    if args[:env] == :production && args[:branch] != 'master'
      fail "Can't deploy non-master branch to production. You need be on master, current branch=#{args[:branch]}"
    end
  end

  task :after_deploy, :env, :branch do |t, args|
    puts "Deployment Complete"
  end

  task :update_code, :env, :branch do |t, args|
    FileUtils.cd Rails.root do
      puts "Updating #{ENVIRONMENTS[args[:env]]} with branch #{args[:branch]}"
      sh "git-up"
      tag = "#{args[:env]}#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
      puts "Tagging release as '#{tag}'"
      sh "git tag -a #{tag} -m 'Tagged release #{args[:branch]}'"
      sh "git push --tags"
      sh "heroku maintenance:on --app #{ENVIRONMENTS[args[:env]]}"
      sh "heroku pgbackups:capture --expire --app #{ENVIRONMENTS[args[:env]]}"
      sh "git push git@heroku.com:#{ENVIRONMENTS[args[:env]]}.git +#{args[:branch]}:master -ff"
      sh "heroku run rake db:migrate --app #{ENVIRONMENTS[args[:env]]}"
      sh "heroku restart --app #{ENVIRONMENTS[args[:env]]}"
      sh "heroku maintenance:off --app #{ENVIRONMENTS[args[:env]]}"
    end
  end
end
