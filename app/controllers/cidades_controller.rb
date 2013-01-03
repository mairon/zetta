class CidadesController < ApplicationController
  before_filter :authenticate

  def index
    @cidades = Cidade.find(:all, :order => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cidades }
    end
  end

  # GET /cidades/1
  # GET /cidades/1.xml
  def show
    @cidade = Cidade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cidade }
    end
  end

  # GET /cidades/new
  # GET /cidades/new.xml
  def new
    @cidade = Cidade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cidade }
    end
  end

  # GET /cidades/1/edit
  def edit
    @cidade = Cidade.find(params[:id])
  end

  def create
    @cidade = Cidade.new(params[:cidade])
    @cidade.usuario_created = current_user.usuario_nome
    @cidade.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @cidade.save
        flash[:notice] = 'Grabado con Sucesso.'
        format.html { redirect_to(cidades_url) }
        format.xml  { render :xml => @cidade, :status => :created, :location => @cidade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cidade.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @cidade = Cidade.find(params[:id])
    @cidade.usuario_updated = current_user.usuario_nome
    @cidade.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @cidade.update_attributes(params[:cidade])
        flash[:notice] = 'Actualizado con Sucesso.'
        format.html { redirect_to(cidades_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cidade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cidades/1
  # DELETE /cidades/1.xml
  def destroy
    @cidade = Cidade.find(params[:id])
    @cidade.destroy

    respond_to do |format|
      format.html { redirect_to(cidades_url) }
      format.xml  { head :ok }
    end
  end
end
