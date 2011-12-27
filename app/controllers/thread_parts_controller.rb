class ThreadPartsController < ApplicationController
  # GET /thread_parts
  # GET /thread_parts.json
  def index
    @thread_parts = ThreadPart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @thread_parts }
    end
  end

  # GET /thread_parts/1
  # GET /thread_parts/1.json
  def show
    @thread_part = ThreadPart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @thread_part }
    end
  end

  # GET /thread_parts/new
  # GET /thread_parts/new.json
  def new
    @thread_part = ThreadPart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @thread_part }
    end
  end

  # GET /thread_parts/1/edit
  def edit
    @thread_part = ThreadPart.find(params[:id])
  end

  # POST /thread_parts
  # POST /thread_parts.json
  def create
    @thread_part = ThreadPart.new(params[:thread_part])

    respond_to do |format|
      if @thread_part.save
        format.html { redirect_to @thread_part, notice: 'Thread part was successfully created.' }
        format.json { render json: @thread_part, status: :created, location: @thread_part }
      else
        format.html { render action: "new" }
        format.json { render json: @thread_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /thread_parts/1
  # PUT /thread_parts/1.json
  def update
    @thread_part = ThreadPart.find(params[:id])

    respond_to do |format|
      if @thread_part.update_attributes(params[:thread_part])
        format.html { redirect_to @thread_part, notice: 'Thread part was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @thread_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /thread_parts/1
  # DELETE /thread_parts/1.json
  def destroy
    @thread_part = ThreadPart.find(params[:id])
    @thread_part.destroy

    respond_to do |format|
      format.html { redirect_to thread_parts_url }
      format.json { head :ok }
    end
  end
end
