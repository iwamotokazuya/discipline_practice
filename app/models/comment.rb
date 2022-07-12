class Comment < ApplicationRecord
  validates :comment, length: { maximum: 255 }, presence: true

  def self.beginner_comment(result)
    comment = if result.score >= 85
                'とても良いしつけができるでしょう。中級に挑戦だ！'
              elsif result.score >= 70 && result.score <= 84
                '良いですね。この調子でいきましょう！'
              elsif result.score >= 45 && result.score <= 69
                'もう少し怒るべし！'
              elsif result.score < 45
                'もっともっと怒って！'
              elsif result.score < 50 && result.energy >= 40
                '勢いが強い！マイクとの距離をあけてみよう。'
              else
                'エラー！！'
              end
  end

  def self.intermediate_comment(result)
    comment = if result.score >= 85
                'しつけが完璧できることでしょう。言うことなし！'
              elsif result.score >= 70 && result.score <= 84
                '良いですね。この調子でいきましょう！'
              elsif result.score >= 45 && result.score <= 69
                'もう少し怒ってみよう！'
              elsif result.score < 45
                'もっと怒り要素を強めてみよう！'
              elsif result.score < 50 && result.energy >= 40
                '勢いが強い！マイクとの距離をあけてみよう。'
              else
                'エラー！！'
              end
  end

  def self.advanced_comment(result)
    comment = if result.score >= 85
                '完璧な怒りです。怒り度MAX！'
              elsif result.score >= 70 && result.score <= 84
                '素晴らしい怒りですね。この調子でいきましょう！'
              elsif result.score >= 50 && result.score <= 69
                '程々怒りですね。もう少し怒っても！'
              elsif result.score >= 30 && result.score <= 49
                'もっと怒り要素を強めてみよう！'
              elsif result.score < 29
                'もっと怒り感情を出して！'
              elsif result.score < 50 && result.energy >= 40
                '勢いが強い！マイクとの距離をあけてみよう'
              else
                'エラー！！'
              end
  end
end
