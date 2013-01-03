class UnidadeMetricasController < ApplicationController
  # GET /unidade_metricas
  # GET /unidade_metricas.json
  def index
    @unidade_metricas = UnidadeMetrica.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @unidade_metricas }
    end
  end

  # GET /unidade_metricas/1
  # GET /unidade_metricas/1.json
  def show
    @unidade_metrica = UnidadeMetrica.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unidade_metrica }
    end
  end

  # GET /unidade_metricas/new
  # GET /unidade_metricas/new.json
  def new
    @unidade_metrica = UnidadeMetrica.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unidade_metrica }
    end
  end

  # GET /unidade_metricas/1/edit
  def edit
    @unidade_metrica = UnidadeMetrica.find(params[:id])
  end

  # POST /unidade_metricas
  # POST /unidade_metricas.json
  def create
    @unidade_metrica = UnidadeMetrica.new(params[:unidade_metrica])

    respond_to do |format|
      if @unidade_metrica.save
        format.html { redirect_to unidade_metricas_url }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @unidade_metrica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /unidade_metricas/1
  # PUT /unidade_metricas/1.json
  def update
    @unidade_metrica = UnidadeMetrica.find(params[:id])

    respond_to do |format|
      if @unidade_metrica.update_attributes(params[:unidade_metrica])
        format.html { redirect_to unidade_metricas_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unidade_metrica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unidade_metricas/1
  # DELETE /unidade_metricas/1.json
  def destroy
    @unidade_metrica = UnidadeMetrica.find(params[:id])
    @unidade_metrica.destroy

    respond_to do |format|
      format.html { redirect_to unidade_metricas_url }
      format.json { head :no_content }
    end
  end
end
