# frozen_string_literal: true

require "spec_helper"

describe Hashid::Rails do
  before(:each) do
    Hashid::Rails.reset
    FakeModel.reset_hashid_config
    Post.reset_hashid_config
    Comment.reset_hashid_config
  end

  describe "#hashid" do
    it "returns model ID encoded as hashid" do
      model = FakeModel.new(id: 100_117)
      expect(model.hashid).to eq("JyiQGy5")
    end
  end

  describe "#to_param" do
    it "aliases #hashid" do
      model = FakeModel.new(id: 100_117)
      expect(model.hashid).to eq(model.to_param)
    end
  end

  describe "#reload" do
    it "reloads model" do
      model = FakeModel.create!(name: "original")

      model.name = "modified"

      expect { model.reload }.to change(model, :name)
        .from("modified").to("original")
    end
  end

  describe "associations" do
    it "accesses associations" do
      post = Post.create!
      comment = Comment.create!(post: post)

      result = Post.find(post.id).comments.find(comment.id)

      expect(result).to eq(comment)
    end

    it "can build associations" do
      post = Post.create!

      comment = post.comments.build

      expect(comment.post_id).to eq(post.id)
    end

    it "works with eager loading" do
      post = Post.create!
      Comment.create!(post: post)

      result = Post.includes(:comments).find(post.hashid)

      expect(result).to eq(post)
    end

    it "finds association through parent" do
      post = Post.create!
      comment = Comment.create!(post: post)

      result = Post.find(post.hashid).comments.find(comment.hashid)

      expect(result).to eq(comment)
    end
  end

  describe ".encode_id" do
    context "when single id" do
      it "returns hashid" do
        encoded_id = FakeModel.encode_id(100_117)
        expect(encoded_id).to eq("JyiQGy5")
      end
    end

    context "when array with a single id" do
      it "returns an array with single hashid" do
        encoded_ids = FakeModel.encode_id([1])
        expect(encoded_ids).to eq(["NPdiEN"])
      end
    end

    context "when array with many ids" do
      it "returns an array of hashids" do
        encoded_ids = FakeModel.encode_id([1, 2, 3])
        expect(encoded_ids).to eq(%w[NPdiEN NwniBe zKwimz])
      end
    end

    context "when hashid signing disabled" do
      before do
        Hashid::Rails.configure { |config| config.sign_hashids = false }
      end

      it "returns unsigned hashid" do
        encoded_id = FakeModel.encode_id(100_117)
        expect(encoded_id).to eq("z3m059")
      end
    end
  end

  describe ".decode_id" do
    context "when single param" do
      it "returns decoded hashid" do
        decoded_id = FakeModel.decode_id("JyiQGy5")
        expect(decoded_id).to eq(100_117)
      end

      it "returns nil when already decoded id" do
        decoded_id = FakeModel.decode_id(100_117, fallback: false)
        expect(decoded_id).to eq(nil)
      end

      it "returns already decoded id when fallback" do
        decoded_id = FakeModel.decode_id(100_117, fallback: true)
        expect(decoded_id).to eq(100_117)
      end
    end

    context "when an array" do
      it "returns array with decoded hashid" do
        decoded_ids = FakeModel.decode_id(["NPdiEN"])
        expect(decoded_ids).to eq([1])
      end

      it "returns array with nil when already decoded id" do
        decoded_ids = FakeModel.decode_id([1], fallback: false)
        expect(decoded_ids).to eq([nil])
      end

      it "returns array with already decoded id when fallback" do
        decoded_ids = FakeModel.decode_id([1], fallback: true)
        expect(decoded_ids).to eq([1])
      end
    end

    context "when array with many hashid" do
      it "returns array of decoded hashids" do
        decoded_ids = FakeModel.decode_id(%w[NPdiEN NwniBe zKwimz])
        expect(decoded_ids).to eq([1, 2, 3])
      end

      it "returns array of nil when already decoded ids" do
        decoded_ids = FakeModel.decode_id([1, 2, 3], fallback: false)
        expect(decoded_ids).to eq([nil, nil, nil])
      end

      it "returns array of already decoded ids when fallback" do
        decoded_ids = FakeModel.decode_id([1, 2, 3], fallback: true)
        expect(decoded_ids).to eq([1, 2, 3])
      end
    end

    context "when hashid signing disabled" do
      before do
        Hashid::Rails.configure { |config| config.sign_hashids = false }
      end

      it "returns decoded unsigned hashid" do
        decoded_id = FakeModel.decode_id("z3m059")
        expect(decoded_id).to eq(100_117)
      end
    end

    context "with letters-only alphabet" do
      before do
        Hashid::Rails.configure { |config| config.alphabet = [*"A".."Z"].join }
      end

      it "returns nil when already decoded id" do
        decoded_id = FakeModel.decode_id(100_117, fallback: false)
        expect(decoded_id).to eq(nil)
      end

      it "returns already decoded id when fallback" do
        decoded_id = FakeModel.decode_id(100_117, fallback: true)
        expect(decoded_id).to eq(100_117)
      end
    end
  end

  shared_examples_for "finders" do
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

      context "when single id as array" do
        it "returns array with correct model by hashid" do
          model = FakeModel.create!

          result = FakeModel.find([model.hashid])

          expect(result).to eq([model])
        end

        it "returns array with correct model by id" do
          model = FakeModel.create!

          result = FakeModel.find([model.id])

          expect(result).to eq([model])
        end
      end

      context "when multiple ids as args" do
        it "returns array of correct models by hashids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find(model1.hashid, model2.hashid)

          expect(result).to eq([model1, model2])
        end

        it "returns array of correct models by ids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find(model1.id, model2.id)

          expect(result).to eq([model1, model2])
        end

        it "returns array of correct models by mix of hashids and ids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find(model1.hashid, model2.id)

          expect(result).to eq([model1, model2])
        end
      end

      context "when multiple ids as an array" do
        it "returns array of correct models by hashids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find([model1.hashid, model2.hashid])

          expect(result).to eq([model1, model2])
        end

        it "returns array of correct models by ids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find([model1.id, model2.id])

          expect(result).to eq([model1, model2])
        end

        it "returns array of correct models by mix of hashids and ids" do
          model1 = FakeModel.create!
          model2 = FakeModel.create!

          result = FakeModel.find([model1.hashid, model2.id])

          expect(result).to eq([model1, model2])
        end
      end

      context "when find is disabled" do
        it "does not decode id" do
          model = FakeModel.create!

          Hashid::Rails.configure do |config|
            config.override_find = true
          end
          FakeModel.reset_hashid_config

          result = FakeModel.find(model.hashid)
          expect(result).to eq(model)

          Hashid::Rails.configure do |config|
            config.override_find = false
          end
          FakeModel.reset_hashid_config

          expect { FakeModel.find(model.hashid) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end

        it "does not call decode_id" do
          model = FakeModel.create!
          Hashid::Rails.configure do |config|
            config.override_find = false
          end

          expect(FakeModel).not_to receive(:decode_id).with(model.id)

          FakeModel.find(model.id)
        end
      end
    end

    describe ".find_by_hashid" do
      it "finds model by hashid" do
        model = FakeModel.create!

        result = FakeModel.find_by_hashid(model.hashid)

        expect(result).to eq(model)
      end

      it "returns nil when unable to find model" do
        result = FakeModel.find_by_hashid("ABC")

        expect(result).to eq(nil)
      end

      it "returns nil for non-hashid" do
        model = FakeModel.create!

        result = FakeModel.find_by_hashid(model.id)

        expect(result).to eq(nil)
      end
    end

    describe ".find_by_hashid!" do
      it "finds model by hashid" do
        model = FakeModel.create!

        result = FakeModel.find_by_hashid!(model.hashid)

        expect(result).to eq(model)
      end

      it "raises record not found when unable to find model" do
        expect { FakeModel.find_by_hashid!("ABC") }
          .to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises record not found for non-hashid" do
        model = FakeModel.create!

        expect { FakeModel.find_by_hashid!(model.id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "finders" do
    context "when signed hashids" do
      before { Hashid::Rails.configuration.sign_hashids = true }
      it_behaves_like("finders")
    end

    context "when unsigned hashids" do
      before { Hashid::Rails.configuration.sign_hashids = false }
      it_behaves_like("finders")
    end
  end

  describe ".configure" do
    it "sets gem configuration with block" do
      config = Hashid::Rails.configuration

      aggregate_failures "before config" do
        expect(config.salt).to eq("")
        expect(config.min_hash_length).to eq(6)
        expect(config.alphabet).to eq(
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        )
        expect(config.override_find).to eq(true)
        expect(config.sign_hashids).to eq(true)
      end

      Hashid::Rails.configure do |configuration|
        configuration.salt = "shhh"
        configuration.min_hash_length = 13
        configuration.alphabet = "ABC"
        configuration.override_find = false
        configuration.sign_hashids = false
      end

      aggregate_failures "after config" do
        expect(config.salt).to eq("shhh")
        expect(config.min_hash_length).to eq(13)
        expect(config.alphabet).to eq("ABC")
        expect(config.override_find).to eq(false)
        expect(config.sign_hashids).to eq(false)
      end
    end

    it "inherits default configuration" do
      config = FakeModel.hashid_configuration

      aggregate_failures "default config" do
        expect(config.salt).to eq("")
        expect(config.pepper).to eq(FakeModel.table_name)
        expect(config.min_hash_length).to eq(6)
        expect(config.alphabet).to eq(
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        )
        expect(config.override_find).to eq(true)
        expect(config.sign_hashids).to eq(true)
      end
    end

    it "supports model-specific config" do
      FakeModel.hashid_config(
        salt: "shhh",
        pepper: "achoo",
        min_hash_length: 7,
        alphabet: "XYZ",
        override_find: false,
        sign_hashids: false
      )

      # model-level has new config
      config = FakeModel.hashid_configuration
      aggregate_failures "model-level config" do
        expect(config.salt).to eq("shhh")
        expect(config.pepper).to eq("achoo")
        expect(config.min_hash_length).to eq(7)
        expect(config.alphabet).to eq("XYZ")
        expect(config.override_find).to eq(false)
        expect(config.sign_hashids).to eq(false)
      end

      # default config does not change
      config = Hashid::Rails.configuration
      aggregate_failures "default config" do
        expect(config.salt).to eq("")
        expect(config.pepper).to eq("")
        expect(config.min_hash_length).to eq(6)
        expect(config.alphabet).to eq(
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        )
        expect(config.override_find).to eq(true)
        expect(config.sign_hashids).to eq(true)
      end
    end

    it "supports different configs for each model" do
      Post.hashid_config(pepper: "achoo")
      Comment.hashid_config(pepper: "gazoontite")

      expect(FakeModel.hashid_configuration.pepper).to eq(FakeModel.table_name)
      expect(Post.hashid_configuration.pepper).to eq("achoo")
      expect(Comment.hashid_configuration.pepper).to eq("gazoontite")
    end
  end

  describe ".reset" do
    it "resets the gem configuration to defaults" do
      Hashid::Rails.configure do |config|
        config.salt = "my secret"
      end

      expect(Hashid::Rails.configuration.salt).to eq "my secret"

      Hashid::Rails.reset

      expect(Hashid::Rails.configuration.salt).to eq ""
    end
  end
end
