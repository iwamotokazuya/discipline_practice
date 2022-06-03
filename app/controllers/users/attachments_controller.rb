class Users::AttachmentsController < ApplicationController
  before_action :set_user

  def destroy
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_to edit_user_path
  end

  private

  def set_user
    user_id = User.find(current_user.id)
  end
end
