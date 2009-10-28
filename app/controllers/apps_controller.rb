class AppsController < ApplicationController
  # GET /apps
  # GET /apps.xml
  def index
    @apps = App.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @apps }
    end
  end

  def find
    if params['owner_id'] and params['name']
      App.basic_find(params['owner_id'], params['name'])
    else
      App.find_by_id(params[:id])
    end
  end

  # GET /apps/1
  # GET /apps/1.xml
  def show
    @app = find

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.xml
  def new
    @app = App.new

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
  end

  def name
    @app = find
  end

  # POST /apps
  # POST /apps.xml
  def create
    if signed_in?
      params[:app][:owner_id] = current_user.id
    end
    @app = App.new(params[:app])
    respond_to do |format|
      if @app.save
        session[:orphan_app_id] = @app.id
        @app.save_file('app.rb', params[:app][:code])
        @app.save_sinatra_rackup
        @app.autosave_commit("initial autosave")
        @app.do_commit("initial commit")
        @app.deploy
        
        format.html do
          if signed_in?
            redirect_to app_path(@app, "name")
          else 
            redirect_to join_path
          end
        end
        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.xml
  def update
    @app = App.find(params[:id])
    require_owner(@app, current_user)

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to app_path(@app) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.xml
  def destroy
    @app = App.find(params[:id])
    require_owner(@app, current_user)

    @app.destroy

    respond_to do |format|
      format.html { redirect_to(apps_url) }
      format.xml  { head :ok }
    end
  end

  def fork
    @app = find
    @fork = @app.fork(current_user)

    respond_to do |format|
      format.html { redirect_to app_path(@fork) }
      format.xml  { head :ok }
    end
  end

  def deploy
    @app = find
    @app.deploy

    respond_to do |format|
      format.html { redirect_to app_path(@app) }
      format.xml  { head :ok }
    end
  end
end
