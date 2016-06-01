module CoreExtensions
  module CSV
    module Row
      include Categories
      attr_accessor :valid

      def valid?
        @valid.nil? ? true : @valid
      end

      def sanitize_fields(*fields)
        fields.each {|f| self[f] = convert_string(self[f]) if self[f] }
      end

      def validate_row
        @valid = false if nil_fields?(self.headers - [:notes]) ||
                            invalid_types?(Date, :date) ||
                            invalid_types?(Float, :amount)
        validate_categories
      end

      private
      def validate_categories
        @valid = false unless valid_category?(self[:category]) ||
                                valid_subcategory?(self[:category], self[:subcategory])
      end

      def convert_string(string)
        string.downcase.strip.gsub(/\s+/, "_").gsub(/\W+/, "")
      end

      def nil_fields?(fields = headers)
        fields.each do |f|
          return true if self[f].nil?
        end
        false
      end

      def invalid_types?(type, *fields)
        fields.each do |f|
          return true unless self[f].is_a? type
        end
        false
      end
    end
  end
end