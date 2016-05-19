class ParserLogger
  DIR_LOG = "#{Sinatra::Application.root}/log/parsers"
  DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

  def initialize(university)
    @university = university
    FileUtils.mkdir_p(DIR_LOG) unless File.directory?(DIR_LOG)
    @logger = Logger.new("#{DIR_LOG}/#{university.name}.log")
    @logger.level = Logger::INFO
    @logger.formatter = proc do |severity, datetime, _, msg|
      date_format = datetime.strftime DATE_FORMAT
      "[#{date_format}] #{severity}: #{msg}\n"
    end
  end

  def method_missing(m, *args, &_)
    @logger.send(m, args[0])
  end

  def save_file(content)
    dir_files = "#{DIR_LOG}/#{@university.name}-files"
    FileUtils.mkdir_p(dir_files) unless File.directory? dir_files
    date_format = DateTime.now.strftime(DATE_FORMAT)
    File.write "#{dir_files}/#{date_format}", content.to_s
  end
end
