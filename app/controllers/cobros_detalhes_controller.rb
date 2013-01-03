class CobrosDetalhesController < ApplicationController
before_filter :authenticate

  def index
    @cobros_detalhes = CobrosDetalhe.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cobros_detalhes }
    end
  end

  # GET /cobros_detalhes/1
  # GET /cobros_detalhes/1.xml
  def show
    @cobros_detalhe = CobrosDetalhe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cobros_detalhe }
    end
  end

  # GET /cobros_detalhes/new
  # GET /cobros_detalhes/new.xml
  def new
    @cobros_detalhe = CobrosDetalhe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cobros_detalhe }
    end
  end

  # GET /cobros_detalhes/1/edit
  def edit
    @cobros_detalhe = CobrosDetalhe.find(params[:id])
  end

  # POST /cobros_detalhes
  # POST /cobros_detalhes.xml
  def create
    @cobros_detalhe = CobrosDetalhe.new(params[:cobros_detalhe])
    @cobros_detalhe.usuario_created = current_user.id
    @cobros_detalhe.unidade_created = current_unidade.id


    respond_to do |format|
      if @cobros_detalhe.save
        flash[:notice] = 'Grabado con Sucesso'
        format.html { redirect_to "/cobros/#{@cobros_detalhe.cobro_id}" }
        format.xml  { render :xml => @cobros_detalhe, :status => :created, :location => @cobros_detalhe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cobros_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cobros_detalhes/1
  # PUT /cobros_detalhes/1.xml
  def update
    @cobros_detalhe = CobrosDetalhe.find(params[:id])
    @cobros_detalhe.usuario_updated = current_user.id
    @cobros_detalhe.unidade_updated = current_unidade.id

    respond_to do |format|
      if @cobros_detalhe.update_attributes(params[:cobros_detalhe])
        flash[:notice] = 'CobrosDetalhe was successfully updated.'
        format.html { redirect_to "/cobros/#{@cobros_detalhe.cobro_id}" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cobros_detalhe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cobros_detalhes/1
  # DELETE /cobros_detalhes/1.xml
  def destroy
    @cobros_detalhe = CobrosDetalhe.find(params[:id])
    @cobros_detalhe.destroy

    respond_to do |format|
      format.html { redirect_to "/cobros/#{@cobros_detalhe.cobro_id}" }
      format.xml  { head :ok }
    end
  end
end
