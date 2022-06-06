class ResultsController < ApplicationController
  skip_before_action :require_login, only: %i[create show]

  def create
    @result = Result.new
    @result.empath(result_params)

    if logged_in?
      @result.user_id = current_user.id
    else
      @result.user_id = 1
    end
    render json: { url: result_path(@result) } if @result.save
  end

  def show
    @result = Result.find(params[:id])
    @comment = Comment.find_comment(@result)
  end

  private

  def result_params
    params.permit(:record_voice)
  end
end
