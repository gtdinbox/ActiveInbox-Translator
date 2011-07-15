module ApplicationHelper

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end


  #
  # Public:
  # Generates a navigation menu for the different locales.
  #
  #
  # Returns an HTML string representing the unordered list of menu items.
  #
  #

  def locale_menu ()
    default_locale = Rails.configuration.gtdinbox_master_locale
    lang_code = params.has_key?(:lang) ? params[:lang] : default_locale.lang_code
    locales = Locale.where("lang_code IS NOT ?", default_locale.lang_code)
    list_items = []

    locales.unshift(default_locale)
  end
end
