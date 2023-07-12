require 'csv'

class TransactionDataLoader
  COLUMN_MAPPINGS = {
    'time' => :time,
    'status' => :status,
    'f0_' => :count
  }.freeze

  def self.load_transactions(file_path, column_mappings)
    headers = []
    total_records = 0
    saved_records = 0
    errors = []

    CSV.foreach(file_path, headers: true) do |row|
      if headers.empty?
        headers = row.headers.map(&:downcase)
        next
      end

      transaction_data = headers.each_with_object({}) do |header, data|
        column = column_mappings[header] || header
        data[column.to_sym] = normalize_value(column, row[header])
      end

      transaction = Transaction.new(transaction_data)
      total_records += 1

      if transaction.save
        saved_records += 1
      else
        errors << "Failed to save transaction: #{transaction.errors.full_messages.join(', ')}"
      end
    end

    log_summary(file_path, total_records, saved_records, errors)
  end

  def self.normalize_value(column, value)
    return value unless column == :time

    value.gsub!(' ', '')
  end

  def self.log_summary(file_path, total_records, saved_records, errors)
    puts "Data loading summary for file: #{file_path}"
    puts "Total records: #{total_records}"
    puts "Saved records: #{saved_records}"
    puts "Failed records: #{total_records - saved_records}"
    puts "Errors: #{errors.join(', ')}" if errors.any?
  end
end
