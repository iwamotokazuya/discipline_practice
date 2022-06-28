class ResultsController < ApplicationController
  skip_before_action :require_login, only: %i[create show]
  before_action :require_login, only: %i[loginresults likes]

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

  def show
    @result = Result.find(params[:id])
    @comment = Comment.find_comment(@result)
  end

  def loginresults
    @result = Result.find(params[:id])
    @comment = Comment.find_comment(@result)
  end

  def likes
    @like_results = current_user.like_results.includes(:user)
  end

  private

  def result_params
    params.permit(:record_voice)
  end
end
