class Users::AttachmentsController < ApplicationController
  def destroy
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_to edit_user_path
  end
end
