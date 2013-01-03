class ClasesController < ApplicationController

  def index
    @clases = Clase.find(:all, :order => 'descricao')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clases }
    end
  end

  # GET /clases/1
  # GET /clases/1.xml
  def show
    @clase = Clase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clase }
    end
  end

  # GET /clases/new
  # GET /clases/new.xml
  def new
    @clase = Clase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clase }
    end
  end

  # GET /clases/1/edit
  def edit
    @clase = Clase.find(params[:id])
  end

  # POST /clases
  # POST /clases.xml
  def create
    @clase = Clase.new(params[:clase])
    @clase.usuario_created = current_user.usuario_nome
    @clase.unidade_created = current_unidade.unidade_nome


    respond_to do |format|
      if @clase.save
        flash[:notice] = 'Grabado con Sucesso'
        format.html { redirect_to(clases_url) }
        format.xml  { render :xml => @clase, :status => :created, :location => @clase }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clases/1
  # PUT /clases/1.xml
  def update
    @clase = Clase.find(params[:id])
    @clase.usuario_updated = current_user.usuario_nome
    @clase.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @clase.update_attributes(params[:clase])
        flash[:notice] = 'Actualizado con Sucesso'
        format.html { redirect_to(clases_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clase.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clases/1
  # DELETE /clases/1.xml
  def destroy
    @clase = Clase.find(params[:id])
    @clase.destroy

    respond_to do |format|
      format.html { redirect_to(clases_url) }
      format.xml  { head :ok }
    end
  end
end
