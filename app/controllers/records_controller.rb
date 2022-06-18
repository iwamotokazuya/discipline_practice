class RecordsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def login_new
    @user = current_user
  end
end
