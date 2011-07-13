require 'test_helper'
require 'ruby-debug'


# mock time-consuming git pull method
class GtdInboxRepo
  def self.pull
  end
end

class Message
  sync_values_of :name, :value do

      filepath = Rails.root.to_s + "/test/fixtures/messages.json"
      @messages = JSON.parse(File.open(
        Rails.configuration.gtdinbox_message_file,
      'r').read)

      @messages.each{|key, record| @messages[key] = record['message'] }
      @messages
  end
end


class MessagesTest < ActiveSupport::TestCase

  #def setup
  #  Message.destroy_all
  #  set_sync_input('messages.json')
  #end

  #test "should parse and import the records in'content/locales/en_US/messages.json'" do
  #  stats = Message.sync!
  #  assert_equal(@messages.keys.size, Message.count)
  #  assert_equal(@messages.keys.size, stats[:created])
  #end

  #test "Should not update records if message values have not changed" do
  #  Message.sync!
  #  stats = Message.sync!
  #  assert_equal(stats[:identical], @messages.size)
  #end

  test "Should flag messages as deleted if these do not exist in the message.json file " do
    stats = Message.sync!
    pp stats
    set_sync_input('messages-changed.json')
    stats = Message.sync!
    pp stats

    #assert_equal(stats[:updated], 1, "One element should have been updated")
    #assert_equal(stats[:created], 1, "One element should have been created")
    #assert_equal(stats[:deleted], 1, "One element should have been deleted")
    #assert Message.find_by_name("Box.expander.boxabout").deleted
    #assert_not_nil Message.find_by_name("Box.expander.boxaboutz")
    #assert_equal(Message.count, @messages.size + 1)
  end

  private
  def set_sync_input(filename)
    Message.sync_values_of :name, :value do

      filepath = Rails.root.to_s + "/test/fixtures/#{filename}"
      @messages = JSON.parse(File.open(
        Rails.configuration.gtdinbox_message_file,
      'r').read)

      @messages.each{|key, record| @messages[key] = record['message'] }
      @messages
    end
  end
end
