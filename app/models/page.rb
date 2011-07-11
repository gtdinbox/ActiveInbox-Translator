class Page < ActiveRecord::Base

  #
  # Public:
  #
  # Synchronise the pages table with
  # the content of the HTML files in the repository
  # directory 'content/locals/en_US'
  #
  # Returns a hash containing the counts of the updated, created, and deleted pages.
  #

  def self.sync
    page_dir = File.dirname(Rails.configuration.gtdinbox_message_file)
    stats = {}
    statuses = []
    pagenames = []

    Dir["#{page_dir}/*.{html,htm}"].each do |filepath|
      statuses.push(self.sync_page(filepath))
      filenames.push(File.basename(filepath))
    end

    stats[:deleted] =
      Page.update_all ["deleted = ?", true], ["name NOT IN (?)", pagenames]

    statuses.uniq.each do |status|
      stats[status] = statuses.grep(status).size
    end

    stats
  end


  def self.sync_page(filepath)
    file = File.open(filepath, 'r')
    basename = File.basename(filepath)
    file_content = file.read
    page = Page.find_by_name(basename)

    unless page
      Page.create :name => basename, :content => file_content
      return :created
    end

    if page.content === file.content
      return :identical
    else
      return :updated
    end
    file.close
  end
end
