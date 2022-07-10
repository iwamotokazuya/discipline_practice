class RanksController < ApplicationController
  skip_before_action :require_login, only: %i[index record]
  before_action :require_login, only: %i[login_record]

  def index
    @biggner = Rank.find(1)
    @intermediate = Rank.find(2)
    @advanced = Rank.find(3)
  end

  def record
    @rank = Rank.find(params[:id])
  end

  def login_record
    @rank = Rank.find(params[:id])
    @user = current_user
  end
end
