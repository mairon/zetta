class PagosController < ApplicationController
    before_filter :authenticate

    def get_moeda                   #
        @moeda =  Moeda.find(:first, :select => 'dolar_venda',:conditions =>  ["data = ?", params[:key]]) 

        return render :text => "<script type='text/javascript'>
                                        document.getElementById('pago_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('pago_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def nova_cota                   #
        @pago = Pago.find(params[:id])
    
        @proveedor  = Proveedore.all(:conditions => ["persona_id = ? AND liquidacao = 0 AND  divida_dolar > 0 ",@pago.persona_id],:order => 'documento_numero,cota')

        respond_to do |format|
            format.html { render :layout => 'consulta'}
            format.xml  { render :xml => @pago }
        end
    end

    def filtro_dividas              #

        @pago       = Pago.find(params[:id])
        @proveedor  = Proveedore.find(params[:pagos_ids])

        @proveedor.each do |proveedor|
            anterior_dolar     = Proveedore.sum(:pago_dolar, :conditions   => ["documento_numero = ? AND cota = ?",proveedor.documento_numero,proveedor.cota])
            anterior_guarani   = Proveedore.sum(:pago_guarani, :conditions => ["documento_numero = ? AND cota = ?",proveedor.documento_numero,proveedor.cota])
            saldo_dolar        = proveedor.divida_dolar.to_f - anterior_dolar.to_f
            saldo_guarani      = proveedor.divida_guarani.to_f - anterior_guarani.to_f

            PagosDetalhe.create(  :pago_id              => @pago.id,
                :vencimento           => proveedor.vencimento,
                :data                 => proveedor.data,
                :persona_id           => proveedor.persona_id,
                :persona_nome         => proveedor.persona_nome,
                :documento_nome       => proveedor.documento_nome,
                :documento_numero_01  => proveedor.documento_numero_01,
                :documento_numero_02  => proveedor.documento_numero_02,
                :documento_numero     => proveedor.documento_numero,
                :compra_id            => proveedor.compra_id,
                :cota                 => proveedor.cota,
                :estado               => 1,
                :liquidacao           => 1,
                :valor_dolar          => proveedor.divida_dolar.to_f,
                :valor_guarani        => proveedor.divida_guarani.to_f,
                :anterior_dolar       => anterior_dolar.to_f,
                :anterior_guarani     => anterior_guarani.to_f,
                :saldo_dolar          => saldo_dolar.to_f,
                :saldo_guarani        => saldo_guarani.to_f,
                :pago_dolar           => saldo_dolar.to_f,
                :pago_guarani         => saldo_guarani.to_f

            )


        end

        respond_to do |format|
            format.html {redirect_to "/pagos/show/#{params[:id]}"}
            format.xml  { render :xml => @pagos }
        end



    end

    def get_cliente                 #
        @cliente =  Persona.find(:first, :conditions =>  [ "nome = ?", params[:persona_busca]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('pago_ruc').value                = '#{@cliente.ruc.to_s}';
                              document.getElementById('pago_persona_id').value         = '#{@cliente.id.to_s}';
                              document.getElementById('pago_persona_nome').value       = '#{@cliente.nome.to_s}';
                            </script>"
    end

    def pago_final                  #
        @pago    = Pago.find(params[:id])
        @pago_us = PagosDetalhe.sum(:pago_dolar, :conditions => ['pago_id = ?',params[:id]])
        @pago_gs = PagosDetalhe.sum(:pago_guarani, :conditions => ['pago_id = ?',params[:id]])
        @pago_rs = PagosDetalhe.sum(:pago_real, :conditions => ['pago_id = ?',params[:id]])

        @desconto_us = PagosDetalhe.sum(:desconto_dolar, :conditions => ['pago_id = ?',params[:id]])
        @desconto_gs = PagosDetalhe.sum(:desconto_guarani, :conditions => ['pago_id = ?',params[:id]])
        @desconto_rs = PagosDetalhe.sum(:desconto_real, :conditions => ['pago_id = ?',params[:id]])

        @interes_us = PagosDetalhe.sum(:interes_dolar, :conditions => ['pago_id = ?',params[:id]])
        @interes_gs = PagosDetalhe.sum(:interes_guarani, :conditions => ['pago_id = ?',params[:id]])
        @interes_rs = PagosDetalhe.sum(:interes_real, :conditions => ['pago_id = ?',params[:id]])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @pago }
        end
        session[:pagina] = ''
    end

    #METHOD BASE------------------------------------------------------------------

    def index                #
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @cobros }
        end
    end

    def busca                #
        @pagos = Pago.filtro(params)
        render :layout => false
    end

    def show                        #
        @pago       = Pago.find(params[:id])
        @proveedor  = Proveedore.all(:conditions => ["persona_id = ? AND liquidacao = 0 AND  ( divida_dolar + divida_guarani + divida_real)  > 0 ",@pago.persona_id],:order => 'documento_numero,cota')
    
        @total_pago_dolar   = PagosDetalhe.sum(:pago_dolar, :conditions => ['pago_id = ?',params[:id]])
        @total_pago_guarani = PagosDetalhe.sum(:pago_guarani, :conditions => ['pago_id = ?',params[:id]])
        @count              = PagosDetalhe.count(:id, :conditions => ['pago_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @pago }
        end
    end

    def new                         #
        @pago = Pago.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @pago }
        end
    end

    def edit                        #
        @pago = Pago.find(params[:id])
        session[:pagina] = '1'
    end

    def create                      #
        @pago = Pago.new(params[:pago])
        @pago.usuario_created = current_user.id
        @pago.unidade_created = current_unidade.id


        respond_to do |format|
            if @pago.save
                flash[:notice] = 'Grabaco con Sucesso!'
                format.html { redirect_to(@pago) }
                format.xml  { render :xml => @pago, :status => :created, :location => @pago }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @pago.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                      #
        @pago = Pago.find(params[:id])
        @pago.usuario_updated = current_user.id
        @pago.unidade_updated = current_unidade.id

        respond_to do |format|

            if @pago.update_attributes(params[:pago])
                flash[:notice] = 'Actualizado con Sucesso.'
        
                if session[:pagina] == '1'
                    format.html { redirect_to(@pago) }
                    format.xml  { head :ok }
                else
                    format.html { redirect_to(pagos_url) }
                    format.xml  { head :ok }
                end

            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @pago.errors, :status => :unprocessable_entity }
                
            end

        end
    end

    def destroy                     #
        @pago = Pago.find(params[:id])
        @pago.destroy

        respond_to do |format|
            format.html { redirect_to(pagos_url) }
            format.xml  { head :ok }
        end
    end
end

