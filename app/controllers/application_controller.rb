class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :redirect_if_anoymous


  #
  # Redirects anonymous users to the loggin form.
  #

  def redirect_if_anoymous
    unless session.has_key?(:user_id)
      redirect_to login_url, :notice => "Please log in first"
    end
  end



  #
  # Generate a zip bundle for exporting translated locales
  #
  def export_bundle
    export_id=Time.now.to_i
    export_data = Message.export(export_id).concat(Page.export(export_id))
    bundler = ZipBundler.new(export_data, export_id)
    bundle_path = bundler.bundle!
    file = File.open(bundle_path, 'r')
    file_content = file.read
    file.close()

    send_data file_content,
      :type => 'application/zip',
      :filename => File.basename(bundle_path),
      :disposition => 'attachment'
  end



end
