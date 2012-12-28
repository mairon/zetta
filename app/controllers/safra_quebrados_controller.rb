class SafraQuebradosController < ApplicationController
  # GET /safra_quebrados
  # GET /safra_quebrados.json
  def index
    @safra_quebrados = SafraQuebrado.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_quebrados }
    end
  end

  # GET /safra_quebrados/1
  # GET /safra_quebrados/1.json
  def show
    @safra_quebrado = SafraQuebrado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_quebrado }
    end
  end

  # GET /safra_quebrados/new
  # GET /safra_quebrados/new.json
  def new
    @safra_quebrado = SafraQuebrado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_quebrado }
    end
  end

  # GET /safra_quebrados/1/edit
  def edit
    @safra_quebrado = SafraQuebrado.find(params[:id])
  end

  # POST /safra_quebrados
  # POST /safra_quebrados.json
  def create
    @safra_quebrado = SafraQuebrado.new(params[:safra_quebrado])

    respond_to do |format|
      if @safra_quebrado.save
        format.html { redirect_to "/safra_produtos/#{@safra_quebrado.safra_produto_id}/descontos"}
        format.json { render json: @safra_quebrado, status: :created, location: @safra_quebrado }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_quebrado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_quebrados/1
  # PUT /safra_quebrados/1.json
  def update
    @safra_quebrado = SafraQuebrado.find(params[:id])

    respond_to do |format|
      if @safra_quebrado.update_attributes(params[:safra_quebrado])
        format.html { redirect_to "/safra_produtos/#{@safra_quebrado.safra_produto_id}/descontos"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_quebrado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_quebrados/1
  # DELETE /safra_quebrados/1.json
  def destroy
    @safra_quebrado = SafraQuebrado.find(params[:id])
    @safra_quebrado.destroy

    respond_to do |format|
      format.html { redirect_to "/safra_produtos/#{@safra_quebrado.safra_produto_id}/descontos"}
      format.json { head :no_content }
    end
  end
end
