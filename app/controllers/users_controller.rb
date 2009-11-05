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
    if params['app']
      @app = App.find_by_id(session[:orphan_app_id])
      @app.name = params['app']['name']
      @app.should_validate_name = true
    else
      @app = App.new
    end
    @user.valid?
    if (!@app or @app.valid?) and @user.valid?
      @user.save
      if params['app']
        @app.owner = @user
        @app.save
        @user.add_story("created a new app, #{app_link(@app)}")
        redirect_to app_path(@app)
      else
        redirect_to new_app_path
      end
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
