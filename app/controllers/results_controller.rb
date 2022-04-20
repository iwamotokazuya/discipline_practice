class ResultsController < ApplicationController
  def create
    @result = Result.new
    @result.empath(result_params)

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
