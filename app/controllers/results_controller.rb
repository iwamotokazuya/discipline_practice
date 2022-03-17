class ResultsController < ApplicationController
  def create
    conn = Faraday::Connection.new(:url => 'https://api.webempath.net/v2/analyzeWav') do |f|
      f.request :url_encoded
      f.response :logger
      f.request :multipart
      f.adapter Faraday.default_adapter
    end

    response = conn.post do |req|
      req.body = {
        apikey: 'YOUR API KEY',
        wav: Faraday::Multipart::FilePart.new(formdata[:voice], 'audio/wav')
      }
    end

    res = requests.post(url, params=payload, files=file)
    # print(res.json())
    judge(formdata, response)
  end
end
