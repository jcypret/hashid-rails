require 'spec_helper'

describe Hashid::Rails do
  subject(:model) { FakeModel.new(id: 100117) }
  let(:actual_id) { model.id }

  it 'has a version number' do
    expect(Hashid::Rails::VERSION).not_to be nil
  end

  it 'encodes a hashid' do
    expect(model.encoded_id).to eql 'z3m059'
  end

  it 'decodes a hashid' do
    expect(FakeModel.decode_id('z3m059')).to eql actual_id
  end

  it 'returns an array when array is passed in' do
    decoded_ids = FakeModel.decode_id([ FakeModel.encode_id(1) ])
    expect(decoded_ids).to eql [1]
  end

  it 'decodes multiple ids in array' do
    decoded_ids = FakeModel.decode_id([
      FakeModel.encode_id(1),
      FakeModel.encode_id(3),
      FakeModel.encode_id(5),
    ])
    expect(decoded_ids).to eql [1, 3, 5]
  end

  it 'encodes multiple ids' do
    encoded_ids = FakeModel.encode_id([2, 4, 6])
    expect(encoded_ids).to eq ['YznovR', 'OeVre9', 'YNAOva']
  end

  describe '.find_by_hashid' do
    it 'calls find with decoded id' do
      expect(FakeModel).to receive(:find_by!).with({id: 4})
      FakeModel.find_by_hashid('OeVre9')
    end
  end

  describe '.to_param' do
    it 'returns the hashid' do
      expect(model.to_param).to eql 'z3m059'
    end
  end

  describe '.configure' do
    after(:each) { Hashid::Rails.reset }

    describe 'secret' do
      before(:each) do
        Hashid::Rails.configure do |config|
          config.secret = 'my secret'
        end
      end

      it 'encodes to a different hashid' do
        expect(model.encoded_id).to eql 'vGENK4'
      end

      it 'decodes a hashid' do
        expect(FakeModel.decode_id('vGENK4')).to eql actual_id
      end
    end

    describe 'length' do
      it 'defaults to six' do
        expect(model.encoded_id.length).to eql 6
      end

      it 'encodes to custom length' do
        Hashid::Rails.configure do |config|
          config.length = 13
        end

        expect(model.encoded_id.length).to eql 13
      end
    end

    describe 'alphabet' do
      let(:expected_alphabet) { 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' }
      let(:config) { Hashid::Rails.configuration }

      context 'with custom alphabet' do
        before :each do
          Hashid::Rails.configure do |config|
            config.alphabet = expected_alphabet
          end
        end

        it 'initializes hashid correctly'  do
          expect(Hashids)
            .to receive(:new)
            .with('models', config.length, expected_alphabet)
          FakeModel.hashids
        end
      end

      context 'with no custom alphabet' do
        it 'initializes hashid correctly' do
          expect(Hashids)
            .to receive(:new)
            .with('models', config.length)
          FakeModel.hashids
        end
      end
    end
  end

  describe '#reload' do
  end

  describe '#reset' do
    it 'resets the gem configuration to defaults' do
      Hashid::Rails.configure do |config|
        config.secret = 'my secret'
      end

      expect(Hashid::Rails.configuration.secret).to eql 'my secret'

      Hashid::Rails.reset

      expect(Hashid::Rails.configuration.secret).to eql ''
    end
  end
end

class FakeModel
  attr_accessor :id
  include ActiveModel::Model
  include Hashid::Rails

  def self.table_name() "models" end
end
