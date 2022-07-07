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
                        1
                      end
    @result.start_time = Date.today
    if params[:part] == 'all'
      render json: { url: result_path(@result) } if @result.save
    else
      render json: { url: loginresults_result_path(@result) } if @result.save
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
    params.permit(:record_voice, :rank_id)
  end

  def set_result
    @result = Result.find(params[:id])
    @rank = Rank.find(@result.rank_id)
    @comment = Comment.find_comment(@result)
  end
end
