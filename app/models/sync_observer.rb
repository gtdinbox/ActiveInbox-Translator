class SyncObserver < ActiveRecord::Observer
  observe :message, :page

  #
  # When a master message or a page record gets updated, label
  # all its translation as not in sync
  #
  def after_save(record)
    master_locale = Rails.configuration.gtdinbox_master_locale

    if (record.locale.is_master)
      record.class.update_all ["in_sync = ?", false],
        ["deleted = ? AND name = ? AND locale_id NOT IN (?)",
          false, record.name, master_locale.id]
    end
  end
end
