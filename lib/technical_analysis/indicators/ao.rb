module TechnicalAnalysis
  class Ao

    # Calculates the Awesome Oscillator for the data over the given period
    # https://www.tradingview.com/wiki/Awesome_Oscillator_(AO)
    # 
    # @param data [Array] Array of hashes with keys (:date, :high, :low)
    # @param short_period [Integer] The given period to calculate the short period SMA
    # @param long_period [Integer] The given period to calculate the long period SMA
    # @return [Hash] A hash of the results with keys (:date, :value)
    def self.calculate(data, short_period: 5, long_period: 34)
      Validation.validate_numeric_data(data, :high, :low)
      Validation.validate_length(data, long_period)

      data = data.sort_by_hash_date_asc # Sort data by descending dates

      midpoint_data = []

      # Build new Array of hashes with keys :date, :value where value is the midpoint
      data.each do |v|
        midpoint = (v[:high] + v[:low]) / 2
        midpoint_data << { date: v[:date], value: midpoint }
      end

      output = []
      midpoint_values = []

      midpoint_data.each do |v|
        midpoint_values << v[:value]
        
        if midpoint_values.size == long_period
          short_period_sma = midpoint_values.last(short_period).sum / short_period.to_f
          long_period_sma = midpoint_values.sum / long_period.to_f
          value = short_period_sma - long_period_sma

          output << { date: v[:date], value: value }

          midpoint_values.shift
        end
      end

      output
    end

  end
end
