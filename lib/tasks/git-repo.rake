require 'pp'
namespace :gtdinbox do
  desc "Clone ActiveInbox plugin code from the Github repository"

  task :clone_repo => :environment do
    unless GtdInboxRepo.exist?
      GtdInboxRepo.clone
    end
  end

  desc "Synchronoises message records with json file in github repository"
  task :sync_messages => :environment do
    pp Message.sync!
  end

  desc "Synchronoises page records with html files in github repository"
  task :sync_pages => :environment do
    pp Page.sync!
  end

  task "export messages into a zip archive"
  task :export_messages => :environment do
    p Message.deprecated_export
  end

  task "export messages into a zip archive [new]"
  task :proper_export_messages => :environment do
    export_id=Time.now.to_i
    export_data = Message.export(export_id).concat(Page.export(export_id))
    bundler = ZipBundler.new(export_data, export_id)
    bundler.bundle!
  end
end
