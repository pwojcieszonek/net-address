#Author: Piotr Wojcieszonek
#e-mail: piotr@wojcieszonek.pl
# Copyright 29.12.2017 by Piotr Wojcieszonek

require_relative '../../spec_helper'

RSpec.describe Net::Address::MAC do

  context '#initialize' do
    it 'should create Net::Address::MAC when string representation of MAC address given' do
      expect(Net::Address::MAC.new('0000.1111.2222')).to be_kind_of(Net::Address::MAC)
      expect(Net::Address::MAC.new('00:00:11:11:22:22')).to be_kind_of(Net::Address::MAC)
      expect(Net::Address::MAC.new('00-00-11-11-22-22')).to be_kind_of(Net::Address::MAC)
      expect(Net::Address::MAC.new('000011112222')).to be_kind_of(Net::Address::MAC)
      expect(Net::Address::MAC.new(%w(00 00 11 11 22 22))).to be_kind_of(Net::Address::MAC)
    end
    it 'should create Net::Address::MAC when integer representation of MAC address given' do
      expect(Net::Address::MAC.new(286335522)).to be_kind_of(Net::Address::MAC)
    end
    it 'should create Net::Address::MAC when Net::Address::MAC given' do
      expect(Net::Address::MAC.new(Net::Address::MAC.new(286335522))).to be_kind_of(Net::Address::MAC)
    end
    it 'should raise Exception when wrong address given' do
      expect{ Net::Address::MAC.new(0xffffffffffff1)}.to raise_exception ArgumentError
    end
  end

  before :each do
    @addresses = []
    @addresses << Net::Address::MAC.new('0000.1111.2222')
    @addresses << Net::Address::MAC.new('00-00-11-11-22-22')
    @addresses << Net::Address::MAC.new('00:00:11:11:22:22')
    @addresses << Net::Address::MAC.new('000011112222')
    @addresses << Net::Address::MAC.new(286335522)
    @addresses << Net::Address::MAC.new(%w(00 00 11 11 22 22))
  end

  context '.to_s' do
    context 'when no separator given' do
      it 'should return string representation of MAC Address' do
        i = 0
        @addresses.each do |address|
          expect(address.to_s).to eq('0000.1111.2222'), "For addresses #{i} expected that #{address.to_s} would be equal '0000.1111.2222'"
          i += 1
        end
      end
    end
    context 'when separator given' do
      it 'should return string representation of MAC Address' do
        i = 0
        @addresses.each do |address|
          expect(address.to_s('.')).to eq('0000.1111.2222'), "For addresses #{i} expected that #{address.to_s} would be equal '0000.1111.2222'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          expect(address.to_s('.', 0)).to eq('000011112222'), "For addresses #{i} expected that #{address.to_s} would be equal '000011112222'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          expect(address.to_s('.', 2)).to eq('00.00.11.11.22.22'), "For addresses #{i} expected that #{address.to_s} would be equal '00.00.11.11.22.22'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          expect(address.to_s('.', 4)).to eq('0000.1111.2222'), "For addresses #{i} expected that #{address.to_s} would be equal '0000.1111.2222'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          expect(address.to_s('.',nil)).to eq('000011112222'), "For addresses #{i} expected that #{address.to_s} would be equal '000011112222'"
          i += 1
        end
      end
      it 'should raise ArgumentError when wrong step given' do
        i = 0
        @addresses.each do |address|
          expect{address.to_s('.',1)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          expect{address.to_s('.',3)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          expect{address.to_s('.',5)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          expect{address.to_s('.',6)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          expect{address.to_s('.',7)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          expect{address.to_s('.',8)}.to  raise_exception(ArgumentError), "For addresses #{i} expected that raise exception ArgumentError"
          i += 1
        end
      end
    end
    context 'when separator is nil' do
      it 'should return string representation of MAC Address' do
        i = 0
        @addresses.each do |address|
          expect(address.to_s(nil)).to eq('000011112222'), "For addresses #{i} expected that #{address.to_s} would be equal '000011112222'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          expect(address.to_s(nil,nil)).to eq('000011112222'), "For addresses #{i} expected that #{address.to_s} would be equal '000011112222'"
          i += 1
        end
        i = 0
        @addresses.each do |address|
          (0..12).each do |step|
            expect(address.to_s(nil,step)).to eq('000011112222'), "For addresses #{i} expected that #{address.to_s} would be equal '000011112222'"
          end
          i += 1
        end
      end
    end
  end

  context '.to_i' do
    it 'should return integer representation of MAC Address' do
      i = 0
      @addresses.each do |address|
        expect(address.to_i).to eq(286335522), "For addresses #{i} expected that #{address.to_s} would be equal 286335522"
        i += 1
      end
    end
  end

  context '.octets' do
    it 'should return array of octets' do
      i = 0
      @addresses.each do |address|
        expect(address.octets).to eq(%w(00 00 11 11 22 22)), "For addresses #{i} expected that #{address.to_s} would be equal 286335522"
        i += 1
      end
    end
  end

  context '.octets' do
    it 'should return array of octets' do
      i = 0
      @addresses.each do |address|
        expect(address.to_a).to eq(%w(00 00 11 11 22 22)), "For addresses #{i} expected that #{address.to_s} would be equal 286335522"
        i += 1
      end
    end
  end

  context '.==' do
    it 'should return true if MAC address match' do
      i = 0
      @addresses.each do |address|
        expect(address).to eq(286335522), "For addresses #{i} expected that #{address} would be equal 286335522"
        expect(address).to eq('00-00-11-11-22-22'), "For addresses #{i} expected that #{address} would be equal '00-00-11-11-22-22'"
        expect(address).to eq('0000.1111.2222'), "For addresses #{i} expected that #{address} would be equal '0000.1111.2222'"
        expect(address).to eq('00:00:11:11:22:22'), "For addresses #{i} expected that #{address} would be equal '00:00:11:11:22:22'"
        expect(address).to eq(Net::Address::MAC.new('00:00:11:11:22:22')), "For addresses #{i} expected that #{address} would be equal Net::Address::MAC.new('00:00:11:11:22:22')"
        i += 1
      end
    end
  end

  context '.!=' do
    it 'should return true if MAC address match' do
      i = 0
      @addresses.each do |address|
        expect(address).not_to eq(286335521), "For addresses #{i} expected that #{address} would not be equal 286335521"
        expect(address).not_to eq('00-00-11-11-22-21'), "For addresses #{i} expected that #{address} would not be equal '00-00-11-11-22-21'"
        expect(address).not_to eq('0000.1111.2221'), "For addresses #{i} expected that #{address} would not be equal '0000.1111.2221'"
        expect(address).not_to eq('00:00:11:11:22:21'), "For addresses #{i} expected that #{address} would not be equal '00:00:11:11:22:21'"
        expect(address).not_to eq(Net::Address::MAC.new('00:00:11:11:22:21')), "For addresses #{i} expected that #{address} would not be equal Net::Address::MAC.new('00:00:11:11:22:21')"
        i += 1
      end
    end
  end



end