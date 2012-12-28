class AdelantosController < ApplicationController

  before_filter :authenticate
  
  def recibo          #
    @adelanto    = Adelanto.find(params[:id])
    render  :layout => false
  end

  def comprovante          #
    @adelanto    = Adelanto.find(params[:id])
    render  :layout => false
  end

  def index               #
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def busca               #
    @adelantos = Adelanto.filtro_busca(params)
    render :layout => false
  end

  def show                #
    @adelanto = Adelanto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @adelanto }
    end
  end

  def new                 #
    @adelanto = Adelanto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @adelanto }
    end
  end

  def edit                #
    @adelanto = Adelanto.find(params[:id])
  end

  def create              #
    @adelanto = Adelanto.new(params[:adelanto])

    respond_to do |format|
      if @adelanto.save
        format.html { redirect_to(@adelanto, :notice => 'Grabado Con Sucesso') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update              #
    @adelanto = Adelanto.find(params[:id])

    respond_to do |format|
      if @adelanto.update_attributes(params[:adelanto])
        format.html { redirect_to(@adelanto, :notice => 'Grabado Con Sucesso') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy             #
    @adelanto = Adelanto.find(params[:id])
    @adelanto.destroy

    respond_to do |format|
      format.html { redirect_to(adelantos_url) }
    end
  end
end
