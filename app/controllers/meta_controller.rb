class MetaController < ApplicationController
  # GET /meta
  # GET /meta.json
  def index
    @meta = Metum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meta }
    end
  end

  # GET /meta/1
  # GET /meta/1.json
  def show
    @metum = Metum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @metum }
    end
  end

  # GET /meta/new
  # GET /meta/new.json
  def new
    @metum = Metum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @metum }
    end
  end

  # GET /meta/1/edit
  def edit
    @metum = Metum.find(params[:id])
  end

  # POST /meta
  # POST /meta.json
  def create
    @metum = Metum.new(params[:metum])

    respond_to do |format|
      if @metum.save
        format.html { redirect_to meta_url }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meta/1
  # PUT /meta/1.json
  def update
    @metum = Metum.find(params[:id])

    respond_to do |format|
      if @metum.update_attributes(params[:metum])
      format.html { redirect_to meta_url }
      format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meta/1
  # DELETE /meta/1.json
  def destroy
    @metum = Metum.find(params[:id])
    @metum.destroy

    respond_to do |format|
      format.html { redirect_to meta_url }
      format.json { head :no_content }
    end
  end
end
