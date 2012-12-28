class EgressosController < ApplicationController
    before_filter :authenticate

    def get_moeda               #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('egresso_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('egresso_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def busca_egreso            #
        @egressos = Egresso.filtro_egreso(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def index                   #
        respond_to do |format|
            format.html # index.html.erb
        end
    end

    def show                    #
        @egresso = Egresso.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @egresso }
        end
    end

    def comprovante                    #
        @egresso = Egresso.find(params[:id])

        render :layout => false	
    end


    def new                     #
        @egresso = Egresso.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @egresso }
        end
    end

    def edit                    #
        @egresso = Egresso.find(params[:id])
    end

    def create                  #
        @egresso = Egresso.new(params[:egresso])

        respond_to do |format|
            if @egresso.save
                format.html { redirect_to(@egresso, :notice => 'Grabado Con Sucesso.') }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                  #
        @egresso = Egresso.find(params[:id])

        respond_to do |format|
            if @egresso.update_attributes(params[:egresso])
                format.html { redirect_to(@egresso, :notice => 'Actualizado con Sucesso.') }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                 #
        @egresso = Egresso.find(params[:id])
        @egresso.destroy

        respond_to do |format|
            format.html { redirect_to(egressos_url) }
        end
    end
end
