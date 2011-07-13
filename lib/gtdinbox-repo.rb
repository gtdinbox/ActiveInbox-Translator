class GtdInboxRepo
  @@repo_uri = Rails.configuration.gtdinbox_repo_uri
  @@repo_dir = Rails.configuration.gtdinbox_repo_dir

  def self.pull
    `cd #{@@repo_dir} && git pull origin master`
  end

  def self.clone
    `git clone --depth=1 #{@@repo_uri} #{@@repo_dir}`
  end

  def self.exists?
    File.exists?(@@repo_dir)
  end
end
