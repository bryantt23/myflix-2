class FollowsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    @follow = current_user.following_relationships.build(:followed_id => params[:followed_id])
    if @follow.save
      flash[:notice] = "You are now following #{@follow.followed.full_name}"
      redirect_to people_path
    else
      flash[:error] = "Unable to follow."
      redirect_to people_path
    end
  end

  def destroy
    followed = Follow.where("followed_id == #{params[:id]} AND follower_id == #{current_user.id}")
    followed.each do |f|
      Follow.delete(f.id)
    end
    redirect_to people_path
  end
end