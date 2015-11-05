require 'spec_helper'

describe Hashid::Rails do
  it 'has a version number' do
    expect(Hashid::Rails::VERSION).not_to be nil
  end

  context "when length defined" do
    before do
      class User < ActiveRecord::Base
        hashid length: 10
      end
    end

    it "returns correct length" do
      expect(User.hashids.min_hash_length).to eq(10)
      expect(User.encode_id(1).size).to eq(10)
    end
  end
end
