class ResourceInfosController < ApplicationController
  before_filter :authenticate_user!
  # GET /resource_infos
  # GET /resource_infos.json
  def index
    @resource_infos = ResourceInfo.order('created_at desc').by_score

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resource_infos }
    end
  end

  def mine
    @resource_infos = current_user.resource_infos.order('created_at desc').by_score

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

  def rate
    @resource_info = ResourceInfo.find(params[:id])
    rate = params[:rate]
    if @resource_info and rate
      ur = (UserRate.where("user_id=? and resource_info_id=?",current_user.id,@resource_info.id).first || @resource_info.user_rates.build(:user=>current_user))
      ur.rate = rate
      ur.save
      @resource_info.reload
    end
  end

  # POST /resource_infos
  # POST /resource_infos.json
  def create
    @resource_info = ResourceInfo.new(params[:resource_info])
    @resource_info.user = current_user

    respond_to do |format|
      if @resource_info.save
        current_user.resource_infos << @resource_info
        format.js
        format.html { redirect_to @resource_info, notice: 'Resource info was successfully created.' }
        format.json { render json: @resource_info, status: :created, location: @resource_info }
      else
        format.js { render 'edit'}
        format.html { render action: "new" }
        format.json { render json: @resource_info.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @resource_info = ResourceInfo.find(params[:id])
    current_user.resource_infos << @resource_info
    redirect_to mine_resource_infos_path
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
    @resource_info.regenerate(true)
    redirect_to resource_infos_path
  end
end
