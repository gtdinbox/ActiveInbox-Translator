require 'test_helper'
require 'ruby-debug'

class SyncObserverTest < ActiveSupport::TestCase
  @@it_locale = Locale.find_by_lang_code('it')
  @@master_locale = Locale.where(:is_master => true).first



  test "Should flag translations as not in sync when a page master record is updated" do
    Page.destroy_all
    master, translation = create_records(Page, :content)
    master.content = "updated..."
    master.save
    assert_equal(false, Page.all[1].in_sync)
  end

  test "Should flag translations as not in sync when a message master record is updated" do
    Message.destroy_all
    master, translation = create_records(Message)
    master.value = "updated..."
    master.save
    assert_equal(false, Message.all[1].in_sync)
  end

  def create_records(model, value_attr=:value)
    records = []
    2.times do |index|
      locale_id = index === 0 ? @@master_locale.id : @@it_locale.id

      records.push(model.create(
        :name => 'dummy',
        value_attr => 'bzz',
        :locale_id => locale_id
      ))
    end
    records
  end
end
