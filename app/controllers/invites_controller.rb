class InvitesController < ApplicationController
  before_filter :require_user
  def new
      @invite = Invite.new
  end

  def create
    @invite = Invite.new(params[:invite].merge!(inviter_id: current_user.id))

    if @invite.save
      AppMailer.delay.send_invite(@invite.id)
      flash[:success] = "You have invited #{@invite.invited_name} to join MyFlix!"
      redirect_to new_invite_path
    else
      flash[:error] = "Make sure you have filled out the form correctly."
      render :new
    end
  end
end