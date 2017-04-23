require "spec_helper"

describe Hashid::Rails do
  before(:each) { Hashid::Rails.reset }

  describe "#hashid" do
    it "returns model ID encoded as hashid" do
      model = FakeModel.new(id: 100_117)
      expect(model.hashid).to eq("Qkmc18r3")
    end
  end

  describe "#to_param" do
    it "aliases #hashid" do
      model = FakeModel.new(id: 100_117)
      expect(model.hashid).to eq(model.to_param)
    end
  end

  describe ".encode_id" do
    context "when single id" do
      it "returns hashid" do
        encoded_id = FakeModel.encode_id(100_117)
        expect(encoded_id).to eq("Qkmc18r3")
      end
    end

    context "when array with a single id" do
      it "returns an array with single hashid" do
        encoded_ids = FakeModel.encode_id([1])
        expect(encoded_ids).to eq(["NZwmcg"])
      end
    end

    context "when array with many ids" do
      it "returns an array of hashids" do
        encoded_ids = FakeModel.encode_id([1, 2, 3])
        expect(encoded_ids).to eq(["NZwmcg", "NEdycn", "e71MhR"])
      end
    end
  end

  describe ".decode_id" do
    context "when single param" do
      it "returns decoded hashid" do
        decoded_id = FakeModel.decode_id("Qkmc18r3")
        expect(decoded_id).to eq(100_117)
      end

      it "returns already decoded id" do
        decoded_id = FakeModel.decode_id(100_117)
        expect(decoded_id).to eq(100_117)
      end
    end

    context "when an array" do
      it "returns array with decoded hashid" do
        decoded_ids = FakeModel.decode_id(["NZwmcg"])
        expect(decoded_ids).to eq([1])
      end

      it "returns array with already decoded id" do
        decoded_ids = FakeModel.decode_id([1])
        expect(decoded_ids).to eq([1])
      end
    end

    context "when array with many hashid" do
      it "returns array of decoded hashids" do
        decoded_ids = FakeModel.decode_id(["NZwmcg", "NEdycn", "e71MhR"])
        expect(decoded_ids).to eq([1, 2, 3])
      end

      it "returns array of already decoded ids" do
        decoded_ids = FakeModel.decode_id([1, 2, 3])
        expect(decoded_ids).to eq([1, 2, 3])
      end
    end
  end

  describe ".find" do
    context "when finding single model" do
      it "returns correct model by hashid" do
        model = FakeModel.create!

        result = FakeModel.find(model.hashid)

        expect(result).to eq(model)
      end

      it "returns correct model by id" do
        model = FakeModel.create!

        result = FakeModel.find(model.id)

        expect(result).to eq(model)
      end
    end

    context "when finding multiple models" do
      it "returns correct models by hashids" do
        model1 = FakeModel.create!
        model2 = FakeModel.create!

        result = FakeModel.find([model1.hashid, model2.hashid])

        expect(result).to eq([model1, model2])
      end

      it "returns correct models by ids" do
        model1 = FakeModel.create!
        model2 = FakeModel.create!

        result = FakeModel.find([model1.id, model2.id])

        expect(result).to eq([model1, model2])
      end

      it "returns correct models by mix of hashids and ids" do
        model1 = FakeModel.create!
        model2 = FakeModel.create!

        result = FakeModel.find([model1.hashid, model2.id])

        expect(result).to eq([model1, model2])
      end
    end

    it "does not try and decode regular ids" do
      decoded_id = FakeModel.decode_id(100_117)
      expect(decoded_id).to eq(100_117)
    end

    context "when find is disabled" do
      it "does not decode id" do
        model = FakeModel.create!

        Hashid::Rails.configure do |config|
          config.disable_find = false
        end
        result = FakeModel.find(model.hashid)

        expect(result).to eq(model)

        Hashid::Rails.configure do |config|
          config.disable_find = true
        end

        expect { FakeModel.find(model.hashid) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe ".configure" do
    it "sets gem configuration with block" do
      config = Hashid::Rails.configuration

      aggregate_failures "before config" do
        expect(config.secret).to eq("")
        expect(config.length).to eq(6)
        expect(config.alphabet).to eq(nil)
        expect(config.disable_find).to eq(false)
      end

      Hashid::Rails.configure do |configuration|
        configuration.secret = "shhh"
        configuration.length = 13
        configuration.alphabet = "ABC"
        configuration.disable_find = true
      end

      aggregate_failures "after config" do
        expect(config.secret).to eq("shhh")
        expect(config.length).to eq(13)
        expect(config.alphabet).to eq("ABC")
        expect(config.disable_find).to eq(true)
      end
    end
  end

  describe ".reset" do
    it "resets the gem configuration to defaults" do
      Hashid::Rails.configure do |config|
        config.secret = "my secret"
      end

      expect(Hashid::Rails.configuration.secret).to eql "my secret"

      Hashid::Rails.reset

      expect(Hashid::Rails.configuration.secret).to eql ""
    end
  end

end
