class RanksController < ApplicationController
  skip_before_action :require_login, only: %i[index record]
  before_action :require_login, only: %i[login_record]
  before_action :set_rank, only: %i[record login_record]

  def index
    @beginner = Rank.find(1)
    @intermediate = Rank.find(2)
    @advanced = Rank.find(3)
  end

  def record; end

  def login_record
    @user = current_user
  end

  private

  def set_rank
    @rank = Rank.find(params[:id])
  end
end
