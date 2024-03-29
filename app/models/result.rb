class Result < ApplicationRecord
  include IdGenerator

  belongs_to :user
  belongs_to :rank
  has_one :like, dependent: :destroy

  has_one_attached :record_voice

  validates :score, numericality: { only_integer: true }, presence: true
  validates :calm, numericality: { only_integer: true }, presence: true
  validates :anger, numericality: { only_integer: true }, presence: true
  validates :joy, numericality: { only_integer: true }, presence: true
  validates :sorrow, numericality: { only_integer: true }, presence: true
  validates :energy, numericality: { only_integer: true }, presence: true

  def start_time
    self.start_date
  end

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
    self.rank_id = formdata[:rank_id]
    record_voice.attach(formdata[:record_voice])
  end

  def scoreRank
    if self.rank_id == 1
      self.score = (25 + self.anger + (0.25 * (self.energy + self.calm))).round
    elsif self.rank_id == 2
      self.score = (self.anger + (0.5 * (self.energy + self.calm))).round
    elsif self.rank_id == 3
      self.score = (self.anger * 2).round
    end
  end
end
