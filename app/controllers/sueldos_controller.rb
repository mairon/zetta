class SueldosController < ApplicationController
    before_filter :authenticate


    def get_moeda_gastos    #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('compra_cotacao').value       = '#{format("%.2f",@moeda.dolar_venda.to_f)}';
                            </script>"
    end

    def comprovante         #
        @sueldo = Sueldo.find(params[:id])
        if @sueldo.moeda == 0
            saldo = 'divida_dolar - cobro_dolar'
        elsif @sueldo.moeda == 1
            saldo = 'divida_guarani - cobro_guarani'
        else
            saldo = 'divida_real - cobro_real'
        end
        @pendentes = Cliente.sum(saldo,:conditions => ["persona_id = ?  AND liquidacao = 0  AND tipo = '1' and data <= ?",@sueldo.persona_id,@sueldo.data_final])

        @sueldos_detalhes = SueldosDetalhe.all(:conditions => ["sueldo_id = ?",@sueldo.id],:order => 'data,id')

        render :layout => false
    end

    def get_moeda           #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('sueldos_detalhe_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end



    def get_moeda_real           #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('sueldos_detalhe_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end

    def form_sueldos_detalhes
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    #METHODS BASE-------------------------------------------------------------------
    def index
        @sueldos = Sueldo.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @sueldos }
        end
    end

    def detalhes_financeiros
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    def fim_detalhes
        @sueldo = Sueldo.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end


    def show
        @sueldo = Sueldo.find(params[:id])

        @pendentes = Cliente.all(:conditions => ["persona_id = ?  AND liquidacao = 0  AND tipo = '1' AND (divida_guarani + divida_dolar + divida_real) > 0 and data <= ?",@sueldo.persona_id,@sueldo.data_final],:order => 'data,id')
    
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    def new
        @sueldo = Sueldo.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @sueldo }
        end
    end

    def edit
        @sueldo = Sueldo.find(params[:id])
    end

    def create
        @sueldo = Sueldo.new(params[:sueldo])
        @sueldo.usuario_created = current_user.usuario_nome
        @sueldo.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @sueldo.save
                format.html { redirect_to(@sueldo, :notice => 'Grabado con Sucesso') }
                format.xml  { render :xml => @sueldo, :status => :created, :location => @sueldo }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @sueldo.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @sueldo = Sueldo.find(params[:id])
        @sueldo.usuario_updated = current_user.usuario_nome
        @sueldo.unidade_updated = current_unidade.unidade_nome

        respond_to do |format|
            if @sueldo.update_attributes(params[:sueldo])
                format.html { redirect_to(@sueldo, :notice => 'Actualizado con Sucesso!') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @sueldo.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @sueldo = Sueldo.find(params[:id])
        @sueldo.destroy

        respond_to do |format|
            format.html { redirect_to(sueldos_url) }
            format.xml  { head :ok }
        end
    end
end
