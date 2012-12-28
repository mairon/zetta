class MoedasController < ApplicationController
    before_filter :authenticate
def index
    @moedas = Moeda.find(:all,:order => "data desc") 
  end
    def show
        @moeda = Moeda.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @moeda }
        end
    end

    def new
        @moeda = Moeda.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @moeda }
        end
    end

    def edit
        @moeda = Moeda.find(params[:id])
    end

    def create
        @moeda = Moeda.new(params[:moeda])
        @moeda.usuario_created = current_user.usuario_nome
        @moeda.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @moeda.save
                flash[:notice] = 'Grabado con Sucesso'
                format.html { redirect_to(moedas_url) }
                format.xml  { render :xml => @moeda, :status => :created, :location => @moeda }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @moeda.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @moeda = Moeda.find(params[:id])
        @moeda.usuario_updated = current_user.usuario_nome
        @moeda.unidade_updated = current_unidade.unidade_nome


        respond_to do |format|
            if @moeda.update_attributes(params[:moeda])
                flash[:notice] = 'Actualizado con Sucesso'
                format.html { redirect_to(moedas_url) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @moeda.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @moeda = Moeda.find(params[:id])
        @moeda.destroy

        respond_to do |format|
            format.html { redirect_to(moedas_url) }
            format.xml  { head :ok }
        end
    end
end
