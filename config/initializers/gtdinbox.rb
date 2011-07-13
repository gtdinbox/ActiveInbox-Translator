#GTDInbox repository location
conf = ActiveInboxTranslator::Application.config

conf.gtdinbox_repo_uri = "git@github.com:gtdinbox/GTDInbox.git"
conf.gtdinbox_repo_dir =  Rails.root.to_s + "/vendor/gtdinbox-repo"
conf.gtdinbox_message_file = conf.gtdinbox_repo_dir + "/content/locales/en_US/messages.json"
conf.gtdinbox_template_dir = conf.gtdinbox_repo_dir + "/content/locales/en_US"
conf.gtdinbox_export_dir = Rails.root.to_s + "/public/exports"
conf.gtdinbox_export_tmpdir = Rails.root.to_s + '/tmp/exports'

if Locale.table_exists?
  conf.gtdinbox_master_locale = Locale.find_by_is_master(true)
end
# required libraries

require 'zip/zip'
require 'zip/zipfilesystem'
require 'fileutils'
require 'pp'

require Rails.root.to_s + "/lib/syncable"
require Rails.root.to_s + "/lib/gtdinbox-repo"
require Rails.root.to_s + "/lib/zipbundler"

# Default directories (to be created at runtime if they do not exist yet)

[ conf.gtdinbox_export_dir,
  conf.gtdinbox_export_tmpdir].each do |dir|
  unless File.directory?(dir)
    Dir.mkdir(dir)
  end
end

