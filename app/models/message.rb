class Message < ActiveRecord::Base
  include GtdInboxSyncable

  sync_values_of :name do

    GtdInboxRepo.pull
    message_filepath = Rails.configuration.gtdinbox_message_file
    message_file = File.open(message_filepath, 'r');
    messages = JSON.parse(message_file.read)
    messages.each{|key,message_record|
      messages[key] = message_record['message']
    }

    messages
  end


  # delete me!
  def self.deprecated_export()
    export_dir = Rails.configuration.gtdinbox_export_dir
    bundle_filename = "#{export_dir}/#{Time.now.to_i}-export.zip"
    message_filepath = Rails.root.to_s + '/tmp/messages.json'
    messages = {}


    Message.where("deleted = ?", false).each {|record|  messages[record.name] = {:message => record.value}}

    file = File.open(message_filepath, 'w')
    file.write(JSON.pretty_generate(messages))
    file.close

    Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) do  |zipfile|
      zipfile.mkdir('en_US')
      zipfile.add( "en_US/messages.json", message_filepath)
    end

    File.chmod(0644, bundle_filename)
    FileUtils.remove(message_filepath)
    bundle_filename
  end


  def self.export(export_id=Time.now.to_i, locale='en_US')
    message_filepath = "#{Rails.configuration.gtdinbox_export_tmpdir}/#{locale}-#{export_id}-messages.json"
    messages = {}
    Message.where("deleted = ?", false).each {|record|  messages[record.name] = {:message => record.value}}

    file = File.open(message_filepath, 'w')
    file.write(JSON.pretty_generate(messages))
    file.close

    [[locale, file]]
  end




end
