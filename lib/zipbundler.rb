class ZipBundler

  # Public:
  #
  # Initializes the zip bundler object.
  #
  # dir_files - An array of two elements' arrays containing a directory name (index 0)
  #             and a file handle (index 1).
  #
  #             (e.g [['en_US', <file-object>], ['en_UK', <file-object> ], ...])
  #
  # Returns nothing
  #

  def initialize(dir_files, bundle_id)
    # the top level directory in the archive is represented as an empty string.
    @dir_names = dir_files.map{|dir_file|dir_file[0]}.uniq
    @files = dir_files.map{|dir_file|dir_file[1]}
    @dir_files = dir_files
    @bundle_id=bundle_id
    @bundle_filename = nil
  end

  # Public:
  #
  # bundles the file list into a zipped directory structure
  #
  # export_dir - The directory where the zip bundle will be placed (Optional, defaults to '/public/exports').
  #
  # Returns The Zip bundle path.
  #
  def bundle!(export_dir= Rails.configuration.gtdinbox_export_dir)
    @bundle_filename = "#{export_dir}/#{@bundle_id}-translation-export.zip"


    Zip::ZipFile.open(@bundle_filename, Zip::ZipFile::CREATE) do  |zipfile|
      pp @dir_names
      @dir_names.each {|dirname|zipfile.mkdir(dirname)}
      @dir_files.each do |dir_file|
        dirname, file = dir_file
        zip_filepath = File.basename(file.path).gsub("#{dirname}-#{@bundle_id}-",'')
        zipfile.add([dirname, zip_filepath].join('/'), file.path)
      end
    end

    File.chmod(0644, @bundle_filename)
    clean_up

    @bundle_filename
  end


  #
  # Gets the zip bundle path
  #
  # Returns the zip path.
  #

  def path
    @bundle_filename
  end

  private

  #
  # Removes all the files provided on initialisation.
  #
  # Returns nothing
  #
  def clean_up
    @files.each {|file| FileUtils.remove(file.path)}
  end
end
