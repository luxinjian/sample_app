class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy

  def index
  end

  def create
    micropost = current_user.microposts.build(params[:micropost])
    if micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @micropost = current_user.microposts.build
      render 'static_pages/home'
    end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = "Micropost destroyed."
    redirect_back_or root_path
  end

  private

  def correct_user
    user = Micropost.find(params[:id]).user
    redirect_to(root_path) unless current_user?(user)
  end
end
