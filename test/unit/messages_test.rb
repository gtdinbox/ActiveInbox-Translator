require 'test_helper'
require 'ruby-debug'


# mock time-consuming git pull method
class GtdInboxRepo
  def self.pull;end
end

class FakeMessageOne
  include GtdInboxSyncable
  sync_values_of(:name, :value) do
   {'a' => 'a-value',
    'b' => 'b-value',
    'c' => 'c-value',
    'd' => 'd-value',
    'e' => 'e-value',
   }
  end
end

class MessagesTest < ActiveSupport::TestCase

  test "should parse and import the records in messages.json'" do
    stub(FakeMessageOne).create {}
    stub(FakeMessageOne).where {[]}
    stub(FakeMessageOne).update_all {0}
    stats = FakeMessageOne.sync!
    assert_equal(stats[:created], 5)
    assert_equal(stats[:deleted], 0)
    assert_equal(stats[:identical], 0)
    assert_equal(stats[:updated], 0)
  end

  test "Should only update records if message values have changed" do
    FakeMessageOne.define_singleton_method(:update_all) {|values, conditions| 1}
    FakeMessageOne.define_singleton_method(:where) do |conditions|
      record, lambda_value = Object.new, nil

      ['value=', 'deleted', 'deleted=', 'save'].each do |attr|
        l = attr =~ /=$/ ? lambda {|val|} : lambda {}
        record.define_singleton_method(attr, l)
      end

      lambda_value = conditions[:name] === 'b' ?
        lambda {'changed-value'} :
        lambda {"#{conditions[:name]}-value"}

      record.define_singleton_method(:value, &lambda_value)
      [record]
    end

    stats = FakeMessageOne.sync!
    assert_equal(stats[:identical], 4)
    assert_equal(stats[:updated], 1)
    assert_equal(1, stats[:deleted])
  end


end
