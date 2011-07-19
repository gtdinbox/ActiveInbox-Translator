module MessageHelper
  #
  # Public:
  #
  # Assign a state for this message
  #
  # message - A hash containing the following attributes:
  #           ('id', 'name', 'master_value', 'local_value', 'in_sync', '' )
  #
  #
  # Returns three possible state names: (i.e. 'ok', 'needs_sync', 'missing')
  #
  #
  def state(message)
    state = nil
    default_lang_code = Rails.configuration.gtdinbox_master_locale.lang_code

    if (message[:locale_value] and message[:in_sync]) or params[:lang] == default_lang_code
      return 'ok'
    end
    if message[:locale_value] and not message[:in_sync]
      return 'needs_sync'
    end
    if not message[:locale_value]
      return 'missing'
    end
  end
end
