FactoryBot.define do
  factory :result do
    score { rand(100) }
    calm { rand(50) }
    anger { rand(50) }
    joy { rand(50) }
    sorrow { rand(50) }
    energy { rand(50) }
    start_time { '2022-06-12' }
    user
    record_voice { Rack::Test::UploadedFile.new('spec/fixtures/audio/femal-test.wav', 'audio/wav') }
  end
end
