module App
  module_function

  def test?
    ENV['RACK_ENV'] == 'test'
  end

  def production?
    ENV['RACK_ENV'] == 'production'
  end

  def root
    @root ||= File.dirname(__FILE__)
  end

  def logger
    return @logger if @logger

    logger = production? ? Syslogger.new('bandejao') : Logger.new(STDOUT)
    @logger = ActiveSupport::TaggedLogging.new(logger)
  end

  def save_file(university, content)
    # In the real world, we would send this to S3
    dir_files = "#{root}/log/parsers/#{university.name}-files"
    FileUtils.mkdir_p(dir_files) unless File.directory? dir_files
    date_format = DateTime.now.strftime('%Y-%m-%d_%H:%M:%S')
    File.write "#{dir_files}/#{date_format}", content.to_s
  end
end

Dotenv.load

locales = Dir[File.join(App.root, 'config', 'locales', '*.yml')]
I18n.backend.load_translations(locales)
