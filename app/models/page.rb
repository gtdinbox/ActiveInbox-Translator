class Page < ActiveRecord::Base
  include GtdInboxSyncable

  belongs_to :locale

  #
  # Synchronizes the page records with the htm* files in the content/locale/en_US/
  # folder of the Active inbox plugin code.
  #

  sync_values_of(:name, :content) do
    GtdInboxRepo.pull

    page_dir = File.dirname(Rails.configuration.gtdinbox_message_file)
    file_paths = Dir["#{page_dir}/*.{html,htm}"]
    file_contents = {}

    file_paths.each do |filepath|
      file_contents[File.basename(filepath)] =  File.open(filepath, "r").read
    end

    file_contents
  end

  private

  #
  # Prepares the data for exporting page files into a locale zip bundle.
  #
  # export_id - The unique export identifier.
  # locale - The language code of the exported locale.
  #
  # Returns:
  #  An array of two value arrays containing the exported local as the first item, and the page's file file handle as the second one.
  #

  def self.export(export_id=Time.now.to_i, locale='en_US')
    export_data = []

    Page.where("deleted = ?", false).each do |page|
      page_filepath = "#{Rails.configuration.gtdinbox_export_tmpdir}/#{locale}-#{export_id}-#{page.name}"

      file = File.open(page_filepath, 'w')
      file.write(page.content)
      file.close

      export_data.push([locale, file])
    end

    export_data
  end


end
