class ControlePulvsController < ApplicationController
  # GET /controle_pulvs
  # GET /controle_pulvs.json
  def index
    @controle_pulvs = ControlePulv.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controle_pulvs }
    end
  end

  # GET /controle_pulvs/1
  # GET /controle_pulvs/1.json
  def show
    @controle_pulv = ControlePulv.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @controle_pulv }
    end
  end

  # GET /controle_pulvs/new
  # GET /controle_pulvs/new.json
  def new
    @controle_pulv = ControlePulv.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @controle_pulv }
    end
  end

  # GET /controle_pulvs/1/edit
  def edit
    @controle_pulv = ControlePulv.find(params[:id])
  end

  # POST /controle_pulvs
  # POST /controle_pulvs.json
  def create
    @controle_pulv = ControlePulv.new(params[:controle_pulv])

    respond_to do |format|
      if @controle_pulv.save
        format.html { redirect_to @controle_pulv, notice: 'Controle pulv was successfully created.' }
        format.json { render json: @controle_pulv, status: :created, location: @controle_pulv }
      else
        format.html { render action: "new" }
        format.json { render json: @controle_pulv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controle_pulvs/1
  # PUT /controle_pulvs/1.json
  def update
    @controle_pulv = ControlePulv.find(params[:id])

    respond_to do |format|
      if @controle_pulv.update_attributes(params[:controle_pulv])
        format.html { redirect_to @controle_pulv, notice: 'Controle pulv was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @controle_pulv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controle_pulvs/1
  # DELETE /controle_pulvs/1.json
  def destroy
    @controle_pulv = ControlePulv.find(params[:id])
    @controle_pulv.destroy

    respond_to do |format|
      format.html { redirect_to controle_pulvs_url }
      format.json { head :no_content }
    end
  end
end
