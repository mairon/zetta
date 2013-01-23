class VariavelsController < ApplicationController
  # GET /variavels
  # GET /variavels.json
  def index
    @variavels = Variavel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @variavels }
    end
  end

  # GET /variavels/1
  # GET /variavels/1.json
  def show
    @variavel = Variavel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @variavel }
    end
  end

  # GET /variavels/new
  # GET /variavels/new.json
  def new
    @variavel = Variavel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @variavel }
    end
  end

  # GET /variavels/1/edit
  def edit
    @variavel = Variavel.find(params[:id])
  end

  # POST /variavels
  # POST /variavels.json
  def create
    @variavel = Variavel.new(params[:variavel])

    respond_to do |format|
      if @variavel.save
      format.html { redirect_to variavels_url }
      format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @variavel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /variavels/1
  # PUT /variavels/1.json
  def update
    @variavel = Variavel.find(params[:id])

    respond_to do |format|
      if @variavel.update_attributes(params[:variavel])
      format.html { redirect_to variavels_url }
      format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @variavel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variavels/1
  # DELETE /variavels/1.json
  def destroy
    @variavel = Variavel.find(params[:id])
    @variavel.destroy

    respond_to do |format|
      format.html { redirect_to variavels_url }
      format.json { head :no_content }
    end
  end
end
