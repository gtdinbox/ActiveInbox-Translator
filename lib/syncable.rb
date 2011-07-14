require 'ruby-debug'
#
# Mixin providing one way synchronisation capabilities 
# to ActiveRecord models.
#
module GtdInboxSyncable

  def self.included(base)
    base.extend(ClassMethods)
  end


  module ClassMethods
    def sync_values_of(name_attribute = :name, value_attribute = :value, &block)
      @sync_name_attribute = name_attribute
      @sync_value_attribute = value_attribute
      @sync_block = block
    end


    def sync!
      @master_locale = Rails.configuration.gtdinbox_master_locale

      reset_stats
      name_values = @sync_block.call
      name_values.each do |name, value|
        sync_record(name, value)
      end

      delete_condition = [
        "locale_id = ? AND #{@sync_name_attribute} NOT IN (?) AND deleted = ?",
         @master_locale.id, name_values.keys, false
      ]

      @sync_stats[:deleted] = self.update_all(["deleted = ?", true], delete_condition)
      @sync_stats
    end

    private
    def reset_stats
      @sync_stats = {
         :created => 0,
         :updated => 0,
         :identical => 0,
         :deleted => 0
      }
    end

    def sync_record(name, value)
      record = self.where(
        @sync_name_attribute  => name,
        :locale_id => @master_locale.id
      ).first

      unless record
        self.create @sync_name_attribute => name,
                    @sync_value_attribute => value,
                    :locale_id => @master_locale.id

        @sync_stats[:created] += 1
      else
        if record.send(@sync_value_attribute) === value and not record.deleted
          @sync_stats[:identical] += 1
        else
          puts 'Updating value for '+name
          record.send("#{@sync_value_attribute}=", value)
          record.deleted = false
          record.save
          @sync_stats[:updated] += 1
        end
      end

    end
  end
end
