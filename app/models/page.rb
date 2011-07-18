class Page < ActiveRecord::Base
  include GtdInboxSyncable

  belongs_to :locale

  #
  # Synchronizes the page records with the htm* files in the content/locale/en_US/
  # folder of the Active inbox plugin code.
  #

  sync_values_of(:name, :content) do
    #GtdInboxRepo.pull

    page_dir = File.dirname(Rails.configuration.gtdinbox_message_file)
    file_paths = Dir["#{page_dir}/*.{html,htm}"]
    file_contents = {}

    file_paths.each do |filepath|
      file_contents[File.basename(filepath)] =  File.open(filepath, "r").read
    end

    file_contents
  end

  def self.locale_or_masterlist(lang_code=0)
    master_locale = Rails.configuration.gtdinbox_master_locale
    locale = Locale.find_by_lang_code(lang_code)

    output = {}

    #todo: refactor into sql
    pages_master = Page.where(:locale_id => master_locale.id)
    pages_locale = locale ? Page.where(:locale_id => locale.id) : []


    [pages_master, pages_locale].each do |collection|
      collection.each{|page|output[page.name] = page}
    end

    output
  end


  def update_or_translate(lang_code, attributes)

    if lang_code === self.locale.lang_code
      self.update_attributes(attributes)
      self.save
    else
      locale = Locale.find_by_lang_code(lang_code)

      Page.create(
        :name => attributes[:name],
        :content => attributes[:content],
        :locale_id => locale.id
      )
    end
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

  def self.export(export_id=Time.now.to_i, locale=Rails.configuration.gtdinbox_master_locale)
    export_data = []

    Page.where(:deleted => false, :locale_id => locale.id).each do |page|
      page_filepath = "#{Rails.configuration.gtdinbox_export_tmpdir}/#{locale.lang_code}-#{export_id}-#{page.name}"

      file = File.open(page_filepath, 'w')
      file.write(page.content)
      file.close

      export_data.push([locale.lang_code, file])
    end

    export_data
  end


end
