class Message < ActiveRecord::Base
  include GtdInboxSyncable

  belongs_to :locale


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
