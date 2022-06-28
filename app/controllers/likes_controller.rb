class LikesController < ApplicationController
  before_action :require_login, only:%i[create destroy]

  def create
    result = Result.find(params[:result_id])
    current_user.like(result)
    redirect_back fallback_location: result_path(result), success: 'お気に入りに登録しました。'
  end

  def destroy
    result = current_user.likes.find(params[:id]).result
    current_user.unlike(result)
    redirect_back fallback_location: result_path(result), success: 'お気に入り解除となりました。'
  end
end
