class OCR
  attr_accessor :groups

  def initialize(groups)
    @groups = groups.split(/\n\n/).map { |group| OCRNumbers.new(group) }
  end

  def convert
    groups.map { |numbers| numbers.values }.join(',')
  end
end

class OCRNumbers
  CONVERTER = {
    ' _ | ||_|' => '0',
    '     |  |' => '1',
    ' _  _||_ ' => '2',
    ' _  _| _|' => '3',
    '   |_|  |' => '4',
    ' _ |_  _|' => '5',
    ' _ |_ |_|' => '6',
    ' _   |  |' => '7',
    ' _ |_||_|' => '8',
    ' _ |_| _|' => '9'
  }

  attr_accessor :rows_and_columns

  def initialize(rows_and_columns)
    @rows_and_columns = rows_and_columns
    split_into_rows
    split_into_columns
    sort_pieces
  end

  def split_into_rows
    self.rows_and_columns = rows_and_columns.split(/\n/)
  end

  def split_into_columns
    self.rows_and_columns = rows_and_columns.map {|row| row.scan(/.{1,3}/) }
  end

  def sort_pieces
    unsorted = self.rows_and_columns.map! do |row|
      row << '   ' if row.empty?
      row.map! { |string| add_spaces(string) }
    end

    sorted = unsorted[0].zip unsorted[1], unsorted[2]

    self.rows_and_columns = sorted.map { |number| number.join }
  end

  def values
    self.rows_and_columns.map! { |number| CONVERTER.fetch(number, '?') }.join
  end

  def add_spaces(string)
    if string.size < 3
      string += ' ' until string.size % 3 == 0
    end
    string
  end
end
