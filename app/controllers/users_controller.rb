class UsersController < ApplicationController
  def new
    @user = User.new
    @result = Result.find(params[:result_id]) if params[:result_id]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path
      flash[:notice] = 'ユーザーの作成に成功しました'
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
