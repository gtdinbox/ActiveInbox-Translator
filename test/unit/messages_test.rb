require 'test_helper'


# mock time-consuming git pull method

class Message
  def self.git_pull
  end
end


class MessagesTest < ActiveSupport::TestCase

  def setup
    Message.destroy_all
    setMessages('messages.json')
  end

  test "should parse and import the records in'content/locales/en_US/messages.json'" do
    stats = Message.sync
    assert_equal(@messages.keys.size, Message.count)
    assert_equal(@messages.keys.size, stats[:created])
  end

  test "Should not update records if message values have not changed" do
    Message.sync
    stats = Message.sync
    assert_equal(stats[:identical], @messages.size)
  end

  test "Should flag messages as deleted if these do not exist in the message.json file " do
    Message.sync
    setMessages('messages-changed.json')
    stats = Message.sync
    assert_equal(stats[:updated], 1)
    assert_equal(stats[:created], 1)
    assert_equal(stats[:deleted], 1)
    assert Message.find_by_name("Box.expander.boxabout").deleted
    assert_not_nil Message.find_by_name("Box.expander.boxaboutz")
    assert_equal(Message.count, @messages.size + 1)
  end

  private

  def setMessages(filename)
    Rails.configuration.gtdinbox_message_file = Rails.root.to_s + 
      "/test/fixtures/#{filename}"
    @messages = JSON.parse(File.open(
      Rails.configuration.gtdinbox_message_file,
    'r').read)
  end
end
