class VendasController < ApplicationController

  before_filter :authenticate

  def colaboradores
    @venda = Venda.find(params[:id])
  end
  
  def gerador_cotas                #
      @venda = Venda.find(params[:id])

      @produto_sum_dolar   = VendasProduto.sum(:total_dolar, :conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum(:total_guarani, :conditions => ['venda_id = ?',params[:id]] )
      @contado_sum_dolar   = VendasFinanca.sum(:valor_dolar_contado, :conditions => ['venda_id = ?',params[:id]] )
      @contado_sum_guarani = VendasFinanca.sum(:valor_guarani_contado, :conditions => ['venda_id = ?',params[:id]] )

  end

  def gerar_cotas_credito
    @venda = Venda.find(params[:id])
    Venda.gerador_cotas(params)
    redirect_to("/vendas/"<< @venda.id.to_s<< '/vendas_financa')
  end
  
  #busca_pedido
  def get_pedido
      pedido =  Presupuesto.find(:first, :conditions =>  [ "id = ?", params[:venda_pedido_id]])

      return render :text => "<script type='text/javascript'>
                                if (#{pedido.status} == 0){
                                  document.getElementById('venda_vendedor_nome').value   = '#{pedido.vendedor_nome.to_i}';                                  
                                  document.getElementById('codigo').value                = '#{pedido.persona_id.to_i}';
                                  document.getElementById('venda_persona_id').value    = '#{pedido.persona_id}';
                                  document.getElementById('venda_persona_nome').value    = '#{pedido.persona_nome}';
                                  document.getElementById('venda_limite_credito').value  = '#{pedido.limite_credito}';
                                  document.getElementById('venda_ruc').value             = '#{pedido.ruc}';                                                                                                                                          
                                }
                                else {
                                  alert('Pedido Ja Facturado ou Cancelado')
                                  document.getElementById('venda_pedido_id').focus();                        

                                }
                            </script>"
  end
  
  def get_plano                           #
      @venda = Venda.find(params[:id])

      plano =  Plano.find(:first, :conditions =>  [ "id = ?", params[:codigo]])
      
      @produto_sum_dolar   = VendasProduto.sum('unitario_dolar * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum('unitario_guarani * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      if @venda.tipo_maiorista.to_i == 0
        if plano.status == 0
        
          data    = @venda.data + plano.periodo.to_i   
          periodo = plano.periodo.to_i
          taxa    = plano.periodo.to_i * plano.taxa.to_f
          int_us  = ( @produto_sum_dolar.to_f * taxa ) / 100  
          int_gs  = ( @produto_sum_guarani.to_f * taxa ) / 100  
          tot_us  = ( @produto_sum_dolar.to_f + int_us.to_f )
          tot_gs  = ( @produto_sum_guarani.to_f + int_gs.to_f )

        else

          data    = ("#{plano.ano}-#{plano.mes}-#{@venda.data.to_date.strftime("%d")}" ).to_date   
          periodo = ("#{plano.ano}-#{plano.mes}-#{@venda.data.to_date.strftime("%d")}" ).to_date - @venda.data   
          taxa    = periodo.to_i * plano.taxa.to_f
          int_us  = ( @produto_sum_dolar.to_f * taxa ) / 100  
          int_gs  = ( @produto_sum_guarani.to_f * taxa ) / 100
           
          tot_us  = ( @produto_sum_dolar.to_f + int_us.to_f )
          tot_gs  = ( @produto_sum_guarani.to_f + int_gs.to_f )
         
        end
      else
       
          data    = ("#{plano.ano}-#{plano.mes}-#{@venda.data.to_date.strftime("%d")}" ).to_date   
          periodo = ("#{plano.ano}-#{plano.mes}-#{@venda.data.to_date.strftime("%d")}" ).to_date - @venda.data   
          taxa    = periodo.to_i * plano.taxa.to_f
          int_us  = 0  
          int_gs  = 0             
          tot_us  = ( @produto_sum_dolar.to_f + int_us.to_f )
          tot_gs  = ( @produto_sum_guarani.to_f + int_gs.to_f )

      end    
     
      return render :text => "<script type='text/javascript'>
                            document.getElementById('vendas_financa_plano_id').value           = '#{plano.id.to_i}';
                            document.getElementById('vendas_financa_plano_condicao').value     = '#{plano.condicao}';
                            document.getElementById('vendas_financa_plano_taxa').value         = '#{plano.taxa.to_f}';
                            document.getElementById('vendas_financa_plano_status').value       = '#{plano.status.to_i}';
                            document.getElementById('vendas_financa_plano_periodo').value      = '#{periodo}';
                            document.getElementById('vendas_financa_interes_us').value         = number_format(#{int_us},2, ',', '.');
                            document.getElementById('vendas_financa_interes_gs').value         = number_format(#{int_gs},0  , ',', '.');
                            document.getElementById('vendas_financa_cota_dolar_01').value      = number_format(#{tot_us},2, ',', '.');
                            document.getElementById('vendas_financa_cota_guarani_01').value    = number_format(#{tot_gs},0  , ',', '.');
                            document.getElementById('vendas_financa_plano_data').value         = '#{plano.ano}-#{plano.mes}-#{@venda.data.strftime("%d")}';
                            document.getElementById('vendas_financa_data_cota_01_3i').value    = '#{data.strftime("%d").to_i}';
                            document.getElementById('vendas_financa_data_cota_01_2i').value    = '#{data.strftime("%m").to_i}';
                            document.getElementById('vendas_financa_data_cota_01_1i').value    = '#{data.strftime("%Y").to_i}';

                            </script>"
  end


  def get_codigo_barra_produto             #
      @venda   = Venda.find(params[:id])
      @produto = Produto.first( :conditions =>  [ "fabricante_cod = ?", params[:codigo]])
      @stock   = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND DEPOSITO_ID = #{params[:deposito_id]}",@produto.id] )

      if @venda.tipo_maiorista == 0
          preco_dolar   = @produto.preco_venda_dolar.to_f
          preco_guarani = @produto.preco_venda_guarani.to_f
          preco_real    = @produto.preco_venda_real.to_f
      elsif @venda.tipo_maiorista == 1
          preco_dolar   = @produto.preco_maiorista_dolar.to_f
          preco_guarani = @produto.preco_maiorista_guarani.to_f
      else
          preco_dolar   = @produto.preco_minorista_dolar.to_f
          preco_guarani = @produto.preco_minorista_guarani.to_f
      end

      return render :text => "<script type='text/javascript'>
                                document.getElementById('venda_produto_produto_busca_').value            = '#{@produto.nome.to_s}';
                                document.getElementById('vendas_produto_produto_nome').value             = '#{@produto.nome.to_s}';
                                document.getElementById('vendas_produto_produto_cod').value              = '#{@produto.cod_velho.to_i}';
                                document.getElementById('vendas_produto_produto_id').value               = '#{@produto.id.to_i}';
                                document.getElementById('vendas_produto_codigo').value                   = '#{@produto.codigo.to_i}';
                                document.getElementById('vendas_produto_clase_id').value                 = '#{@produto.clase_id.to_i}';
                                document.getElementById('vendas_produto_grupo_id').value                 = '#{@produto.grupo_id.to_i}';
                                document.getElementById('vendas_produto_tipo').value                     = '#{@produto.tipo.to_i}';
                                document.getElementById('vendas_produto_desconto').value                 = '#{@produto.desconto.to_i}';
                                document.getElementById('vendas_produto_unitario_dolar').value           = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_unitario_guarani').value         = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_unitario_real').value            = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_preco_dolar').value              = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_preco_guarani').value            = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_preco_real').value               = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_preco_fixo_dolar').value         = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_preco_fixo_guarani').value       = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_preco_fixo_real').value          = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_saldo').value                    = '#{@stock}';
                                document.getElementById('vendas_produto_taxa').value                     = '#{@produto.taxa.to_i}';
                                 if ( '#{@stock}' <= 0 )
                                   {
                                    document.getElementById('red').innerHTML                             =  '<span>'+'#{@stock}'+'</span>' ;
                                    document.getElementById('green').innerHTML                           =  '' ;
                                   }
                                 else
                                   {
                                    document.getElementById('green').innerHTML                           =  '<span>'+'#{@stock}'+'</span>' ;
                                    document.getElementById('red').innerHTML                             =  '' ;
                                   }
                              </script>"
  end

  def get_produto                          #

      @venda = Venda.find(params[:id])

      @produto =  Produto.find(:first, :conditions =>  [ "nome = ?", params[:produto_busca]])

      @stock    = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND DEPOSITO_ID = #{params[:deposito_id]}",@produto.id] )

      if @venda.tipo_maiorista == 0
          preco_dolar   = @produto.preco_venda_dolar.to_f
          preco_guarani = @produto.preco_venda_guarani.to_f
          preco_real    = @produto.preco_venda_real.to_f
      elsif @venda.tipo_maiorista == 1
          preco_dolar   = @produto.preco_maiorista_dolar.to_f
          preco_guarani = @produto.preco_maiorista_guarani.to_f
      else
          preco_dolar   = @produto.preco_minorista_dolar.to_f
          preco_guarani = @produto.preco_minorista_guarani.to_f
      end


      return render :text => "<script type='text/javascript'>
                                document.getElementById('venda_produto_produto_busca_').value            = '#{@produto.nome.to_s}';
                                document.getElementById('vendas_produto_produto_nome').value             = '#{@produto.nome.to_s}';
                                document.getElementById('vendas_produto_produto_cod').value              = '#{@produto.cod_velho.to_i}';
                                document.getElementById('vendas_produto_produto_id').value               = '#{@produto.id.to_i}';
                                document.getElementById('vendas_produto_codigo').value                   = '#{@produto.codigo.to_i}';
                                document.getElementById('vendas_produto_clase_id').value                 = '#{@produto.clase_id.to_i}';
                                document.getElementById('vendas_produto_grupo_id').value                 = '#{@produto.grupo_id.to_i}';
                                document.getElementById('vendas_produto_tipo').value                     = '#{@produto.tipo.to_i}';
                                document.getElementById('vendas_produto_desconto').value                 = '#{@produto.desconto.to_i}';
                                document.getElementById('vendas_produto_unitario_dolar').value           = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_unitario_guarani').value         = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_unitario_real').value            = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_preco_dolar').value              = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_preco_guarani').value            = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_preco_real').value               = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_preco_fixo_dolar').value         = number_format( #{preco_dolar},2, ',', '.')
                                document.getElementById('vendas_produto_preco_fixo_guarani').value       = number_format( #{preco_guarani},0, ',', '.');
                                document.getElementById('vendas_produto_preco_fixo_real').value          = number_format( #{preco_real},2, ',', '.')
                                document.getElementById('vendas_produto_saldo').value                    = '#{@stock}';
                                document.getElementById('vendas_produto_taxa').value                     = '#{@produto.taxa.to_i}';
                                 if ( '#{@stock}' <= 0 )
                                   {
                                    document.getElementById('red').innerHTML                             =  '<span>'+'#{@stock}'+'</span>' ;
                                    document.getElementById('green').innerHTML                           =  '' ;
                                   }
                                 else
                                   {
                                    document.getElementById('green').innerHTML                           =  '<span>'+'#{@stock}'+'</span>' ;
                                    document.getElementById('red').innerHTML                             =  '' ;
                                   }
                              </script>"
  end

  def get_moeda                            #
      @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:key]])
      return render :text => "<script type='text/javascript'>
                            document.getElementById('venda_cotacao').value       = '#{@moeda.dolar_compra.to_i}';
                          </script>"
  end


  def get_moeda_real            #
      @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
      return render :text => "<script type='text/javascript'>
                             document.getElementById('venda_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                          </script>"
  end


  def get_cliente                          #
      @cliente =  Persona.find(:first, :conditions =>  [ "nome = ?", params[:persona_busca]])
      return render :text => "<script type='text/javascript'>
                            document.getElementById('vendas_financa_persona_nome').value       = '#{@cliente.nome.to_s}';
                            document.getElementById('vendas_financa_persona_id').value         = '#{@cliente.id.to_i}';
                            document.getElementById('vendas_financa_ruc').value                = '#{@cliente.ruc.to_s}';
                            document.getElementById('vendas_financa_direcao').value            = '#{@cliente.direcao.to_s}';
                            document.getElementById('vendas_financa_cidade_id').value          = '#{@cliente.cidade_id.to_i}';
                            document.getElementById('vendas_financa_bairro').value             = '#{@cliente.bairro.to_s}';
                          </script>"
  end

  def novo_produto                         #
      @venda = Venda.find(params[:id])

      respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @venda }
      end
  end


  def vendas_financa                       #
      @venda = Venda.find(params[:id])
      @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_dolar   = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_real    = VendasProduto.sum(:total_real, :conditions => ['venda_id = ?',params[:id]] )        
      contado_us           = VendasFinanca.sum(:valor_dolar_contado,:conditions => ['venda_id = ? and tipo = 0',params[:id]] )
      contado_gs           = VendasFinanca.sum(:valor_guarani_contado,:conditions => ['venda_id = ? and tipo = 0',params[:id]] )
      credito_us           = VendasFinanca.sum(:cota_dolar_01,:conditions => ['venda_id = ? and tipo = 1',params[:id]] )
      credito_gs           = VendasFinanca.sum(:cota_guarani_01,:conditions => ['venda_id = ? and tipo = 1',params[:id]] )
      @financa_sum_dolar   = contado_us.to_f + credito_us.to_f 
      @financa_sum_guarani = contado_gs.to_f + credito_gs.to_f 

      @produto_iva_guarani = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_dolar   = VendasProduto.sum('iva_dolar * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @count               = VendasFinanca.count(:id,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @count_all           = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      render :layout => 'layout_vendas'
      session[:pagina] = '2'
  end

  def vendas_entrada_produto               #
      @venda = Venda.find(params[:id])
      @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_dolar   = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_guarani = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_dolar   = VendasProduto.sum('iva_dolar * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @count               = VendasFinanca.count(:id,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @count_all           = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      render :layout => 'vendas'
  end

  def vendas_financa_contado               #
      @venda = Venda.find(params[:id])
      @produto_count       = VendasProduto.sum(:quantidade,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_dolar   = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_iva_guarani = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['venda_id = ?',params[:id]] )
      @cota_count          = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      @cota_total          = @cota_count +1
      render :layout => 'vendas'
  end

  def novo_financa                         #
      @venda = Venda.find(params[:id])
      @cota_count          = VendasFinanca.count(:id,:conditions => ['venda_id = ?',params[:id]] )
      @cota_total          = @cota_count +1
  end

  # FATURAS PENDENTES-------------------------------------------------------

  def faturas_pendentes                    #
      @vendas = Venda.all(:conditions => ["fatura = 0"])
      render :layout => 'application'
  end

  def filtro_faturas_pendentes             #
      @vendas = Venda.find(params[:venda_ids])
      render :layout => 'application'
  end

  def update_faturas_pendentes             #
      @vendas          = Venda.find(params[:venda_ids])

      @vendas.each do |venda|
          venda.update_attributes!(params[:venda].reject { |k,v| v.blank? })
      end
      flash[:notice] = 'Productos Facturados'
      redirect_to  :action => 'filtro_faturas_pendentes_comprovante', :paras =>  params[:venda_ids]
  end

  def filtro_faturas_pendentes_comprovante #
      @vendas = Venda.find(params[:paras])
      render :layout => 'application'
  end

  def detalhes_produto                     #

      @produtos   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]] )
      render :layout => 'consulta'
  end

  def comprovante                          #
      @venda           = Venda.find(params[:id])
      @venda_produto   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @fin_sum_gs  = VendasFinanca.sum(:cota_guarani_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @fin_sum_us  = VendasFinanca.sum(:cota_dolar_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @venci           = VendasFinanca.last(:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )       
      render :layout => false
  end

  def pagare                          #
      @venda           = Venda.find(params[:id])
      @venda_produto   = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_us  = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @fin_sum_gs  = VendasFinanca.sum(:cota_guarani_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @fin_sum_us  = VendasFinanca.sum(:cota_dolar_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )
      @venci           = VendasFinanca.last(:data_cota_01,:conditions => ['venda_id = ? AND tipo = 1',params[:id]] )       
      render :layout => false
  end


  def requerimento_ordem_servico                          #
      @venda           = Venda.find(params[:id])
      render :layout => false
  end


  def comprovante_fatura_pendentes         #
      @vendas = Venda.find(params[:paras])
      @venda_produto      = VendasProduto.all(:total_dolar,:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_gs     = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_iva5   = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 5  and venda_id = ?',params[:id]] )
      @produto_sum_iva10  = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 10 and venda_id = ?',params[:id]] )
      @produto_sum_iva80  = VendasProduto.sum(:iva_guarani,:conditions => ['taxa = 80 and venda_id = ?',params[:id]] )
      @produto_total_iva  = @produto_sum_iva5 + @produto_sum_iva10
      render :layout => false
  end

  def fatura                               #
      @venda                = Venda.find(params[:id])
      @venda_produto        = VendasProduto.all(:conditions => ['venda_id = ?',params[:id]],:order => 'id' )
      @produto_sum_dolar    = VendasProduto.sum(:total_dolar,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_guarani  = VendasProduto.sum(:total_guarani,:conditions => ['venda_id = ?',params[:id]] )
      @produto_sum_iva10_us = VendasProduto.sum('iva_dolar * quantidade' ,:conditions => ['taxa = 10 AND venda_id = ?',params[:id]] )
      @produto_sum_iva10_gs = VendasProduto.sum('iva_guarani * quantidade' ,:conditions => ['taxa = 10 AND venda_id = ?',params[:id]] )
      @produto_sum_iva05_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ['taxa = 5 AND venda_id = ?',params[:id]] )
      @produto_sum_iva05_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['taxa = 5 AND venda_id = ?',params[:id]] )
      @produto_sum_iva80_us = VendasProduto.sum('iva_dolar * quantidade',:conditions => ['taxa = 80 AND venda_id = ?',params[:id]] )
      @produto_sum_iva80_gs = VendasProduto.sum('iva_guarani * quantidade',:conditions => ['taxa = 80 AND venda_id = ?',params[:id]] )
      @form                 = Form.find(:first,:select => 'form_venda_fatura')

      render :layout => false
  end

  def index                                #
      respond_to do |format|
          format.html { render :layout => 'application'}
      end
  end

  def busca_vendas                         #
      @vendas = Venda.filtro_vendas(params)
      respond_to do |format|
          format.html { render :layout => false}
      end
  end

  def show                                 #
      @venda = Venda.find(params[:id])
      @vp  =  VendasProduto.find_all_by_venda_id(params[:id],:select =>'id,moeda,lotes,fabricante_cod,deposito_nome,produto_nome,quantidade,unitario_dolar,total_dolar,unitario_guarani,total_guarani,total_desconto,iva_dolar,iva_guarani',:order => 'id')        
      @total_produto     =  VendasProduto.sum(:quantidade,    :conditions => ['venda_id = ?',params[:id]])
      @total_dolar       =  VendasProduto.sum(:total_dolar,   :conditions => ['venda_id = ?',params[:id]])
      @total_guarani     =  VendasProduto.sum(:total_guarani, :conditions => ['venda_id = ?',params[:id]])
      @total_real        =  VendasProduto.sum(:total_real, :conditions => ['venda_id = ?',params[:id]])

      render :layout => 'layout_vendas'
  end

  def visualizacao                                 #
      @venda = Venda.find(params[:id])
      @vp    =  VendasProduto.find_all_by_venda_id(params[:id],:select =>'id,moeda,fabricante_cod,deposito_nome,produto_nome,quantidade,unitario_dolar,total_dolar,unitario_guarani,total_guarani,total_desconto,iva_dolar,iva_guarani',:order => 'id')        
      @vfc   =  VendasFinanca.find_all_by_venda_id(params[:id], :conditions => ['tipo = 0'])

      @vfcr  =  VendasFinanca.find_all_by_venda_id(params[:id], :conditions => ['tipo = 1'])

      render :layout => 'vendas'
  end

  def new                                  #
      @venda = Venda.new
      render :layout => 'vendas'
  end

  def new_balcao                                  
      empresa = Empresa.last
      ctz     = Moeda.last(:order => "data, id")

      @venda = Venda.new( :persona_id   => empresa.venda_persona_id, 
                          :persona_nome => empresa.venda_persona_nome,
                          :moeda        => empresa.venda_moeda,
                          :data         => Time.now,
                          :tipo_maiorista => 0,
                          :cotacao      => ctz.dolar_compra.to_f,
                          :cotacao_real => ctz.real_compra.to_f, 
                          :pedido_id => 0)
      @venda.save
      redirect_to(@venda) 
  end


  def edit                                 #
      @venda = Venda.find(params[:id])
      render :layout => 'vendas'
      session[:pagina] = '1'
  end

  def create                               #
      @venda = Venda.new(params[:venda])

      respond_to do |format|
          if @venda.save
              @venda.usuario_created = current_user.usuario_nome
              @venda.unidade_created = current_unidade.unidade_nome
              flash[:notice] = 'Insira los Productos'
              format.html { redirect_to(@venda) }
              format.xml  { render :xml => @venda, :status => :created, :location => @venda }
          else
              format.html { render :action => "new" }
              format.xml  { render :xml => @venda.errors, :status => :unprocessable_entity }
          end
      end
  end

  def update                               #
      @venda = Venda.find(params[:id])

      respond_to do |format|
          if @venda.update_attributes(params[:venda])
              @venda.usuario_updated = current_user.usuario_nome
              @venda.unidade_updated = current_unidade.unidade_nome
              
              if session[:pagina] == '1'
                 format.html { redirect_to(@venda) }
              else
                 format.html { redirect_to('/vendas/new_balcao') }
               end
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @venda.errors, :status => :unprocessable_entity }
          end
      end
  end

  def destroy                              #
      @venda = Venda.find(params[:id])
      @venda.destroy

      respond_to do |format|
          format.html { redirect_to(vendas_url) }
          format.xml  { head :ok }
      end
  end
end
