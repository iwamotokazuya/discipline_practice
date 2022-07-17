class ResultsController < ApplicationController
  skip_before_action :require_login, only: %i[create show]
  before_action :require_login, only: %i[loginresults likes likeresults]
  before_action :set_result, only: %i[show loginresults likeresults]

  def create
    @result = Result.new
    @result.empath(result_params)
    @result.user_id = if logged_in?
                        current_user.id
                      else
                        Settings.user[:guest]
                      end
    @result.scoreRank
    @result.start_time = Date.today
    @result.save!
    if params[:part] == 'all'
      render json: { url: result_path(@result) }
    else
      render json: { url: loginresults_result_path(@result) }
    end
  end

  def show; end

  def loginresults; end

  def likeresults; end

  def likes
    @like_results = current_user.like_results.includes(:user)
  end

  private

  def result_params
    params.permit(:record_voice, :rank_id, :part)
  end

  def set_result
    @result = Result.find(params[:id])
    @rank = Rank.find(@result.rank_id)
    @beginner_comment = Comment.beginner_comment(@result)
    @intermediate_comment = Comment.intermediate_comment(@result)
    @advanced_comment = Comment.advanced_comment(@result)
  end
end
