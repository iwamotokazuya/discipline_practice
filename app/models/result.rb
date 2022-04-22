class Result < ApplicationRecord
  include IdGenerator

  belongs_to :user
  
  has_one_attached :record_voice

  validates :score, numericality: { only_integer: true }, presence: true
  validates :calm, numericality: { only_integer: true }, presence: true
  validates :anger, numericality: { only_integer: true }, presence: true
  validates :joy, numericality: { only_integer: true }, presence: true
  validates :sorrow, numericality: { only_integer: true }, presence: true
  validates :energy, numericality: { only_integer: true }, presence: true

  def empath(formdata)
    conn = Faraday::Connection.new('url': ENV['API_URL']) do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    response = conn.post do |req|
      req.body = {
        apikey: ENV['API_KEY'],
        wav: Faraday::Multipart::FilePart.new(formdata[:record_voice], 'audio/wav')
      }
    end
    judge(formdata, response)
  end

  def judge(formdata, response)
    hash = JSON.parse(response.body)
      self.calm = hash['calm']
      self.anger = hash['anger']
      self.joy = hash['joy']
      self.sorrow = hash['sorrow']
      self.energy = hash['energy']
      self.score = (25 + (0.5 * (anger) + 0.25 * (sorrow + energy))).round
    record_voice.attach(formdata[:record_voice])
  end
end
