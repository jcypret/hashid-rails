require 'spec_helper'

describe Hashid::Rails do

  subject(:model) { Model.new }

  it 'has a version number' do
    expect(Hashid::Rails::VERSION).not_to be nil
  end

  it 'encodes a hashid' do
    expect(model.encoded_id).to eql '4zKEeJ'
  end

  it 'decodes a hashid' do
    expect(Model.decode_id('4zKEeJ')).to eql 1
  end

  describe 'configure' do

    before(:each) do
      Hashid::Rails.configure do |config|
        config.secret = 'my secret'
      end
    end

    after(:each) do
      Hashid::Rails.configure do |config|
        config.secret = ''
      end
    end

    it 'encodes to a different hashid' do
      expect(model.encoded_id).to eql 'pVNwvq'
    end

    it 'decodes a hashid' do
      expect(Model.decode_id('pVNwvq')).to eql 1
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
    1
  end

  def self.connection
    nil
  end

end
