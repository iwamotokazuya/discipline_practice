class Comment < ApplicationRecord

  validates :comment, length: { maximum: 255 }, presence: true

  def self.find_comment(result)
    if result.score >= 85
      comment = '完璧です。言うことなし！'
    elsif result.score >= 70 && result.score <=84
      comment = '良いですね。この調子でいきましょう！'
    elsif result.score >= 45 && result.score <=69
      comment = 'まぁまぁですね。もう少し怒っても良いかも！'
    elsif result.score < 45
      comment = 'もっと怒り要素を強めてみよう！'
    elsif result.score < 85 && result.calm >= 40
      comment = 'もっと感情出して！'
    elsif result.score < 85 && result.joy >= 40
      comment = '楽しい？'
    elsif result.score < 85 && result.sorrow >= 40
      comment = '悲観しすぎ？'
    elsif result.score < 85 && result.energy >= 40
      comment = '勢いありすぎてビビっちゃう！'
    elsif result.anger >= 40
      comment = '怒りすぎて怖い！'
    else
      comment = 'エラー！！'
    end
  end
end
