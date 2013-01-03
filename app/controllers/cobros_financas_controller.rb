class CobrosFinancasController < ApplicationController
  def index               #
    @cobros_financas = CobrosFinanca.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cobros_financas }
    end
  end

  def show                #
    @cobros_financa = CobrosFinanca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cobros_financa }
    end
  end

  def new                 #
    @cobros_financa = CobrosFinanca.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cobros_financa }
    end
  end

  def edit                #
    @cobros_financa = CobrosFinanca.find(params[:id])
  end

  def create              #
    @cobros_financa = CobrosFinanca.new(params[:cobros_financa])
    @cobros_financa.usuario_created = current_user.id
    @cobros_financa.unidade_created = current_unidade.id

    respond_to do |format|
      if @cobros_financa.save
        format.html { redirect_to "/cobros/#{@cobros_financa.cobro_id}/cobro_final" }
        format.xml  { render :xml => @cobros_financa, :status => :created, :location => @cobros_financa }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cobros_financa.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update              #
    @cobros_financa = CobrosFinanca.find(params[:id])

    respond_to do |format|
      if @cobros_financa.update_attributes(params[:cobros_financa])
        format.html { redirect_to "/cobros/#{@cobros_financa.cobro_id}/cobro_final" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cobros_financa.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy             #
    @cobros_financa = CobrosFinanca.find(params[:id])
    @cobros_financa.destroy

    respond_to do |format|
      format.html { redirect_to "/cobros/#{@cobros_financa.cobro_id}/cobro_final" }
      format.xml  { head :ok }
    end
  end
end
