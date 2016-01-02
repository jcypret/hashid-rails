require 'spec_helper'

describe Hashid::Rails do

  subject(:model) { Model.new }
  let(:actual_id) { model.id }

  it 'has a version number' do
    expect(Hashid::Rails::VERSION).not_to be nil
  end

  it 'encodes a hashid' do
    expect(model.encoded_id).to eql 'z3m059'
  end

  it 'decodes a hashid' do
    expect(Model.decode_id('z3m059')).to eql actual_id
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
        expect(Model.decode_id('vGENK4')).to eql actual_id
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

  end

  describe '#reload' do

    let(:decoded_id) { Model.decode_id(actual_id) } # 26894362

    before do
      # to find an id that decodes as if it were a valid hashid (by brute force)
      #(10000..100000000).each do |i|
      #  decoded_id = Model.decode_id(i)
      #  raise "#{decoded_id} decodes from real id #{i}" if decoded_id
      #end
    end

    it 'prerequesite: real id returns a value from decode_id' do
      expect(decoded_id).to_not be_nil
      expect(Model.decode_id(actual_id)).to eql decoded_id
    end

    it 'should use real id' do
      expect_any_instance_of(Model::ActiveRecord_Relation).to receive(:find_with_ids) do |instance, id|
        expect(id).to eql actual_id
      end
      expect(subject.reload).to eql subject
    end

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

class Model < ActiveRecord::Base

  def self.columns_hash
    {id: ActiveRecord::ConnectionAdapters::Column.new('id', nil, 'integer', 'integer')}
  end

  def self.attributes_builder
    @attributes_builder ||= ActiveRecord::AttributeSet::Builder.new(column_types, columns_hash[:id])
  end

  def self.columns
    columns_hash.map {|k,v| v}
  end

  def self.get_primary_key(base_name)
    columns_hash[:id]
  end

  def self.column_types
    columns_hash
  end

  def id
    100117
  end

  def self.connection
    FakeConnection.new
  end

end

class FakeConnection
  def clear_query_cache; end
end
