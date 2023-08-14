#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 03.01.2018 by Piotr Wojcieszonek

require_relative '../../spec_helper'
require 'ipaddr'
require 'json'

RSpec.describe Net::Address::IPv4 do

  context '#initialize' do
    it 'should return Net::Address::IPv4 when valid IPv4 address given' do
      expect(Net::Address::IPv4.new('10.0.0.1')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new('10.0.0.1', 24)).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.0')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.255')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(167772161)).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(167772161, 24)).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(167772161, '255.255.255.0')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(167772161, '255.255.255.255')).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(Net::Address::IPv4.new('10.0.0.1'))).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new(IPAddr.new('10.0.0.1'))).to be_kind_of Net::Address::IPv4
    end
    it 'should raise ArgumentError when mask given multiple times' do
      expect{Net::Address::IPv4.new('10.0.0.1/24', 24)}.to raise_exception(ArgumentError)
      expect{Net::Address::IPv4.new('10.0.0.1/24', 32)}.to raise_exception(ArgumentError)
    end
    it 'should raise ArgumentError when not valid address given' do
      expect{Net::Address::IPv4.new('10.0.0.256')}.to raise_exception(ArgumentError)
      expect{Net::Address::IPv4.new('10.0.0.1.2')}.to raise_exception(ArgumentError)
      expect{Net::Address::IPv4.new(0xffffffffffff1)}.to raise_exception(ArgumentError)
    end
  end

  context '.to_s' do
    it 'should return string representation of IPv4 address' do
      expect(Net::Address::IPv4.new('10.0.0.1').to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.1/24').to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.1', 24).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.0').to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new(167772161).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new(167772161, 24).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new(167772161, '255.255.255.0').to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1'}).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1', 'mask' => '255.255.255.0'}).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1'}.to_json).to_s).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1', 'mask' => '255.255.255.0'}.to_json).to_s).to eq('10.0.0.1')
    end
  end

  context '.to_str' do
    it 'should return string representation of IPv4 address in CIDR notation' do
      expect(Net::Address::IPv4.new('10.0.0.1').to_str).to eq('10.0.0.1/32')
      expect(Net::Address::IPv4.new('10.0.0.1/24').to_str).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.1', 24).to_str).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.0').to_str).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new(167772161).to_str).to eq('10.0.0.1/32')
      expect(Net::Address::IPv4.new(167772161, 24).to_str).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new(167772161, '255.255.255.0').to_str).to eq('10.0.0.1/24')
    end
  end

  context '.to_json' do
    it 'should return JSON representation of IPv4 address object' do
      expect(JSON.parse(Net::Address::IPv4.new('10.0.0.1/24').to_json)['address']).to eq('10.0.0.1')
      expect(JSON.parse(Net::Address::IPv4.new('10.0.0.1/24').to_json)['mask']).to eq('255.255.255.0')
      expect(JSON.parse(Net::Address::IPv4.new('10.0.0.1/24').to_json)['net']).to eq('10.0.0.0')
      expect(JSON.parse(Net::Address::IPv4.new('10.0.0.1/24').to_json)['broadcast']).to eq('10.0.0.255')
      expect(JSON.parse(Net::Address::IPv4.new('10.0.0.1/24').to_json)['cidr']).to eq('10.0.0.1/24')
    end
  end

  context '.from_json' do
    it 'should return Net::Address::IPv4 when valid JSON  given' do
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1'})).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1'}.to_json)).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1', 'mask' => '255.255.255.0'})).to be_kind_of Net::Address::IPv4
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1', 'mask' => '255.255.255.0'}.to_json)).to be_kind_of Net::Address::IPv4
    end
  end

  context '.to_i' do
    it 'should return integer representation of IPv4 address' do
      expect(Net::Address::IPv4.new('10.0.0.1').to_i).to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.1/24').to_i).to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.1', 24).to_i).to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.0').to_i).to eq(167772161)
      expect(Net::Address::IPv4.new(167772161).to_i).to eq(167772161)
      expect(Net::Address::IPv4.new(167772161, 24).to_i).to eq(167772161)
      expect(Net::Address::IPv4.new(167772161, '255.255.255.0').to_i).to eq(167772161)
    end
  end

  context '.mask' do
    it 'should return Net::Address::Mask object' do
      expect(Net::Address::IPv4.new('10.0.0.1').mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new('10.0.0.1/24').mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new('10.0.0.1', 24).mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new('10.0.0.1', '255.255.255.0').mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new(167772161).mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new(167772161, 24).mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new(167772161, '255.255.255.0').mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1'}.to_json).mask).to be_kind_of Net::Address::Mask
      expect(Net::Address::IPv4.new({'address' => '10.0.0.1', 'mask' => '255.255.255.0'}.to_json).mask).to be_kind_of Net::Address::Mask
    end
  end

  context '.==' do
    it 'should return true if address equal' do
      expect(Net::Address::IPv4.new('10.0.0.1')).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.1')).to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.1')).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.1')).to eq(Net::Address::IPv4.new('10.0.0.1'))
      expect(Net::Address::IPv4.new('10.0.0.1')).to eq(Net::Address::IPv4.new('10.0.0.1/24'))
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to eq(Net::Address::IPv4.new('10.0.0.1'))
      expect(Net::Address::IPv4.new('10.0.0.1/24')).to eq(Net::Address::IPv4.new('10.0.0.1/24'))
      expect(Net::Address::IPv4.new(IPAddr.new('10.0.0.1'))).to eq('10.0.0.1')
    end
  end

  context '.!=' do
    it 'should return true if address not equal' do
      expect(Net::Address::IPv4.new('10.0.0.2')).not_to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.2')).not_to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.2')).not_to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.2')).not_to eq(Net::Address::IPv4.new('10.0.0.1'))
      expect(Net::Address::IPv4.new('10.0.0.2')).not_to eq(Net::Address::IPv4.new('10.0.0.1/24'))
      expect(Net::Address::IPv4.new('10.0.0.2/24')).not_to eq('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.2/24')).not_to eq(167772161)
      expect(Net::Address::IPv4.new('10.0.0.2/24')).not_to eq('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.2/24')).not_to eq(Net::Address::IPv4.new('10.0.0.1'))
      expect(Net::Address::IPv4.new('10.0.0.2/24')).not_to eq(Net::Address::IPv4.new('10.0.0.1/24'))
      expect(Net::Address::IPv4.new(IPAddr.new('10.0.0.2'))).not_to eq('10.0.0.1')
    end
  end

  context '.<' do
    it 'should return true if address lower' do
      expect(Net::Address::IPv4.new('10.0.0.0')).to be < '10.0.0.1'
      expect(Net::Address::IPv4.new('10.0.0.0')).to be < 167772161
      expect(Net::Address::IPv4.new('10.0.0.0')).to be <'10.0.0.1/24'
      expect(Net::Address::IPv4.new('10.0.0.0')).to be < Net::Address::IPv4.new('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.0')).to be < Net::Address::IPv4.new('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.0/24')).to be < '10.0.0.1'
      expect(Net::Address::IPv4.new('10.0.0.0/24')).to be < 167772161
      expect(Net::Address::IPv4.new('10.0.0.0/24')).to be < '10.0.0.1/24'
      expect(Net::Address::IPv4.new('10.0.0.0/24')).to be < Net::Address::IPv4.new('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.0/24')).to be < Net::Address::IPv4.new('10.0.0.1/24')
      expect(Net::Address::IPv4.new(IPAddr.new('10.0.0.0'))).to be < '10.0.0.1'
    end
  end

  context '.<' do
    it 'should return true if address greater' do
      expect(Net::Address::IPv4.new('10.0.0.3')).to be > '10.0.0.1'
      expect(Net::Address::IPv4.new('10.0.0.3')).to be > 167772161
      expect(Net::Address::IPv4.new('10.0.0.3')).to be >'10.0.0.1/24'
      expect(Net::Address::IPv4.new('10.0.0.3')).to be > Net::Address::IPv4.new('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.3')).to be > Net::Address::IPv4.new('10.0.0.1/24')
      expect(Net::Address::IPv4.new('10.0.0.3/24')).to be > '10.0.0.1'
      expect(Net::Address::IPv4.new('10.0.0.3/24')).to be > 167772161
      expect(Net::Address::IPv4.new('10.0.0.3/24')).to be > '10.0.0.1/24'
      expect(Net::Address::IPv4.new('10.0.0.3/24')).to be > Net::Address::IPv4.new('10.0.0.1')
      expect(Net::Address::IPv4.new('10.0.0.3/24')).to be > Net::Address::IPv4.new('10.0.0.1/24')
      expect(Net::Address::IPv4.new(IPAddr.new('10.0.0.3'))).to be > '10.0.0.1'
    end
  end

  context '.net' do
    it 'should return network address' do
      expect(Net::Address::IPv4.new('10.0.0.3/24').net).to eq '10.0.0.0'
      expect(Net::Address::IPv4.new('10.0.0.3').net).to eq '10.0.0.3'
    end
  end
  context '.broadcast' do
    it 'should return broadcast address' do
      expect(Net::Address::IPv4.new('10.0.0.3/24').broadcast).to eq '10.0.0.255'
      expect(Net::Address::IPv4.new('10.0.0.3').broadcast).to eq '10.0.0.3'
    end
  end

  context '.include?' do
    it 'should return true if address included in given network' do
      ip = Net::Address::IPv4.new('10.0.0.1/24')
      (167772160..167772415).each do |i|
        expect(ip.include?(i)).to be_truthy
      end
    end
    it 'should return false if address not included in given network' do
      ip = Net::Address::IPv4.new('10.0.0.1/25')
      (167772288..167772415).each do |i|
        expect(ip.include?(i)).to be_falsey
      end
    end
  end

  context '.previous' do
    it 'should return previous address in given network' do
      expect(Net::Address::IPv4.new('10.0.0.3/24').previous).to eq '10.0.0.2'
    end
    it 'should return nil if previous address lower then network address' do
      expect(Net::Address::IPv4.new('10.0.0.0/24').previous).to be_nil
    end
  end

  context '.next' do
    it 'should return next address in given network' do
      expect(Net::Address::IPv4.new('10.0.0.3/24').next).to eq '10.0.0.4'
    end
    it 'should return nil if next address greater then broadcast address' do
      expect(Net::Address::IPv4.new('10.0.0.255/24').next).to be_nil
    end
  end

  context '.each' do
    it 'should yield each address in network' do
      counter = 0
      Net::Address::IPv4.new('10.0.0.3/24').each do |address|
        expect(address).to eq (167772160 + counter)
        counter += 1
      end
      expect(counter).to eq(256)
    end
  end

end