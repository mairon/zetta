  class ComprasController < ApplicationController
    before_filter :authenticate

    def get_moeda            #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('compra_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:compra_data]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('compra_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def get_produto          #
      
        @produto =  Produto.find(:first,:select => 'id,codigo,clase_id,grupo_id,sub_grupo_id,fabricante_cod,nome,taxa', :conditions =>  [ "fabricante_cod = ?", params[:key]]) 
        @grupo   =  Grupo.find(:first, :conditions =>  [ "id = ?", @produto.grupo_id]) unless @produto.nil?        
        ultimo_custo   =  Stock.last(:conditions =>  [ "produto_id = ? AND status = 0", @produto.id]) 
        stock    =  Stock.sum("entrada - saida", :conditions =>  [ "produto_id = ?", @produto.id]) 
        if ultimo_custo.nil?
           uc_us = 0
           uc_gs = 0
        else
           uc_us = ultimo_custo.unitario_dolar
           uc_gs = ultimo_custo.unitario_guarani
        end   
                       
        if @produto.nil?
           return render :text => "<script type='text/javascript'>
                                     alert('Producto no Encontrada, Pulse F2 Para Busca o Cadatre un Nuevo')
                                   </script>"
                            
        else
           return render :text => "<script type='text/javascript'>
                                     document.getElementById('compras_produto_produto_nome').value       = '#{@produto.nome.to_s}';
                                     document.getElementById('compras_produto_iva_taxa').value           = '#{@produto.taxa.to_i}';
                                     document.getElementById('compras_produto_produto_id').value         = '#{@produto.id.to_i}';
                                     document.getElementById('compras_produto_codigo').value             = '#{@produto.codigo.to_s}';
                                     document.getElementById('compras_produto_clase_id').value           = '#{@produto.clase_id.to_i}';
                                     document.getElementById('compras_produto_grupo_id').value           = '#{@produto.grupo_id.to_i}';
                                     document.getElementById('compras_produto_sub_grupo_id').value       = '#{@produto.sub_grupo_id.to_i}';
                                     document.getElementById('compras_produto_fabricante_cod').value     = '#{@produto.fabricante_cod.to_s}';
                                     document.getElementById('compras_produto_porcen_balcao').value      = '#{@grupo.porcen_balcao.to_i}';
                                     document.getElementById('compras_produto_porcen_maiorista').value   = '#{@grupo.porcen_mayo.to_i}';
                                     document.getElementById('compras_produto_porcen_minorista').value   = '#{@grupo.porcen_mino.to_i}';                                
                                     document.getElementById('compras_produto_unitario_dolar').value     = number_format(#{uc_us},2, ',', '.');
                                     document.getElementById('compras_produto_unitario_guarani').value   = number_format(#{uc_gs},0, ',', '.');                                
                                     document.getElementById('compras_produto_ultimo_custo_us').value    = number_format(#{uc_us},2, ',', '.');
                                     document.getElementById('compras_produto_ultimo_custo_gs').value    = number_format(#{uc_gs},0, ',', '.');                                
                                     document.getElementById('saldo').value                              = #{stock};                                
                                     
                                 </script>"
          
          end                    
    end

    def compras_produto      #

        @compra  = Compra.find(params[:id])
        @produto = ComprasProduto.find(:all,:conditions => ['compra_id = ?',params[:id]] )
        @produto_count       = ComprasProduto.count(:all,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )

        render :layout=>false


    end

    def get_proveedor        #
        @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('compras_documento_persona_ruc').value       = '#{@persona.ruc.to_s}';
                              document.getElementById('compras_documento_persona_id').value        = '#{@persona.id.to_i}';
                              document.getElementById('compras_documento_persona_nome').value      = '#{@persona.nome.to_s}';
                            </script>"
    end

    def get_proveedor_financa#
        @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('compras_financa_persona_ruc').value       = '#{@persona.ruc.to_s}';
                              document.getElementById('compras_financa_persona_id').value        = '#{@persona.id.to_i}';
                              document.getElementById('compras_financa_persona_nome').value      = '#{@persona.nome.to_s}';
                            </script>"
    end

    #IMPORTACAO---------------------------------------------------------------------

    def prorateo             #

        @compra          = Compra.find(params[:id])
        @compras_produto = ComprasProduto.all(:conditions => ['compra_id  =  ?',params[:id] ],:order => 1 )

        @compras_documento = ComprasDocumento.all( :conditions => ["compra_id  =  ?",params[:id] ] )



        respond_to do |format|
            format.html # show.html.erb
        end
    end

    def compras_financa      #
        @compra = Compra.find(params[:id])
        @cota_count          = ComprasFinanca.count(:id,:conditions => ['compra_id = ?',params[:id]] )
        @cota_total          = @cota_count +1
        @produto_count       = ComprasProduto.sum(:quantidade,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_dolar   = Compra.sum(:total_dolar,:conditions => ['id = ?',params[:id]] )
        @produto_sum_guarani = Compra.sum(:total_guarani,:conditions => ['id = ?',params[:id]] )
        @produto_sum_real = Compra.sum(:total_real,:conditions => ['id = ?',params[:id]] )
    end

    def compras_documento    #
        @compra = Compra.find(params[:id])
        @count_produtos               = ComprasProduto.count( :id, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])

        @total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
        @total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani

    end

    def compras_gasto        #
        @compra = Compra.find(params[:id])
        @count_produtos               = ComprasProduto.count( :id, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])

        @total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
        @total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani

    end

    def novo_produto         #
        @compra = Compra.find(params[:id])


    end

    def novo_financa         #
        @compra = Compra.find(params[:id])
        @cota_count          = ComprasFinanca.count(:id,:conditions => ['compra_id = ?',params[:id]] )
        @cota_total          = @cota_count +1
        @compras_documento   = ComprasDocumento.find_by_compra_id(params[:id])
        @produto_count       = ComprasProduto.sum(:quantidade,:conditions => ['compra_id = ?',params[:id]] )
        @cp_sum_dolar   = Compra.sum(:total_dolar,:conditions => ['id = ?',params[:id]] )
        @cp_sum_guarani = Compra.sum(:total_guarani,:conditions => ['id = ?',params[:id]] )
        @cp_sum_real    = Compra.sum(:total_real,:conditions => ['id = ?',params[:id]] )



    end

    def novo_gasto           #
        @compra = Compra.find(params[:id])
        @cota_count          = ComprasFinanca.count(:id,:conditions => ['compra_id = ?',params[:id]] )
        @cota_total          = @cota_count +1
        @compras_documento   = ComprasDocumento.find_by_compra_id(params[:id])
        @produto_count       = ComprasProduto.sum(:quantidade,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )



    end

    def novo_documento       #
        @compra = Compra.find(params[:id])
        @produto_sum_dolar   = ComprasProduto.sum(:total_dolar,:conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_guarani = ComprasProduto.sum(:total_guarani,:conditions => ['compra_id = ?',params[:id]] )



    end

    def total_documento      #
        @compra = Compra.find(params[:id])

        @produto_sum_dolar       = ComprasProduto.sum( :total_dolar,           :conditions => ['compra_id = ?',params[:id]] )
        @produto_sum_guarani     = ComprasProduto.sum( :total_guarani,         :conditions => ['compra_id = ?',params[:id]] )
        @total_dolar_documento   = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO'",params[:id]] )
        @total_guarani_documento = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'DESPACHO'",params[:id]] )
        @total_iva_dolar         = ComprasDocumento.sum( :imposto_10_dolar,    :conditions => ["compra_id = ?",params[:id]] )
        @total_iva_guarani       = ComprasDocumento.sum( :imposto_10_guarani,  :conditions => ["compra_id = ?",params[:id]] )
        @total_frete_dolar       = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'FLETES' ",params[:id]] )
        @total_frete_guarani     = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'FLETES' ",params[:id]] )
        @total_seguro_dolar      = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'SEGUROS' ",params[:id]] )
        @total_seguro_guarani    = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'SEGUROS' ",params[:id]] )
        @total_outros_dolar      = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'OUTROS' ",params[:id]] )
        @total_outros_guarani    = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'OUTROS' ",params[:id]] )

        #TOTAL DESPACHO--------------------------------------
        @total_invoice_dolar     = ComprasDocumento.sum( :total_dolar,         :conditions => ["compra_id = ? AND tipo_documento = 'MERCADERIAS' ",params[:id]] )
        @total_invoice_guarani   = ComprasDocumento.sum( :total_guarani,       :conditions => ["compra_id = ? AND tipo_documento = 'MERCADERIAS' ",params[:id]] )

        session[:proraterio] = "PRORATEIO"
         
    end

    #COMPRA-------------------------------------------------------------------------

    def comprovante          #
        @compra                       = Compra.find(params[:id])
        @produtos                     = ComprasProduto.all(:conditions => ['compra_id = ?', params[:id]])
        @count_produtos               = ComprasProduto.count( :quantidade, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_dolar           = ComprasProduto.sum( :total_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_produtos_guarani         = ComprasProduto.sum( :total_guarani, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_dolar           = ComprasProduto.sum( :desconto_dolar, :conditions => ['compra_id = ?', params[:id]])
        @sum_desconto_guarani         = ComprasProduto.sum( :desconto_guarani, :conditions => ['compra_id = ?', params[:id]])

        @total_dolar                  = @sum_produtos_dolar - @sum_desconto_dolar
        @total_guarani                = @sum_produtos_guarani - @sum_desconto_guarani

        render :layout => false
    end

    #GASTO--------------------------------------------------------------------------
    def index_gasto          #
        @compras = Compra.all(:conditions => ['tipo_compra = 1'])
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @compras }
        end
    end

    def busca_gasto          #
        @compras = Compra.filtro_busca_gasto(params)
        render :layout => false
    end

    def new_gasto            #
        @compra = Compra.new
        @setors = Setor.all(:select => 'id,nome', :order => '1')

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @compra }
        end
    end

    def edit_gasto           #
        @setors = Setor.all(:select => 'id,nome', :order => '1')        
        @compra  = Compra.find(params[:id])
        session[:proraterio] = ""
    end


    #METHODS BASE-------------------------------------------------------------------
    def index                #
        respond_to do |format|
            format.html # index.html.erb
        end
    end

    def busca                #
        @compras = Compra.filtro_busca_compra(params)
        render :layout => false
    end

    def show                 #
        @compra                       = Compra.find(params[:id])
        @compras_produto              = ComprasProduto.all(:select => "id,produto_nome,produto_id,deposito_nome,quantidade,unitario_dolar,total_dolar,desconto_dolar,custo_contabil_dolar,unitario_guarani,total_guarani,desconto_guarani,custo_contabil_guarani",:conditions => ['compra_id  =  ?',params[:id] ],:order => 1 )        
        respond_to do |format|
            format.html
        end
    end

    def new                  #
        @compra = Compra.new
        @setors = Setor.all(:select => 'id,nome', :order => '1')

        respond_to do |format|
            format.html # new.html.erb            
        end
    end

    def edit                 #
        @compra  = Compra.find(params[:id])
        @setors = Setor.all(:select => 'id,nome', :order => '1')

        session[:proraterio] = ""
    end

    def create               #
        @compra = Compra.new(params[:compra])
        #USUARIO UNIDADE
        @compra.usuario_created = current_user.id
        @compra.unidade_created = current_unidade.id

        respond_to do |format|
            if @compra.save

                if @compra.tipo_compra == 0 || @compra.tipo_compra == 2 || @compra.tipo_compra == 3
                    
                    format.html { redirect_to(@compra) }
                else
                    if @compra.adcionais == 1
                        format.html { redirect_to "/compras/compras_gasto/#{@compra.id}" }
                    else
                        format.html { redirect_to "/compras/compras_financa/#{@compra.id}" }
                    end                   
                end
                
                flash[:notice] = 'Grabado con Sucesso'
            else
                if @compra.tipo_compra == 0 || @compra.tipo_compra == 3 || @compra.tipo_compra == 2
                    format.html { render :action => "new" }
                elsif @compra.tipo_compra == 1
                    format.html { render :action => "new_gasto" }
                end
            end
        end
    end

    def update               #
        @compra = Compra.find(params[:id])
        #USUARIO UNIDADE
        @compra.usuario_updated = current_user.id
        @compra.unidade_updated = current_unidade.id

        respond_to do |format|

            if @compra.update_attributes(params[:compra])
                flash[:notice] = 'Grabado con Sucesso!'
                
                if session[:proraterio] == "PRORATEIO"
                    format.html { redirect_to "/compras/#{@compra.id}/prorateo" }
                end

                if @compra.tipo_compra == 0 || @compra.tipo_compra == 2 || @compra.tipo_compra == 3 
                    flash[:notice] = 'Precione F4 para elegir un producto'
                    format.html { redirect_to(@compra) }
                else
                    if @compra.adcionais == 1
                        format.html { redirect_to "/compras/#{@compra.id}/compras_gasto" }
                    else
                        format.html { redirect_to "/compras/#{@compra.id}/compras_financa" }
                    end

                end
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy              #
        @compra = Compra.find(params[:id])
        @compra.destroy

        respond_to do |format|
            if  @compra.tipo_compra == 1
                format.html { redirect_to "/compras/index_gasto" }
                format.xml  { head :ok }
            else
                format.html { redirect_to(compras_url) }
                format.xml  { head :ok }
            end
        end
    end
end
  
