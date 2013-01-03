class SafraUmidadesController < ApplicationController
  def index
    @safra_umidades = SafraUmidade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_umidades }
    end
  end

  # GET /safra_umidades/1
  # GET /safra_umidades/1.json
  def show
    @safra_umidade = SafraUmidade.find(params[:id])

    respond_to do |format|
      format.html { redirect_to safra_umidades_url }
      format.json { head :no_content }
    end
  end

  # GET /safra_umidades/new
  # GET /safra_umidades/new.json
  def new
    @safra_umidade = SafraUmidade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_umidade }
    end
  end

  # GET /safra_umidades/1/edit
  def edit
    @safra_umidade = SafraUmidade.find(params[:id])
  end

  # POST /safra_umidades
  # POST /safra_umidades.json
  def create
    @safra_umidade = SafraUmidade.new(params[:safra_umidade])

    respond_to do |format|
      if @safra_umidade.save
        format.html { redirect_to "/safra_produtos/#{@safra_umidade.safra_produto_id}/descontos"}
         format.json { render json: @safra_umidade, status: :created, location: @safra_umidade }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_umidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_umidades/1
  # PUT /safra_umidades/1.json
  def update
    @safra_umidade = SafraUmidade.find(params[:id])

    respond_to do |format|
      if @safra_umidade.update_attributes(params[:safra_umidade])
        format.html { redirect_to "/safra_produtos/#{@safra_umidade.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_umidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_umidades/1
  # DELETE /safra_umidades/1.json
  def destroy
    @safra_umidade = SafraUmidade.find(params[:id])
    @safra_umidade.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_umidade.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
