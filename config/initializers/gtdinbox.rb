#GTDInbox repository location
conf = ActiveInboxTranslator::Application.config

conf.gtdinbox_repo_uri = "git@github.com:gtdinbox/GTDInbox.git"
conf.gtdinbox_repo_dir = "vendor/gtdinbox-repo"
conf.gtdinbox_message_file = conf.gtdinbox_repo_dir + "/content/locales/en_US/messages.json"
conf.gtdinbox_template_dir = conf.gtdinbox_repo_dir + "/content/locales/en_US"


