class User::AttachmentsController < UsersController
  before_action :set_user
  def destroy
    @image = ActiveStorage::Attachment.find(params[:id])
    # @user.images.find(params[:id]).purge if params[:status] == 'images'
    # @image = ActiveStorage::Attachment.find_by!(id: params[:attached_id])
    @image.purge
    redirect_to edit_user_path
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
