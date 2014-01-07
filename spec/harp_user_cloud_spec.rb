require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"

shared_context 'when have a harp user' do
  let(:harp_user) do
    @new_harp_user = HarpUser.create(:name => 'TestUser1')
    @new_harp_user.harp_scripts << harp_script
    @new_harp_user.keys << key
    @new_harp_user.save
    @new_harp_user.instance_variable_get(:@id)
  end
  let(:harp_script) { @new_harp_script = harp_resource.harp_script }

  let(:key) { @new_key = Key.create(:name=>'testKey',:value => '0testKeyValue0') }

  let(:harp_resource) { FactoryGirl.create(:harp_resource) }

  let(:found_script) { HarpScript.get(harp_script.id) }

  let(:found_user) { @found_user = HarpUser.get(harp_user) }

  let(:found_key) {
    @found_key = Key.all(:name => key.name).first
    temp_file = @found_key.temp_file
    @found_value = temp_file.open.read
    temp_file.close
    temp_file.unlink
    @found_key
  }

  let(:harp_resource2) do
    harp_resource2 = FactoryGirl.build(:harp_resource)
  end
end

describe HarpUser, "#create" do
  include_context "when have a harp user"
  it "creates a harp user" do
    harp_user
    expect(HarpUser.entries.count).to eq(1)
    expect(@new_harp_user.name).to eq('TestUser1')
  end
  it "associates a harp script with a harp user" do
    found_user
    expect(@found_user.harp_scripts.entries.count).to eq(1)
    expect(@found_user.harp_scripts.first).to eq(@new_harp_script)
  end
  it "associates a key with a harp user" do
    found_user
    expect(@found_user.keys.entries.count).to eq(1)
    expect(@found_user.keys.first).to eq(@new_key)
  end
  it "retrieves a key based on name" do
    found_key
    expect(@found_value).to eq(@new_key.value)
  end
end
