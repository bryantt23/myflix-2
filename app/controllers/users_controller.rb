class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new()

    if @user.save
      flash[:notice] = "Your account has been created."
      redirect_to videos_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end
end