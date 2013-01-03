class ContasController < ApplicationController
before_filter :authenticate

 def index
    @contas = Conta.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contas }
    end
  end

  def show
    @conta = Conta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conta }
    end
  end

  def new
    @conta = Conta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conta }
    end
  end

  def edit
    @conta = Conta.find(params[:id])
  end

  def create
    @conta = Conta.new(params[:conta])
    @conta.usuario_created = current_user.usuario_nome
    @conta.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @conta.save
        flash[:notice] = 'Grabado con Sucesso'
        format.html { redirect_to(contas_url) }
        format.xml  { render :xml => @conta, :status => :created, :location => @conta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @conta = Conta.find(params[:id])
    @conta.usuario_updated = current_user.usuario_nome
    @conta.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @conta.update_attributes(params[:conta])
        flash[:notice] = 'Actualizado con Sucesso'
        format.html { redirect_to(contas_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @conta = Conta.find(params[:id])
    @conta.destroy

    respond_to do |format|
      format.html { redirect_to(contas_url) }
      format.xml  { head :ok }
    end
  end
end

