module TechnicalAnalysis
  class Kc

    # Calculates the keltner channel (KC) for the data over the given period
    # https://en.wikipedia.org/wiki/Keltner_channel
    # 
    # @param data [Array] Array of hashes with keys (:date, :high, :low, :close)
    # @param period [Integer] The given period to calculate the KC
    # @return [Hash] A hash of the results with keys (:date, :value)
    def self.calculate(data, period: 10)
      Validation.validate_numeric_data(data, :high, :low, :close)
      Validation.validate_length(data, period)

      data = data.sort_by_hash_date_asc # Sort data by descending dates

      output = []
      period_values = []

      data.each do |v|
        tp = StockCalculation.typical_price(v)
        tr = v[:high] - v[:low]
        period_values << { typical_price: tp, trading_range: tr }

        if period_values.size == period
          mb = period_values.map { |pv| pv[:typical_price] }.average

          trading_range_average = period_values.map { |pv| pv[:trading_range] }.average
          ub = mb + trading_range_average
          lb = mb - trading_range_average

          output << {
            date: v[:date],
            value: {
              middle_band: mb,
              upper_band: ub,
              lower_band: lb
            }
          }

          period_values.shift
        end
      end

      output
    end

  end
end
