require 'test_helper'
require 'pp'

class PageTest < ActiveSupport::TestCase
  def setup
    page_dir = File.dirname(Rails.configuration.gtdinbox_message_file)
    @pages = Dir["#{page_dir}/*{html,htm}"]
    Page.destroy_all
  end

  test "Should create a record for each .html and .html files in the repository filder locales/en_US" do
    stats = Page.sync!
    assert_equal(@pages.size, stats[:created])
    assert_equal(0, stats[:updated])
    assert_equal(0, stats[:identical])
    assert_equal(0, stats[:deleted])
  end

  test "Should mark obsolete pages as deleted" do
    stats = Page.sync!
    path = @pages.first
    file = File.open(path, 'w')
    file.write('bla bla bla here')
    file.close
    stats = Page.sync!
    `cd #{File.dirname(path)} && git checkout #{path}`

    assert_equal(0, stats[:created])
    assert_equal(1, stats[:updated])
    assert_equal(0, stats[:deleted])
    assert_equal(@pages.size - 1, stats[:identical])

  end
end
