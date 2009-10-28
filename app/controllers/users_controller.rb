class UsersController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def account_url
    '/join'
  end

  def my_method
    params[:id]
  end

  def new
    @user = User.new
    @app = App.find_by_id(session[:orphan_app_id])
  end
  
  def create
    @user = User.new(params[:user])
    @app = App.find_by_id(session[:orphan_app_id])
    @app.name = params['app']['name']
    @app.should_validate_name = true
    @user.valid?
    if @app.valid? and @user.valid?
      @user.save
      @app.owner = @user
      @app.save
      redirect_to app_path(@app)
    else
      render :action => :new
    end
  end
  
  def show
    @user = User.find_by_login(params[:login]) or raise ActiveRecord::RecordNotFound
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
