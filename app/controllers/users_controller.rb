class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(current_user.id)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, info: 'ユーザー登録に成功しました'
    else
      flash.now[:warning] = 'ユーザー登録に失敗しました'
      render :new
    end
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to root_path, info: '登録情報を更新しました'
    else
      flash.now[:warning] = '登録情報の更新に失敗しました'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, images: [])
  end
end
