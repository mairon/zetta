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
        @debe   = SueldosDetalhe.sum(:valor_guarani,:conditions => ["sueldo_id = ? AND estado = 1", @sueldo.id])
        @haber  = SueldosDetalhe.sum(:valor_guarani,:conditions => ["sueldo_id = ? AND  estado = 0", @sueldo.id])
        @tot    = @haber - @debe

        render :layout => false
    end

    def get_moeda           #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('sueldos_detalhe_cotacao').value       = '#{format("%.2f",@moeda.dolar_venda.to_f)}';
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
        
        @pendencias = Cliente.sum('divida_guarani - cobro_guarani', :conditions => [" PERSONA_ID = #{@sueldo.persona_id}
         AND   LIQUIDACAO = 0
         AND   TIPO       = '1'
         AND   date_part('month', DATA) <= '#{@sueldo.mes}'  AND  date_part('year', DATA) <= '#{@sueldo.ano}'"])

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
