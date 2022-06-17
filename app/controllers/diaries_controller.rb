class DiariesController < ApplicationController
  def index
    @diaries = Diary.all
  end

  def new
    @diary = Diary.new
  end

  def show
    @diary = Diary.find(params[:id])
  end

  def create
    @diary = Diary.new(diary_params)
    @diary.user_id = current_user.id if logged_in?
    if @diary.save
      redirect_to diaries_path, info: '日記の登録に成功しました'
    else
      flash.now[:warning] = '日記の登録に失敗しました'
      render new_diary_path
    end
  end

  def destroy
    @diary = Diary.find(params[:id])
    @diary.destroy
    redirect_to diaries_path, danger:'日記を削除しました'
  end

  def edit
    @diary = Diary.find(params[:id])
  end

  def update
    @diary = Diary.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diaries_path, info: '編集しました'
    else
      render 'edit'
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :start_time, :score, :user_id)
  end

end
