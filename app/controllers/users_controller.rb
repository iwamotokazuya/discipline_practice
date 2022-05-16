class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
    # @result = Result.find(params[:result_id]) if params[:result_id]
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      # binding.pry
      # if result_params.present?
      #   @result = Result.find(result_params[:result][:id])
      #   @result.update(user_id: current_user.id)
      # end
      redirect_to root_path, notice: 'ユーザー登録に成功しました'
    else
      flash.now[:alert] = 'ユーザー登録に失敗しました'
      render :new
    end
  end

    def update
      @user = User.find(current_user.id)
      if @user.update(user_params)
        flash.now[:notice] = '登録情報を更新しました'
      else
        flash.now[:alert] = '登録情報の更新に失敗しました'
      end
      redirect_to root_path
    end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, images: [])
  end

  # def result_params
  #   params.require(:user).permit(result: [:id])
  # end
end
