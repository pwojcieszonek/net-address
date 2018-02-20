#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 02.01.2018 by Piotr Wojcieszonek

module Net
  module Address
    class MAC

      include Comparable

      def initialize(mac_address)
        case mac_address
          when self.class
            @mac_address = mac_address.to_i
          when Integer
            @mac_address = mac_address.to_i
          when String
            @mac_address = clear(mac_address).hex
          when Array
            @mac_address = mac_address.join.hex
          else
            raise ArgumentError, "No implicit conversion of #{mac_address.class.name} into #{self.class.name}"
        end
        raise ArgumentError, "MAC Address out of range #{mac_address}" if @mac_address.to_i < 0 or @mac_address.to_i > 0xffffffffffff
      end

      def to_s(separator='.', step = 4)
        step = step.to_i
        mac = '%012X' % @mac_address.to_i
        return mac if separator.nil? or step == 0
        raise ArgumentError, "Wrong step value #{step}" unless [0,2,4].include? step.to_i
        (0..(mac.length-1)/step).map{|i|mac[i*step,step]}.join(separator.to_s)
      end

      def to_i
        @mac_address.to_i
      end

      def to_a
        mac = '%012X' % @mac_address.to_i
        (0..5).map{|i| mac[i*2,2]}
      end

      alias_method :octets, :to_a

      def <=>(other)
        begin
        other = self.class.new(other) unless other.is_a? self.class
        rescue ArgumentError => e
          raise ArgumentError, "No implicit conversion of #{other.class.name} into #{self.name}"
        end
        self.to_i <=> other.to_i
      end

      private

      def clear(mac_address)
        mac_address.to_s.gsub(/(:|-|\.|,|"|)/,'').gsub(/\s+/, '')
      end

    end
  end
end