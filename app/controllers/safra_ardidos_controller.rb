class SafraArdidosController < ApplicationController
  # GET /safra_ardidos
  # GET /safra_ardidos.json
  def index
    @safra_ardidos = SafraArdido.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_ardidos }
    end
  end

  # GET /safra_ardidos/1
  # GET /safra_ardidos/1.json
  def show
    @safra_ardido = SafraArdido.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_ardido }
    end
  end

  # GET /safra_ardidos/new
  # GET /safra_ardidos/new.json
  def new
    @safra_ardido = SafraArdido.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_ardido }
    end
  end

  # GET /safra_ardidos/1/edit
  def edit
    @safra_ardido = SafraArdido.find(params[:id])
  end

  # POST /safra_ardidos
  # POST /safra_ardidos.json
  def create
    @safra_ardido = SafraArdido.new(params[:safra_ardido])

    respond_to do |format|
      if @safra_ardido.save
        format.html { redirect_to "/safra_produtos/#{@safra_ardido.safra_produto_id}/descontos"}
        format.json { render json: @safra_ardido, status: :created, location: @safra_ardido }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_ardido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_ardidos/1
  # PUT /safra_ardidos/1.json
  def update
    @safra_ardido = SafraArdido.find(params[:id])

    respond_to do |format|
      if @safra_ardido.update_attributes(params[:safra_ardido])
        format.html { redirect_to "/safra_produtos/#{@safra_ardido.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_ardido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_ardidos/1
  # DELETE /safra_ardidos/1.json
  def destroy
    @safra_ardido = SafraArdido.find(params[:id])
    @safra_ardido.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_ardido.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
