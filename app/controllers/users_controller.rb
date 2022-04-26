class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
    @result = Result.find(params[:result_id]) if params[:result_id]
  end

  def create
    @user = User.new(user_params)
      auto_login(@user)
      # binding.pry
      redirect_to root_path, notice: 'ユーザー登録に成功しました'
    else
      flash.now[:alert] = 'ユーザー登録に失敗しました'
      render :new
    end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
