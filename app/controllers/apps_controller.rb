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

  # GET /apps/1
  # GET /apps/1.xml
  def show
    @app = App.find(params[:id])

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

  # POST /apps
  # POST /apps.xml
  def create
    if signed_in?
      params[:app][:owner_id] = current_user.id
    end
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        session[:orphan_apps] ||= []
        session[:orphan_apps] << @app.id
        @app.save_file('app.rb', params[:app][:code])
        @app.save_sinatra_rackup
        @app.autosave_commit("initial autosave")
        @app.do_commit("initial commit")
        @app.deploy
        
        format.html { redirect_to(@app) }
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
        format.html { redirect_to(@app) }
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
    @app = App.find(params[:id])
    @fork = @app.fork(current_user)

    respond_to do |format|
      format.html { redirect_to(@fork) }
      format.xml  { head :ok }
    end
  end

  def deploy
    @app = App.find(params[:id])
    @app.deploy

    respond_to do |format|
      format.html { redirect_to(@app) }
      format.xml  { head :ok }
    end
  end
end
