
FactoryGirl.define do
  factory :harp_script do
    sequence(:id) {|n| "harp#{n}" }
    location "nowhere"
    version "1.0"
    content VALID_SCRIPT
  end
end
