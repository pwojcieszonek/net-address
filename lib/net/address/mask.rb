#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 02.01.2018 by Piotr Wojcieszonek

module Net
  module Address
    class Mask

      include Comparable

      def initialize(mask)
        mask = mask.nil? ? 0 : mask
        @mask = parse_mask(mask)
        raise ArgumentError, "Not valid Net::Address::Mask #{mask}" unless 0 <= @mask.to_i and @mask.to_i <= 32
      end

      def to_s
        [self.to_i].pack('N').unpack('C*').join '.'
      end

      def to_i
        (0xFFFFFFFF << (32 - @mask.to_i)) & 0xFFFFFFFF
      end

      def to_cidr
        @mask.to_i
      end

      def <=>(other)
        begin
          other = self.class.new(other) unless other.is_a? self.class
        rescue
          nil
        end
        self.to_i <=> other.to_i
      end

      private

      def parse_mask(mask)
        case mask
          when self.class
            mask.to_cidr
          when Integer
            parse_integer(mask)
          when String
            parse_string(mask)
          else
            raise ArgumentError, "Not valid Net::Address::Mask #{mask}"
        end
      end

      def parse_string(mask)
        case mask
          when /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
            matching_bits = mask.split('.').map(&:to_i).pack('C*').unpack('B*').first.match(/^(1{0,32})(0{0,32})$/)
            raise ArgumentError, "Not valid Net::Address::Mask #{mask}" if matching_bits.nil?
            matching_bits[1].size
          when /^\/\d{1,2}$/
            mask.to_s.gsub(/\//, '').to_i
          when /^\d{1,2}$/
            mask
          else
            raise ArgumentError, "Not valid Net::Address::Mask #{mask}"
        end
      end

      def parse_integer(mask)
        raise ArgumentError, "Not valid Net::Address::Mask #{mask}" if mask < 0
        return mask if mask.to_i <= 32
        matching_bits = [mask].pack('N*').unpack('B*').first.match(/^(1{0,32})(0{0,32})$/)
        raise ArgumentError, "Not valid Net::Address::Mask #{mask}" if matching_bits.nil?
        matching_bits[1].size
      end

    end
  end
end