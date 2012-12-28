class CobrosController < ApplicationController
before_filter :authenticate


    def get_codigo           #
    @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:codigo]])

                return render :text => "<script type='text/javascript'>
                                      document.getElementById('cobro_persona_id').value         = '#{@persona.id.to_i}';
                                      document.getElementById('cobro_persona_cod').value        = '#{@persona.cod_velho.to_i}';
                                      document.getElementById('cobro_persona_nome').value       = '#{@persona.nome.to_s}';
                                      document.getElementById('cobro_ruc').value                = '#{@persona.ruc.to_s}';
                                    </script>"
  end

    def get_moeda            #
        @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('cobro_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end


    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('cobro_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def nova_cota            #
        @cobro = Cobro.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end
    end


    def nc_ft            #
        @cobro = Cobro.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end
    end


    def busca_cliente        #
        @cobro    = Cobro.find(params[:id])
        render :layout => 'consulta'
    end

    def filtro_busca_cliente #
        @cobro    = Cobro.find(params[:id])

         tipo = "documento_numero"          if params[:tipo] == "NUMERO"

        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              vendedor_id,
                                              vendedor_nome,
                                              pagare,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              numero_ordem,
                                              cota,
                                              clase_produto,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              divida_real,
                                              cobro_dolar,
                                              cobro_guarani,
                                              cobro_real,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',

                                 :conditions => [" persona_id = ? AND #{tipo} LIKE '%#{params[:filtro]}%' AND liquidacao = 0  AND tipo = '1' AND (divida_guarani + divida_dolar) > 0",params[:busca]],:order => 'data,venda_id,cota')
                                 render :layout => false
    end

    def cobro_final          #
        @cobro       = Cobro.find(params[:id])
        @cd          = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
        @total_cobro_dolar      = CobrosDetalhe.sum( :cobro_dolar,     :conditions => ['cobro_id = ?',params[:id]])
        @total_cobro_guarani    = CobrosDetalhe.sum( :cobro_guarani,   :conditions => ['cobro_id = ?',params[:id]])
        @total_cobro_real       = CobrosDetalhe.sum( :cobro_real,      :conditions => ['cobro_id = ?',params[:id]])
        @total_desconto_dolar   = CobrosDetalhe.sum( :desconto_dolar,  :conditions => ['cobro_id = ?',params[:id]])
        @total_desconto_guarani = CobrosDetalhe.sum( :desconto_guarani,:conditions => ['cobro_id = ?',params[:id]])
        @total_desconto_real    = CobrosDetalhe.sum( :desconto_real,   :conditions => ['cobro_id = ?',params[:id]])
        @total_interes_dolar    = CobrosDetalhe.sum( :interes_dolar,   :conditions => ['cobro_id = ?',params[:id]])
        @total_interes_guarani  = CobrosDetalhe.sum( :interes_guarani, :conditions => ['cobro_id = ?',params[:id]])
        @total_interes_real     = CobrosDetalhe.sum( :interes_real, :conditions => ['cobro_id = ?',params[:id]])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end        
    end

    def recibo          #
        @cobro        = Cobro.find(params[:id])
        @cd           = CobrosDetalhe.all(:conditions => ['cobro_id = ?',params[:id]])
        @cf           = CobrosFinanca.all(:conditions => ['cobro_id = ?',params[:id]])
        @total_us     = CobrosFinanca.sum('valor_dolar',:conditions => ['cobro_id = ?',params[:id]])
        @total_gs     = CobrosFinanca.sum('valor_guarani',:conditions => ['cobro_id = ?',params[:id]])
        @cf_last      = CobrosFinanca.last(:conditions => ['cobro_id = ?',params[:id]])
        @cheque_true  = CobrosFinanca.all(:conditions => ['cheque_status = 1 and cobro_id = ?',params[:id]])
        @cheque_false = CobrosFinanca.all(:conditions => ['cheque_status = 0 and cobro_id = ?',params[:id]])
        render  :layout => false
    end


    #METHOD BASE------------------------------------------------------------------

    def index                #
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @cobros }
        end
    end

    def busca                #
        @cobros = Cobro.filtro(params)
        render :layout => false
    end

    def gera_pdf_cobros      #
        @cobro       = Cobro.find(params[:id])
        @cobros_detalhes     = CobrosDetalhe.all( :conditions => ['cobro_id = ?',params[:id]],:order => 'documento_numero')
        @total_cobro_dolar   = CobrosDetalhe.sum(:cobro_dolar, :conditions => ['cobro_id = ?',params[:id]])
        @total_cobro_guarani = CobrosDetalhe.sum(:cobro_guarani, :conditions => ['cobro_id = ?',params[:id]])
        @count               = CobrosDetalhe.count(:id, :conditions => ['cobro_id = ?',params[:id]])
         pdf = render :layout => 'layer_relatorios'
              kit = PDFKit.new(pdf,:page_size     => 'A4',
                                   :print_media_type  => true,
                                   :header_font_name  => 'bold',
                                   :header_font_size  => "9" ,
                                   :header_spacing    => "25",                                   
                                   :footer_font_size  => "7",
                                   :footer_right  => "Pagina [page] de [toPage]",
                                   :footer_left   => "MercoSys Pratic - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                                   :margin_top    => '0.20in',
                                   :margin_bottom => '0.25in',
                                   :margin_left   => '0.10in',
                                   :margin_right  => '0.10in')
              kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
              send_data(kit.to_pdf, :filename => "Detalhes_Cobros.pdf")    

    end

    def show                 #
        @cobro       = Cobro.find(params[:id])
        @count                  = CobrosDetalhe.count( :id,            :conditions => ['cobro_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @cobro }
        end
    end

    def new                  #
        @cobro = Cobro.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @cobro }
        end
    end

    def edit                 #
        @cobro = Cobro.find(params[:id])        
    end

    def create               #
        @cobro = Cobro.new(params[:cobro])
        @cobro.usuario_created = current_user.id
        @cobro.unidade_created = current_unidade.id


        respond_to do |format|
            if @cobro.save
                flash[:notice] = 'Cobro was successfully created.'
                format.html { redirect_to(@cobro) }
                format.xml  { render :xml => @cobro, :status => :created, :location => @cobro }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @cobro.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update               #
        @cobro = Cobro.find(params[:id])
        @cobro.usuario_updated = current_user.id
        @cobro.unidade_updated = current_unidade.id

        respond_to do |format|
      
            if @cobro.update_attributes(params[:cobro])
                flash[:notice] = 'Actualizado con Sucesso.'                
                    format.html { redirect_to(@cobro) }
                    format.xml  { head :ok }

            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @cobro.errors, :status => :unprocessable_entity }
            end

        end
    end

    def destroy              #
        @cobro = Cobro.find(params[:id])
        @cobro.destroy

        respond_to do |format|
            format.html { redirect_to(cobros_url) }
            format.xml  { head :ok }
        end
    end
end
