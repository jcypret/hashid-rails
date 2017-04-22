require "spec_helper"

describe Hashid::Rails do
  subject(:model) { FakeModel.new(id: 100_117) }
  let(:actual_id) { model.id }

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
      decoded_id = FakeModel.decode_id(100117)
      expect(decoded_id).to eq(100117)
    end
  end

  describe ".configure" do
    after(:each) { Hashid::Rails.reset }

    describe "secret" do
      before(:each) do
        Hashid::Rails.configure do |config|
          config.secret = "my secret"
        end
      end

      it "encodes to a different hashid" do
        expect(model.hashid).to eql "e3Yc4OyG"
      end

      it "decodes a hashid" do
        expect(FakeModel.decode_id("e3Yc4OyG")).to eql actual_id
      end
    end

    describe "length" do
      xit "defaults to six" do
        expect(FakeModel.configurations.length).to eql 6
      end

      it "encodes to custom length" do
        Hashid::Rails.configure do |config|
          config.length = 13
        end

        expect(model.hashid.length).to eql 13
      end
    end

    describe "alphabet" do
      let(:expected_alphabet) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
      let(:config) { Hashid::Rails.configuration }

      context "with custom alphabet" do
        before :each do
          Hashid::Rails.configure do |config|
            config.alphabet = expected_alphabet
          end
        end

        it "initializes hashid correctly" do
          expect(Hashids)
            .to receive(:new)
            .with("models", config.length, expected_alphabet)
          FakeModel.hashids
        end
      end

      context "with no custom alphabet" do
        it "initializes hashid correctly" do
          expect(Hashids)
            .to receive(:new)
            .with("models", config.length)
          FakeModel.hashids
        end
      end
    end

    describe "disable_find" do
      let(:expected_alphabet) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" }
      let(:config) { Hashid::Rails.configuration }

      before :each do
        Hashid::Rails.configure do |config|
          config.alphabet = expected_alphabet
          config.length = 6
        end
      end

      context "unset" do
        it "unhashes argument in find method" do
          # 100_024 was selected because it unhashes to 187_412
          model = FakeModel.create!
          model.update!(id: 187_412)
          expect(FakeModel.find(100_024).id).to eql 187_412
        end
      end

      context "set to false" do
        it "unhashes argument in find method" do
          Hashid::Rails.configure do |config|
            config.disable_find = false
          end
          # 100_024 was selected because it unhashes to 187_412
          expect(FakeModel.find(100_024).id).to eql 187_412
        end
      end

      context "set to true" do
        it "does not unhash argument in find method" do
          Hashid::Rails.configure do |config|
            config.disable_find = true
          end
          # 100024 was selected because it unhashes to 187412
          model = FakeModel.create!
          model.update!(id: 100_024)
          expect(FakeModel.find(100_024).id).to eql 100_024
        end
      end
    end
  end

  describe "#reset" do
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
