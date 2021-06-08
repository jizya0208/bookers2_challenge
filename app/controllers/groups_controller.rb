class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @book = Book.new
    @groups = Group.all
  end
  
  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end
  
  def join
    @group = Group.find(params[:id])
    @group.users << current_user
    redirect_to  groups_path
  end

  
  def new
    @group = Group.new
    # @group.users << current_user    #グループ作成者を加入
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group_user = GroupUser.create(group_id: @group.id, user_id: current_user.id)
      redirect_to groups_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end
  
  private
  def group_params
    params.require(:group).permit(:name, :describe, :group_image)
  end
  
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
