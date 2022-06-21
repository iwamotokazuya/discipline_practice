class RecordsController < ApplicationController
  skip_before_action :require_login, only: %i[new]
  before_action :require_login, only:%i[login_new]

  def new; end

  def login_new
    @user = current_user
  end
end
