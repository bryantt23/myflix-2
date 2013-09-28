class FollowsController < ApplicationController
  def index
    @followings = current_user.users_followed
  end

  def create
    @follow = current_user.follows.build(:followed_id => params[:followed_id])
    if @follow.save
      flash[:notice] = "You are now following #{@follow.followed.full_name}"
      redirect_to people_path
    else
      flash[:error] = "Unable to follow."
      redirect_to people_path
    end
  end

  def destroy
    f = Follow.where("followed_id == #{params[:id]} AND follower_id == #{current_user.id}")
    f.each do |f|
      Follow.delete(f.id)
    end
    redirect_to people_path
  end
end