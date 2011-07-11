namespace :gtdinbox do
  desc "Clone ActiveInbox plugin code from the Github repository"
  task :clone_repo => :environment do
    repo_uri = Rails.configuration.gtdinbox_repo_uri
    repo_dir = Rails.configuration.gtdinbox_repo_dir
    `git clone --depth=1 #{repo_uri} #{repo_dir}`
  end
end
