require File.dirname(__FILE__) + '/spec_helper'
require "rubygems"
require "harp_runtime"

describe HarpResource, "persistence" do

  let(:harp_script) { harp_resource.harp_script }

  let(:harp_resource) { FactoryGirl.create(:harp_resource) }

  let(:found_script) { HarpScript.get(harp_script.id) }

  let(:harp_resource2) do
    harp_resource2 = FactoryGirl.build(:harp_resource)
  end

  it "saves resources" do
    resources = found_script.harp_resources
    expect(found_script.content).to eq(harp_script.content)
    expect(resources.size).to eq(1)
  end

  it "supports uniqueness" do
    harp_resource2.harp_script = harp_script
    harp_resource2.save
    resources = found_script.harp_resources
    expect(found_script.content).to eq(harp_script.content)
    expect(resources.size).to eq(2)
  end

  it "enforces uniqueness within script" do
    harp_resource2.harp_script = harp_script
    harp_resource2.id = harp_resource.id
    expect { harp_resource2.save }.to raise_error
    resources = found_script.harp_resources
    expect(found_script.content).to eq(harp_script.content)
    expect(resources.size).to eq(1)
  end

end
