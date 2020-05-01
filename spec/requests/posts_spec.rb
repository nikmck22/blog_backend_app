require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /api/posts" do
    it "works! (now write some real specs)" do
      user = User.create!(name: "bob", email: "bobbers@bob.com", password: "password", password_confirmation: "password")
      Post.create!(title: "new blog post", body: "bunch of stuff written in blogs", image: "imageimageimage", user_id: user.id)
      get "/api/posts"
      p JSON.parse(response.body)
      posts = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(1)
    end
  end

  describe "GET /api/posts/:id" do
    it "displays specific post" do
      user = User.create!(name: "bob", email: "bobbers@bob.com", password: "password", password_confirmation: "password")

      post_db = Post.create!(title: "this is the newest post there is", body: "blog blogging blogs blogger", image: "imageimageimage", user_id: user.id)

      get "/api/posts/#{post_db.id}"
      post = JSON.parse(response.body)
      p JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post['title']).to eq('this is the newest post there is')

    end
  end

  describe "POST /api/posts" do
    it "creates a new post" do
      user = User.create!(name: "bob", email: "bobbers@bob.com", password: "password", password_confirmation: "password")

      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )

      post "/api/posts", params: {
        title: "another new blog post",
        body: "there is so much to put in this blog post",
        image: "imageimageimage"
      }, headers: {
        "Authorization" => "Bearer #{jwt}"
      }

      p JSON.parse(response.body)
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post['title']).to eq('another new blog post')

    end
  end
end
