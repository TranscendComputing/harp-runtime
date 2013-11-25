require 'app_spec_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'app', 'harp_api')

describe "HarpApiApp" do
  def app
    HarpApiApp
  end

  before :each do
  end

  after :each do
    # this test uses the db storage for uniqueness testing, so need to clean between runs
    DatabaseCleaner.clean
  end

  describe "POST /create" do
    before :each do
      post "/create"
    end

    it "should return a success response code" do
      last_response.should be_ok
    end

    it "should return the proper content type" do
      last_response.headers["Content-Type"].should eq(JSON_CONTENT)
    end
  end

  describe "POST /destroy/:harp_id" do
    before :each do
      @harp_script = FactoryGirl.create(:harp_script)
      post "/destroy/#{@harp_script.id}"
    end

    it "should return a success response code" do
      last_response.should be_ok
    end

    it "should return the proper content type" do
      last_response.headers["Content-Type"].should eq(JSON_CONTENT)
    end

    it "should return 404 if not found" do
      get "/destroy/#{@harp_script.id}_bogus_id"
      last_response.status.should eq(Rack::Utils.status_code(:not_found))
    end
  end
end

