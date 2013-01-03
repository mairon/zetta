class EntradaSaidaFuncDetalhesController < ApplicationController
  # GET /entrada_saida_func_detalhes
  # GET /entrada_saida_func_detalhes.xml
  def index
    @entrada_saida_func_detalhes = EntradaSaidaFuncDetalhe.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entrada_saida_func_detalhes }
    end
  end

  # GET /entrada_saida_func_detalhes/1
  # GET /entrada_saida_func_detalhes/1.xml
  def show
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entrada_saida_func_detalhe }
    end
  end

  # GET /entrada_saida_func_detalhes/new
  # GET /entrada_saida_func_detalhes/new.xml
  def new
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entrada_saida_func_detalhe }
    end
  end

  # GET /entrada_saida_func_detalhes/1/edit
  def edit
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.find(params[:id])
  end

  # POST /entrada_saida_func_detalhes
  # POST /entrada_saida_func_detalhes.xml
  def create
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.new(params[:entrada_saida_func_detalhe])

    respond_to do |format|
      if @entrada_saida_func_detalhe.save
        format.html { redirect_to "/entrada_saida_funcs/#{@entrada_saida_func_detalhe.entrada_saida_func_id}" }
        format.xml  { render :xml => @entrada_saida_func_detalhe, :status => :created, :location => @entrada_saida_func_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entrada_saida_func_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entrada_saida_func_detalhes/1
  # PUT /entrada_saida_func_detalhes/1.xml
  def update
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.find(params[:id])

    respond_to do |format|
      if @entrada_saida_func_detalhe.update_attributes(params[:entrada_saida_func_detalhe])
        format.html { redirect_to "/entrada_saida_funcs/#{@entrada_saida_func_detalhe.entrada_saida_func_id}" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entrada_saida_func_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entrada_saida_func_detalhes/1
  # DELETE /entrada_saida_func_detalhes/1.xml
  def destroy
    @entrada_saida_func_detalhe = EntradaSaidaFuncDetalhe.find(params[:id])
    @entrada_saida_func_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to "/entrada_saida_funcs/#{@entrada_saida_func_detalhe.entrada_saida_func_id}" }
      format.xml  { head :ok }
    end
  end
end
