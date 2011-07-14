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

    if message[:locale_value] and message[:in_sync]
      state = 'ok'
    end
    if message[:locale_value] and not message[:in_sync]
      state = 'needs_sync'
    end
    if not message[:locale_value]
      state = 'missing'
    end

    state
  end
end
