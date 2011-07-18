class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :redirect_if_anoymous

  # Redirects anonymous users to the loggin form.

  def redirect_if_anoymous
    unless session.has_key?(:user_id)
      redirect_to login_url, :notice => "Please log in first"
    end
  end

  def redirect_unless_admin
    unless session.has_key?(:user_id) and session[:is_admin]
      redirect_to root_url, :notice => "You do not have access to this page"
    end
  end

  #
  # Rises an exception unless the user is admin or is editing/updating its own account
  #
  def error_unless_authorized
    raise "AdminOnly" unless session[:user_id] == params[:id].to_i or session[:is_admin]
  end


  #
  # Returns the user selected locale or falls back on the default one
  #

  def get_locale
    default_locale = Rails.configuration.gtdinbox_master_locale

    locale = if params.has_key?(:lang) and params[:lang]
      Locale.find_by_lang_code(params[:lang])
    else
      default_locale
    end

    @is_default_locale = default_locale.id === locale.id
    locale
  end

  #
  # Exports all localised messages and pages, and bundle them into a downloadable zip archive.
  #
  def export_bundle
    export_id=Time.now.to_i
    export_data = []

    Locale.all.each do |locale|
       locale_data = Message.export(export_id, locale).
                             concat(Page.export(export_id, locale))

       export_data.concat(locale_data) unless locale_data.empty?
    end

    bundler = ZipBundler.new(export_data, export_id)
    bundle_path = bundler.bundle!
    file = File.open(bundle_path, 'r')
    file_content = file.read
    file.close()

    send_data file_content, :type => 'application/zip',
      :filename => File.basename(bundle_path),
      :disposition => 'attachment'
  end
end
