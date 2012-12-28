class SafraImpurezasController < ApplicationController
  # GET /safra_impurezas
  # GET /safra_impurezas.json
  def index
    @safra_impurezas = SafraImpureza.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_impurezas }
    end
  end

  # GET /safra_impurezas/1
  # GET /safra_impurezas/1.json
  def show
    @safra_impureza = SafraImpureza.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_impureza }
    end
  end

  # GET /safra_impurezas/new
  # GET /safra_impurezas/new.json
  def new
    @safra_impureza = SafraImpureza.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_impureza }
    end
  end

  # GET /safra_impurezas/1/edit
  def edit
    @safra_impureza = SafraImpureza.find(params[:id])
  end

  # POST /safra_impurezas
  # POST /safra_impurezas.json
  def create
    @safra_impureza = SafraImpureza.new(params[:safra_impureza])

    respond_to do |format|
      if @safra_impureza.save
        format.html { redirect_to "/safra_produtos/#{@safra_impureza.safra_produto_id}/descontos"}
        format.json { render json: @safra_impureza, status: :created, location: @safra_impureza }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_impureza.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_impurezas/1
  # PUT /safra_impurezas/1.json
  def update
    @safra_impureza = SafraImpureza.find(params[:id])

    respond_to do |format|
      if @safra_impureza.update_attributes(params[:safra_impureza])
        format.html { redirect_to "/safra_produtos/#{@safra_impureza.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_impureza.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_impurezas/1
  # DELETE /safra_impurezas/1.json
  def destroy
    @safra_impureza = SafraImpureza.find(params[:id])
    @safra_impureza.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_impureza.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
