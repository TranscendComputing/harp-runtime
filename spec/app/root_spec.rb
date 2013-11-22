require 'app_spec_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'app', 'root')

describe "RootApp" do
  def app
    RootApp
  end

  describe "GET /" do
    before :each do
      get "/"
    end

    it "should return a success response code" do
      last_response.should be_ok
    end
  end

  describe "GET /api-docs/" do
    before :each do
      get "/api-docs/"
    end

    it "should return a success response code" do
      last_response.should be_ok
    end

    it "should return the proper content type" do
      last_response.headers["Content-Type"].should eq(JSON_CONTENT)
    end

  end

  describe "GET /user/create/" do
    before :each do
      get "/user/create/"
    end

    it "should return a success response code" do
      last_response.should be_ok
    end

    it "should return the proper content type" do
      last_response.headers["Content-Type"].should eq(HTML_CONTENT)
    end

  end
end
