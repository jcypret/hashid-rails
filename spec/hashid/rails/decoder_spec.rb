# frozen_string_literal: true

require "spec_helper"

describe Hashid::Rails::Decoder do
  describe "#decode_params" do
    let(:post) { Post.new(id: 1) }
    let(:image) { Image.new(id: 1) }
    let(:author) { Author.new(id: 1) }
    let(:another_author) { Author.new(id: 2) }
    let(:topic_one) { Topic.new(id: 1) }
    let(:topic_two) { Topic.new(id: 2) }
    let(:comment_one) { Comment.new(id: 1) }
    let(:comment_two) { Comment.new(id: 2) }
    let(:sponsor_id) { "acme-rockets-01" }
    let(:post_params) do
      {
        id: post.to_param,
        title: "Title"
      }
    end
    let(:author_params) do
      {
        author_id: author.to_param
      }
    end
    let(:topic_params) do
      {
        topic_ids: [
          topic_one.to_param,
          topic_two.to_param
        ]
      }
    end
    let(:comments_params) do
      {
        comments_attributes: {
          "0" => {
            id: comment_one.to_param
          },
          "1" => {
            id: comment_two.to_param
          }
        }
      }
    end
    let(:image_params) do
      {
        image_id: image.to_param
      }
    end
    let(:sponsor_params) do
      {
        sponsor_id: sponsor_id
      }
    end

    it "decodes id and nothing else" do
      actual = Hashid::Rails::Decoder.decode_params(Post, post_params)
      expect(actual[:id]).to eq(post.id)
      expect(actual[:title]).to eq("Title")
    end

    it "decodes belongs_to association" do
      params = post_params.merge(author_params)
      actual = Hashid::Rails::Decoder.decode_params(Post, params)
      expect(actual[:author_id]).to eq(author.id)
    end

    it "decodes has_many association" do
      params = post_params.merge(comments_params)
      actual = Hashid::Rails::Decoder.decode_params(Post, params)
      expect(actual[:comments_attributes]["0"][:id]).to eq(comment_one.id)
      expect(actual[:comments_attributes]["1"][:id]).to eq(comment_two.id)
    end

    it "decodes has_and_belongs_to_many association" do
      params = post_params.merge(topic_params)
      actual = Hashid::Rails::Decoder.decode_params(Post, params)
      expect(actual[:topic_ids][0]).to eq(topic_one.id)
      expect(actual[:topic_ids][1]).to eq(topic_two.id)
    end

    it "passes over un-hashed ids" do
      actual = Hashid::Rails::Decoder.decode_params(Post, id: post.id)
      expect(actual[:id]).to eq(post.id)
    end

    it "handles when hashid not enabled" do
      params = post_params.merge(image_params)
      actual = Hashid::Rails::Decoder.decode_params(Post, params)
      expect(actual[:image_id]).to eq(image.id.to_s)
    end

    it "handles params that look like associations but aren't" do
      params = post_params.merge(sponsor_params)
      actual = Hashid::Rails::Decoder.decode_params(Post, params)
      expect(actual[:sponsor_id]).to eq(sponsor_id)
    end
  end
end
