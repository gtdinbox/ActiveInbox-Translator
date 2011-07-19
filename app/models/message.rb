class Message < ActiveRecord::Base
  include GtdInboxSyncable

  belongs_to :locale
  validates :name, :length => {:minimum => 3}

  #
  # Synchronizes the message records with the entries of the content/locale/en_US/message.json
  # file in the Active-inbox plugin code repository.
  #

  sync_values_of :name do

    #GtdInboxRepo.pull
    message_filepath = Rails.configuration.gtdinbox_message_file
    message_file = File.open(message_filepath, 'r');
    messages = JSON.parse(message_file.read)
    messages.each{|key,message_record|
      messages[key] = message_record['message']
    }

    messages
  end

  #
  # Public:
  #
  # Generates view data organised by message name, en_US value, current_local value.
  # If the provided local is the default one, no local values will be returned.
  #
  # locale_id - The numeric identifier of a locale record.
  #
  # Returns an hash of message names and values
  #
  #
  def self.locale_with_masterlist(locale_id)
    @messages = {}
    master_locale = Rails.configuration.gtdinbox_master_locale

    master_list = Message.select("name, value").
                          where("locale_id = ?", master_locale.id)


    master_list.each do |message|
      @messages[message.name] = {
        :master_value => message.value,
        :locale_value => nil,
        :in_sync => nil
      }
    end

    unless locale_id === master_locale.id
      locale_list = Message.select("id, name, value, in_sync").
                            where("locale_id = ?", locale_id)

      locale_list.each do |message|
        @messages[message.name][:locale_value] = message.value
        @messages[message.name][:in_sync] = message.in_sync
        @messages[message.name][:id] = message.id
      end
    end
    @messages
  end




  private

  #
  # Calculates the percentage of translated messages.
  #
  # locale - An instance of the current Locale model.
  #
  # Returns a hash containing the total number of entries
  # in the default locale, the total number of entries in the 
  #

  def self.translation_stats(locale)
    master_locale = Rails.configuration.gtdinbox_master_locale

    total_master, total_locale = [
      Message.where(
        :locale_id => master_locale.id,
        :deleted => false
      ).count,

      Message.where(
        :locale_id => locale.id,
        :deleted => false
      ).count
    ]

    {:lang_code => locale.lang_code,
     :locale_id => locale.id,
     :master_count => total_master,
     :locale_count => total_locale,
     :fraction => total_master / total_locale,
     :percentage => "#{(total_locale*100)/total_master}%"
    }
  end

  #
  # Prepares the data for exporting messages into a zip bundle.
  #
  # export_id - The unique export identifier.
  # locale    - An locale model instance.
  #
  # Returns:
  #  An array of two value arrays containing the exported local as the first item, and the message.json file handle as the second one.
  #

  def self.export(export_id=Time.now.to_i, locale=Rails.configuration.gtdinbox_master_locale)
    messages = {}
    message_filepath = "#{Rails.configuration.gtdinbox_export_tmpdir}/#{locale.lang_code}-#{export_id}-messages.json"

    Message.where(
      :deleted => false,
      :locale_id => locale.id

    ).each {|record|
      messages[record.name] = {:message => record.value} unless record.value.strip.empty?
    }

    unless messages.empty?
      file = File.open(message_filepath, 'w')
      file.write(JSON.pretty_generate(messages))
      file.close
      [[locale.lang_code, file]]
    else
      []
    end
  end


end
