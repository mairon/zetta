class TransferenciaDepositosController < ApplicationController
  before_filter :authenticate


  def index
    @transferencia_depositos = TransferenciaDeposito.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transferencia_depositos }
    end
  end

  def show
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transferencia_deposito }
    end
  end

  def comprovante
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
 	@detalhe_produtos = TransferenciaDepositoDetalhe.all(:conditions => ["transferencia_deposito_id = ?", @transferencia_deposito.id])
     render :layout => false
  end


  def new
    @transferencia_deposito = TransferenciaDeposito.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transferencia_deposito }
    end
  end

  def edit
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
  end

  def create
    @transferencia_deposito = TransferenciaDeposito.new(params[:transferencia_deposito])
    @transferencia_deposito.usuario_created = current_user.id
    @transferencia_deposito.unidade_created = current_unidade.id

    respond_to do |format|
      if @transferencia_deposito.save
        format.html { redirect_to(@transferencia_deposito, :notice => 'Grabado con Sucesso.') }
        format.xml  { render :xml => @transferencia_deposito, :status => :created, :location => @transferencia_deposito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transferencia_deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
    @transferencia_deposito.usuario_updated = current_user.id
    @transferencia_deposito.unidade_updated = current_unidade.id

    respond_to do |format|
      if @transferencia_deposito.update_attributes(params[:transferencia_deposito])
        format.html { redirect_to(@transferencia_deposito, :notice => 'Actualizado con Sucesso.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transferencia_deposito.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @transferencia_deposito = TransferenciaDeposito.find(params[:id])
    @transferencia_deposito.destroy

    respond_to do |format|
      format.html { redirect_to(transferencia_depositos_url) }
      format.xml  { head :ok }
    end
  end
end
