class SafraAveriadosController < ApplicationController
  # GET /safra_averiados
  # GET /safra_averiados.json
  def index
    @safra_averiados = SafraAveriado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_averiados }
    end
  end

  # GET /safra_averiados/1
  # GET /safra_averiados/1.json
  def show
    @safra_averiado = SafraAveriado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_averiado }
    end
  end

  # GET /safra_averiados/new
  # GET /safra_averiados/new.json
  def new
    @safra_averiado = SafraAveriado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_averiado }
    end
  end

  # GET /safra_averiados/1/edit
  def edit
    @safra_averiado = SafraAveriado.find(params[:id])
  end

  # POST /safra_averiados
  # POST /safra_averiados.json
  def create
    @safra_averiado = SafraAveriado.new(params[:safra_averiado])

    respond_to do |format|
      if @safra_averiado.save
        format.html { redirect_to @safra_averiado, notice: 'Safra averiado was successfully created.' }
        format.json { render json: @safra_averiado, status: :created, location: @safra_averiado }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_averiado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_averiados/1
  # PUT /safra_averiados/1.json
  def update
    @safra_averiado = SafraAveriado.find(params[:id])

    respond_to do |format|
      if @safra_averiado.update_attributes(params[:safra_averiado])
        format.html { redirect_to @safra_averiado, notice: 'Safra averiado was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_averiado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_averiados/1
  # DELETE /safra_averiados/1.json
  def destroy
    @safra_averiado = SafraAveriado.find(params[:id])
    @safra_averiado.destroy

    respond_to do |format|
      format.html { redirect_to safra_averiados_url }
      format.json { head :no_content }
    end
  end
end
