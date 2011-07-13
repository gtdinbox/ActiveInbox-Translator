class Message < ActiveRecord::Base
  include GtdInboxSyncable

  @@master_locale = Rails.configuration.gtdinbox_master_locale

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

  #
  # Generates a list of messages organised by 
  # message name, en_US value, current_local value
  #
  #
  #
  def self.locale_with_masterlist(locale_id)
    @messages = {}

    master_list = Message.select("name, value").
                          where("locale_id = ?", @@master_locale.id)

    locale_list = Message.select("name, value, in_sync").
                          where("locale_id = ?", locale_id)


    master_list.each do |message|
      @messages[message.name] = {
        :master_value => message.value,
        :locale_value => nil,
        :in_sync => nil
      }
    end
    locale_list.each do |message|
      @messages[message.name] = {
        :locale_value => message.value,
        :in_sync => message.in_sync
      }
    end


    @messages
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
