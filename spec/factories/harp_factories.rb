
FactoryGirl.define do
  factory :harp_script do
    sequence(:id) {|n| "harp#{n}" }
    location "nowhere"
    version "1.0"
    content VALID_SCRIPT
  end

  factory :harp_resource do
    sequence(:id) {|n| "resource#{n}" }
    name "some_resource"
    type "HarpResource"
    state "starting"
    harp_script
  end
  
  factory :key do
    name "key_resource"
    value "valid_key"
  end
end
