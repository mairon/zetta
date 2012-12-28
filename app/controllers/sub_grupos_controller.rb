class SubGruposController < ApplicationController
  def index
    @sub_grupos = SubGrupo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sub_grupos }
    end
  end

  def show
    @sub_grupo = SubGrupo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sub_grupo }
    end
  end

  def new
    @sub_grupo = SubGrupo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sub_grupo }
    end
  end

  def edit
    @sub_grupo = SubGrupo.find(params[:id])
  end

  def create
    @sub_grupo = SubGrupo.new(params[:sub_grupo])

    respond_to do |format|
      if @sub_grupo.save
        format.html { redirect_to(sub_grupos_url, :notice => 'Grabado con Sucesso') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @sub_grupo = SubGrupo.find(params[:id])

    respond_to do |format|
      if @sub_grupo.update_attributes(params[:sub_grupo])
        format.html { redirect_to(sub_grupos_url, :notice => 'Actualizado con Sucesso') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @sub_grupo = SubGrupo.find(params[:id])
    @sub_grupo.destroy

    respond_to do |format|
      format.html { redirect_to(sub_grupos_url) }
      format.xml  { head :ok }
    end
  end
end
