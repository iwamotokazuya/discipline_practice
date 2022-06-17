FactoryBot.define do
  factory :diary do
    title { 'MyString' }
    body { 'MyText' }
    start_time { '2022-06-12' }
    score { 1 }
    user
  end
end
