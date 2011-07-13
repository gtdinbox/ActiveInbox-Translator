class Page < ActiveRecord::Base
  include GtdInboxSyncable

  belongs_to :locale


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
