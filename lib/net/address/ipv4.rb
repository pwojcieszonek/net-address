#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 03.01.2018 by Piotr Wojcieszonek

require 'net/address/mask'
require 'ipaddr'
require 'json'

module Net
  module Address
    class IPv4

      include Comparable

      attr_reader :mask

      def initialize(address, mask=nil)
        if address.is_a?(String)
          address = begin
                      JSON.parse address
                    rescue JSON::ParserError
                      address
                    end
        end
        parse_address(address)
        if @mask.nil?
          @mask = Net::Address::Mask.new(mask.nil? ? 32 : mask)
        else
          raise ArgumentError, 'To many parameters' unless mask.nil?
        end
      end

      def to_s
        [@address].pack('N*').unpack('C*').join('.')
      end

      def to_str
        "#{to_s}/#{mask.to_cidr}"
      end

      alias to_cidr to_str

      def to_i
        @address
      end

      def to_h
        {
          address: self.to_s,
          mask: self.mask.to_s,
          net: self.net.to_s,
          broadcast: self.broadcast.to_s,
          cidr: self.to_cidr
        }
      end

      def to_json(*params)
        to_h.to_json
      end

      def <=>(other)
        self.to_i <=> (other.is_a?(self.class) ? other.to_i : self.class.new(other).to_i)
      end

      def include?(address)
        address = address.is_a?(self.class) ? address : self.class.new(address)
        address.to_i >= net.to_i and address <= broadcast.to_i
      end

      def net
        self.class.new(range.first, mask)
      end

      def broadcast
        self.class.new(range.last, mask)
      end

      def previous
        previous = to_i - 1
        net <= previous ? self.class.new(previous) : nil
      end

      def next
        next_address = to_i + 1
        broadcast >= next_address ? self.class.new(next_address) : nil
      end

      def each
        (net.to_i..broadcast.to_i).each do |address|
          yield self.class.new(address, mask)
        end
      end


      private

      def parse_address(address)
        if address.kind_of?(Hash)
          parse_string(address['address'])
          @mask = Net::Address::Mask.new address['mask']
        elsif address.kind_of?(Net::Address::IPv4)
          @address = address.to_i
          @mask = address.mask
        elsif address.kind_of?(IPAddr)
          @address = address.to_i
        elsif address.kind_of?(Integer)
          parse_integer(address)
        elsif address.kind_of?(String)
          parse_string(address)
        else
          raise ArgumentError, "No implicit conversion of #{address.class.name} to #{self.class.name}"
        end
      end

      def parse_string(address)
        address = address.strip
        match_data = address.match(/^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/?(\d{1,2})*$/)
        raise ArgumentError,"No valid IPv4 address #{address}" if match_data.nil?
        @address = match_data[1].split(/\./).map{|c| c.to_i}.pack('C*').unpack('N').first
        @mask = Net::Address::Mask.new(match_data[2]) unless match_data[2].nil?
        raise ArgumentError, "No valid IPv4 address #{address}" unless self.to_s == match_data[1]
      end

      def parse_integer(address)
        @address = address
        if address.to_i < 0 or address.to_i > 0xffffffffffff
          raise ArgumentError, "No implicit conversion of #{address.class.name} : #{address} to #{self.class.name}"
        end
      end

      def range
        bits = mask.to_i & 0xFFFFFFFF
        min = bits & to_i
        max = min + (bits ^ 0xFFFFFFFF)
        [min, max]
      end

    end
  end
end
