class SafraVerdososController < ApplicationController
  # GET /safra_verdosos
  # GET /safra_verdosos.json
  def index
    @safra_verdosos = SafraVerdoso.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_verdosos }
    end
  end

  # GET /safra_verdosos/1
  # GET /safra_verdosos/1.json
  def show
    @safra_verdoso = SafraVerdoso.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_verdoso }
    end
  end

  # GET /safra_verdosos/new
  # GET /safra_verdosos/new.json
  def new
    @safra_verdoso = SafraVerdoso.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_verdoso }
    end
  end

  # GET /safra_verdosos/1/edit
  def edit
    @safra_verdoso = SafraVerdoso.find(params[:id])
  end

  # POST /safra_verdosos
  # POST /safra_verdosos.json
  def create
    @safra_verdoso = SafraVerdoso.new(params[:safra_verdoso])

    respond_to do |format|
      if @safra_verdoso.save
        format.html { redirect_to "/safra_produtos/#{@safra_verdoso.safra_produto_id}/descontos"}
        format.json { render json: @safra_verdoso, status: :created, location: @safra_verdoso }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_verdoso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_verdosos/1
  # PUT /safra_verdosos/1.json
  def update
    @safra_verdoso = SafraVerdoso.find(params[:id])

    respond_to do |format|
      if @safra_verdoso.update_attributes(params[:safra_verdoso])
        format.html { redirect_to "/safra_produtos/#{@safra_verdoso.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_verdoso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_verdosos/1
  # DELETE /safra_verdosos/1.json
  def destroy
    @safra_verdoso = SafraVerdoso.find(params[:id])
    @safra_verdoso.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_verdoso.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
