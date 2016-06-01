class CSVProcesser
  require 'csv'
  CSV::Row.include CoreExtensions::CSV::Row

  attr_reader :csv, :invalid_rows, :valid_rows, :output

  SKIP_LINES_REGEX = /(Opening|Closing) Balance/i
  HEADERS = [:date, :category, :subcategory, :amount, :balance, :notes]

  class CSVPathError < StandardError; end
  class CSVStructureError < StandardError; end
  class InvalidCSVError < StandardError; end

  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end

  def initialize(path)
    raise CSVPathError.new("Not valid path to process CSV") unless path =~ /.csv$/
    @path = path
    @invalid_rows, @valid_rows = Array.new(2){[]}
  end

  def process
    read_csv
    validate_headers
    validate_rows
    @csv = to_xml
  end

  def valid?
    @invalid_rows.empty? && !@valid_rows.empty?
  end

  def to_xml
    raise InvalidCSVError.new(@invalid_rows) unless valid?

    builder = Nokogiri::XML::Builder.new(:encoding => 'ISO-8859-1') do |xml|
      xml.Movimientos {
        @valid_rows.each do |row|
          xml.Movimiento {
            xml.FECHA row[:date]
            xml.CATEGORIA row[:category]
            xml.SUB_CATEGORIA row[:subcategory]
            xml.DESCRIPCIÓN row[:notes]
            xml.VALOR row[:amount]
          }
        end
      }
    end
    builder.to_xml
  end

  def write_file
    path = File.join(generate_directory, generate_filename)
    raise InvalidCSVError.new("There is no valid CSV content to generate file") unless valid?

    File.open(path, 'w') do |file|
      file.write @csv
    end
  end

  private
  def process_options
    {headers: true,
      header_converters: :symbol,
      skip_lines: SKIP_LINES_REGEX,
      skip_blanks: true,
      converters: [:numeric, :date, :blank_to_nil]}
  end

  def read_csv
    @csv = CSV.read(@path, process_options)
  end

  def validate_headers
    raise CSVStructureError unless HEADERS == @csv.headers
  end

  def validate_rows
    @csv.each do |row|
      row.sanitize_fields(:category, :subcategory)
      row.validate_row
      row.valid? ? @valid_rows << row : @invalid_rows << row
    end
  end

  def generate_filename
    now = Time.now
    begin_month = now.beginning_of_month.strftime("%d%Y%m")
    end_month = now.end_of_month.strftime("%d%Y%m")
    output || "cash#{begin_month}_#{end_month}.xml"
  end

  def generate_directory
    directory_name = "#{Time.now.strftime("%Y%m")}"
    directory = File.join("public/reconciled/", directory_name)
    Dir.mkdir(directory) unless File.exists?(directory)
    directory
  end
end