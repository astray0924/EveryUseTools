class UsersController < ApplicationController
  def index
    @users = case
    when params[:sort]=='username'
      User.order("username").all
    when params[:sort]=='email'
      User.order("email").all
    when params[:sort]=='created_at'
      User.order("created_at DESC").all
    when params[:sort]=='use_cases_count'
      User.order("use_cases_count DESC").all
    when params[:sort]=='wows_count'
      User.order("wows_count DESC").all
    when params[:sort]=='metoos_count'
      User.order("metoos_count DESC").all
    when params[:sort]=='favorites_count'
      User.order("favorites_count DESC").all
    else
      User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
