class Message < ActiveRecord::Base
  include Grit

  # Public:
  #
  # Synchronises the messages collection with the entries in the entries listed
  # GtdInbox code repository file 'content/locals/en_US/messages.json'
  #
  # Returns a hash containing sincronisation statistics.
  #

  def self.sync
    self.git_pull

    message_filepath = Rails.configuration.gtdinbox_message_file
    message_file = File.open(message_filepath, 'r');
    messages = JSON.parse(message_file.read)
    message_statuses = []

    message_status_counts = {}

    message_status_counts[:deleted] = Message.update_all ["deleted = ?", true], ["name NOT IN (?)", messages.keys ]

    messages.each do |message_name, record|
      status = self.sync_record(message_name, record['message'])
      message_statuses.push(status)
    end


    message_statuses.uniq.each do |status|
      message_status_counts[status] = message_statuses.grep(status).size
    end

    message_status_counts
  end


  private

  #
  # Updates the GtdInbox code repository by issuing a 'git pull' command
  #
  # Returns nothing.
  #

  def self.git_pull
    repo_dir = Rails.configuration.gtdinbox_repo_dir
    `cd #{repo_dir} && git pull origin master`
  end

  #
  # Syncronises a message record to a provided value.
  #
  # name  - The message name.
  # value - The message value.
  #
  # Returns a label representing the db operation performed
  #         on the record (valid values are :created, :updated, :identical)
  #


  def self.sync_record(name, value)
    message = Message.find_by_name(name)

    unless message
      Message.create :name => name, :value => value
      return :created
    end

    if message.value == value.to_s
      return :identical

    else
      message.value = value
      message.save
      return :updated
    end
  end
end
