class SafraBrotadosController < ApplicationController
  # GET /safra_brotados
  # GET /safra_brotados.json
  def index
    @safra_brotados = SafraBrotado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_brotados }
    end
  end

  # GET /safra_brotados/1
  # GET /safra_brotados/1.json
  def show
    @safra_brotado = SafraBrotado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_brotado }
    end
  end

  # GET /safra_brotados/new
  # GET /safra_brotados/new.json
  def new
    @safra_brotado = SafraBrotado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_brotado }
    end
  end

  # GET /safra_brotados/1/edit
  def edit
    @safra_brotado = SafraBrotado.find(params[:id])
  end

  # POST /safra_brotados
  # POST /safra_brotados.json
  def create
    @safra_brotado = SafraBrotado.new(params[:safra_brotado])

    respond_to do |format|
      if @safra_brotado.save
        format.html { redirect_to "/safra_produtos/#{@safra_brotado.safra_produto_id}/descontos"}
        format.json { render json: @safra_brotado, status: :created, location: @safra_brotado }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_brotado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_brotados/1
  # PUT /safra_brotados/1.json
  def update
    @safra_brotado = SafraBrotado.find(params[:id])

    respond_to do |format|
      if @safra_brotado.update_attributes(params[:safra_brotado])
        format.html { redirect_to "/safra_produtos/#{@safra_brotado.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_brotado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_brotados/1
  # DELETE /safra_brotados/1.json
  def destroy
    @safra_brotado = SafraBrotado.find(params[:id])
    @safra_brotado.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_brotado.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
