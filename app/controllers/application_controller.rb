class ApplicationController < ActionController::Base
  protect_from_forgery

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
