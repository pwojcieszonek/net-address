#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 02.01.2018 by Piotr Wojcieszonek

require_relative '../../spec_helper'

RSpec.describe Net::Address::Mask do

  context '#initialize' do
    it 'should create Net::Address::Mask when string representation of IPv4 network mask address given' do
      (0..32).each do |prefix|
        mask = [(0xFFFFFFFF << (32- prefix) ) & 0xFFFFFFFF].pack('N').unpack('C*').join '.'
        expect(Net::Address::Mask.new(mask)).to be_kind_of(Net::Address::Mask), "For addresses #{mask} expected that return Net::Address::Mask"
      end
    end
    it 'should create Net::Address::Mask when integer representation of IPv4 network mask address given' do
      (0..32).each do |prefix|
        mask = (0xFFFFFFFF << (32- prefix) ) & 0xFFFFFFFF
        expect(Net::Address::Mask.new(mask)).to be_kind_of(Net::Address::Mask), "For addresses #{mask} expected that return Net::Address::Mask"
      end
    end
    it 'should create Net::Address::Mask when cidr representation of IPv4 network mask address given' do
      (0..32).each do |prefix|
        expect(Net::Address::Mask.new(prefix)).to be_kind_of(Net::Address::Mask), "For prefix #{prefix} expected that return Net::Address::Mask"
      end
      (0..32).each do |prefix|
        expect(Net::Address::Mask.new(prefix.to_s)).to be_kind_of(Net::Address::Mask), "For prefix #{prefix} expected that return Net::Address::Mask"
      end
    end
    it 'should return Net::Address::Mask when Net::Address::Mask given' do
      (0..32).each do |prefix|
        prefix = Net::Address::Mask.new(prefix)
        expect(Net::Address::Mask.new(prefix)).to be_kind_of(Net::Address::Mask), "For prefix #{prefix} expected that return Net::Address::Mask"
      end
    end
    it 'should raise ArgumentError when wrong Netwok Mask given' do
      expect{Net::Address::Mask.new('10.0.0.1')}.to raise_exception(ArgumentError)
      expect{Net::Address::Mask.new(167772161)}.to raise_exception(ArgumentError)
      expect{Net::Address::Mask.new(33)}.to raise_exception(ArgumentError)
    end
  end

  context '.to_s' do
    it 'should return string representation of network mask' do
      expect(Net::Address::Mask.new(24).to_s).to eq('255.255.255.0')
      expect(Net::Address::Mask.new(4294967040).to_s).to eq('255.255.255.0')
      expect(Net::Address::Mask.new('255.255.255.0').to_s).to eq('255.255.255.0')
    end
  end

  context '.to_i' do
    it 'should return integer representation of network mask' do
      expect(Net::Address::Mask.new(24).to_i).to eq(4294967040)
      expect(Net::Address::Mask.new(4294967040).to_i).to eq(4294967040)
      expect(Net::Address::Mask.new('255.255.255.0').to_i).to eq(4294967040)
    end
  end

  context '.to_cidr' do
    it 'should return CIDR representation of network mask' do
      expect(Net::Address::Mask.new(24).to_cidr).to eq(24)
      expect(Net::Address::Mask.new(4294967040).to_cidr).to eq(24)
      expect(Net::Address::Mask.new('255.255.255.0').to_cidr).to eq(24)
    end
  end

  context '.==' do
    it 'should return true if mask equal' do
      expect(Net::Address::Mask.new(24)).to eq(24)
      expect(Net::Address::Mask.new(4294967040)).to eq(24)
      expect(Net::Address::Mask.new('255.255.255.0')).to eq(24)

      expect(Net::Address::Mask.new(24)).to eq(4294967040)
      expect(Net::Address::Mask.new(4294967040)).to eq(4294967040)
      expect(Net::Address::Mask.new('255.255.255.0')).to eq(4294967040)

      expect(Net::Address::Mask.new(24)).to eq('255.255.255.0')
      expect(Net::Address::Mask.new(4294967040)).to eq('255.255.255.0')
      expect(Net::Address::Mask.new('255.255.255.0')).to eq('255.255.255.0')

      expect(Net::Address::Mask.new(24)).to eq(Net::Address::Mask.new('255.255.255.0'))
    end
    it 'should return false if mask not equal' do
      expect(Net::Address::Mask.new(24)).not_to eq(25)
      expect(Net::Address::Mask.new(4294967040)).not_to eq(25)
      expect(Net::Address::Mask.new('255.255.255.0')).not_to eq(25)

      expect(Net::Address::Mask.new(24)).not_to eq(4294967168)
      expect(Net::Address::Mask.new(4294967040)).not_to eq(4294967168)
      expect(Net::Address::Mask.new('255.255.255.0')).not_to eq(4294967168)

      expect(Net::Address::Mask.new(24)).not_to eq('255.255.255.128')
      expect(Net::Address::Mask.new(4294967040)).not_to eq('255.255.255.128')
      expect(Net::Address::Mask.new('255.255.255.0')).not_to eq('255.255.255.128')

      expect(Net::Address::Mask.new(24)).not_to eq(Net::Address::Mask.new('255.255.255.128'))
    end
  end

  context '.<' do
    it 'should return true if mask is lower' do
      expect(Net::Address::Mask.new(24)).to be < 25
      expect(Net::Address::Mask.new(4294967040)).to be < 25
      expect(Net::Address::Mask.new('255.255.255.0')).to be < 25

      expect(Net::Address::Mask.new(24)).to be < 4294967168
      expect(Net::Address::Mask.new(4294967040)).to  be < 4294967168
      expect(Net::Address::Mask.new('255.255.255.0')).to be < 4294967168

      expect(Net::Address::Mask.new(24)).to be <'255.255.255.128'
      expect(Net::Address::Mask.new(4294967040)).to be <'255.255.255.128'
      expect(Net::Address::Mask.new('255.255.255.0')).to be < '255.255.255.128'

      expect(Net::Address::Mask.new(24)).to be  < Net::Address::Mask.new('255.255.255.128')
    end
    it 'should return false if mask is not lower' do
      expect(Net::Address::Mask.new(24)).not_to be < 23
      expect(Net::Address::Mask.new(4294967040)).not_to be < 23
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be < 23

      expect(Net::Address::Mask.new(24)).not_to be < 4294966784
      expect(Net::Address::Mask.new(4294967040)).not_to  be < 4294966784
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be < 4294966784

      expect(Net::Address::Mask.new(24)).not_to be <'255.255.254.0'
      expect(Net::Address::Mask.new(4294967040)).not_to be <'255.255.254.0'
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be < '255.255.254.0'

      expect(Net::Address::Mask.new(24)).not_to be  < Net::Address::Mask.new('255.255.254.0')
    end
  end

  context '.>' do
    it 'should return true if mask is greater' do
      expect(Net::Address::Mask.new(24)).to be > 23
      expect(Net::Address::Mask.new(4294967040)).to be > 23
      expect(Net::Address::Mask.new('255.255.255.0')).to be > 23

      expect(Net::Address::Mask.new(24)).to be > 4294966784
      expect(Net::Address::Mask.new(4294967040)).to  be > 4294966784
      expect(Net::Address::Mask.new('255.255.255.0')).to be > 4294966784

      expect(Net::Address::Mask.new(24)).to be > '255.255.254.0'
      expect(Net::Address::Mask.new(4294967040)).to be > '255.255.254.0'
      expect(Net::Address::Mask.new('255.255.255.0')).to be > '255.255.254.0'

      expect(Net::Address::Mask.new(24)).to be  > Net::Address::Mask.new('255.255.254.0')
    end
    it 'should return false if mask is lower' do
      expect(Net::Address::Mask.new(24)).not_to be > 25
      expect(Net::Address::Mask.new(4294967040)).not_to be > 25
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be > 25

      expect(Net::Address::Mask.new(24)).not_to be > 4294967168
      expect(Net::Address::Mask.new(4294967040)).not_to  be > 4294967168
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be > 4294967168

      expect(Net::Address::Mask.new(24)).not_to be > '255.255.255.128'
      expect(Net::Address::Mask.new(4294967040)).not_to be  > '255.255.255.128'
      expect(Net::Address::Mask.new('255.255.255.0')).not_to be >  '255.255.255.128'

      expect(Net::Address::Mask.new(24)).not_to be > Net::Address::Mask.new('255.255.255.128')
    end
  end

end