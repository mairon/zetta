class SafraProdutosController < ApplicationController
  # GET /safra_produtos
  # GET /safra_produtos.json
  def index
    @safra_produtos = SafraProduto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @safra_produtos }
    end
  end

  # GET /safra_produtos/1
  # GET /safra_produtos/1.json
  def show
    @safra_produto = SafraProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_produto }
    end
  end

  def descontos
    @safra_produto = SafraProduto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @safra_produto }
    end
  end

  # GET /safra_produtos/new
  # GET /safra_produtos/new.json
  def new
    @safra_produto = SafraProduto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @safra_produto }
    end
  end

  # GET /safra_produtos/1/edit
  def edit
    @safra_produto = SafraProduto.find(params[:id])
  end

  # POST /safra_produtos
  # POST /safra_produtos.json
  def create
    @safra_produto = SafraProduto.new(params[:safra_produto])

    respond_to do |format|
      if @safra_produto.save
        format.html { redirect_to "/safras/#{@safra_produto.safra_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @safra_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /safra_produtos/1
  # PUT /safra_produtos/1.json
  def update
    @safra_produto = SafraProduto.find(params[:id])

    respond_to do |format|
      if @safra_produto.update_attributes(params[:safra_produto])
        format.html { redirect_to "/safras/#{@safra_produto.safra_id}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @safra_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /safra_produtos/1
  # DELETE /safra_produtos/1.json
  def destroy
    @safra_produto = SafraProduto.find(params[:id])
    @safra_produto.destroy

    respond_to do |format|
      format.html { redirect_to "/safras/#{@safra_produto.safra_id}"}
      format.json { head :no_content }
    end
  end
end
