class ControlePulvMaqsController < ApplicationController
  # GET /controle_pulv_maqs
  # GET /controle_pulv_maqs.json
  def index
    @controle_pulv_maqs = ControlePulvMaq.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controle_pulv_maqs }
    end
  end

  # GET /controle_pulv_maqs/1
  # GET /controle_pulv_maqs/1.json
  def show
    @controle_pulv_maq = ControlePulvMaq.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @controle_pulv_maq }
    end
  end

  # GET /controle_pulv_maqs/new
  # GET /controle_pulv_maqs/new.json
  def new
    @controle_pulv_maq = ControlePulvMaq.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @controle_pulv_maq }
    end
  end

  # GET /controle_pulv_maqs/1/edit
  def edit
    @controle_pulv_maq = ControlePulvMaq.find(params[:id])
  end

  # POST /controle_pulv_maqs
  # POST /controle_pulv_maqs.json
  def create
    @controle_pulv_maq = ControlePulvMaq.new(params[:controle_pulv_maq])

    respond_to do |format|
      if @controle_pulv_maq.save
        format.html { redirect_to "/controle_pulvs/#{@controle_pulv_maq.controle_pulv_id}"}
        format.json { render json: @controle_pulv_maq, status: :created, location: @controle_pulv_maq }
      else
        format.html { render action: "new" }
        format.json { render json: @controle_pulv_maq.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controle_pulv_maqs/1
  # PUT /controle_pulv_maqs/1.json
  def update
    @controle_pulv_maq = ControlePulvMaq.find(params[:id])

    respond_to do |format|
      if @controle_pulv_maq.update_attributes(params[:controle_pulv_maq])
        format.html { redirect_to "/controle_pulvs/#{@controle_pulv_maq.controle_pulv_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @controle_pulv_maq.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controle_pulv_maqs/1
  # DELETE /controle_pulv_maqs/1.json
  def destroy
    @controle_pulv_maq = ControlePulvMaq.find(params[:id])
    @controle_pulv_maq.destroy

    respond_to do |format|
      format.html { redirect_to "/controle_pulvs/#{@controle_pulv_maq.controle_pulv_id}"}
      format.json { head :no_content }
    end
  end
end
