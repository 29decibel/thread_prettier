class ResourceInfosController < ApplicationController
  # GET /resource_infos
  # GET /resource_infos.json
  def index
    @resource_infos = ResourceInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resource_infos }
    end
  end

  # GET /resource_infos/1
  # GET /resource_infos/1.json
  def show
    @resource_info = ResourceInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource_info }
    end
  end

  # GET /resource_infos/new
  # GET /resource_infos/new.json
  def new
    @resource_info = ResourceInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource_info }
    end
  end

  # GET /resource_infos/1/edit
  def edit
    @resource_info = ResourceInfo.find(params[:id])
  end

  # POST /resource_infos
  # POST /resource_infos.json
  def create
    @resource_info = ResourceInfo.new(params[:resource_info])

    respond_to do |format|
      if @resource_info.save
        format.html { redirect_to @resource_info, notice: 'Resource info was successfully created.' }
        format.json { render json: @resource_info, status: :created, location: @resource_info }
      else
        format.html { render action: "new" }
        format.json { render json: @resource_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resource_infos/1
  # PUT /resource_infos/1.json
  def update
    @resource_info = ResourceInfo.find(params[:id])

    respond_to do |format|
      if @resource_info.update_attributes(params[:resource_info])
        format.html { redirect_to @resource_info, notice: 'Resource info was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_infos/1
  # DELETE /resource_infos/1.json
  def destroy
    @resource_info = ResourceInfo.find(params[:id])
    @resource_info.destroy

    respond_to do |format|
      format.html { redirect_to resource_infos_url }
      format.json { head :ok }
    end
  end

  def regenerate
    @resource_info = ResourceInfo.find(params[:id])
    @resource_info.work
    redirect_to resource_infos_path
  end
end
