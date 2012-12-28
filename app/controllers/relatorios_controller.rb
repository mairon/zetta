class RelatoriosController < ApplicationController

    def get_produto                                 #
        @produto =  Produto.find(:first, :conditions =>  [ "cod_velho = ?", params[:campo_produto]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_produto').value                = '#{@produto.id.to_i}';
                            </script>"
    end

    
    def resultado_fechamento_caixa                  #

        vendedor = "AND VENDEDOR_ID = #{params[:busca]['vendedor']}" unless  params[:busca]['vendedor'].blank?
        conta    = "AND CONTA_ID = #{params[:busca]['conta']}" unless  params[:busca]['conta'].blank?        
        if params[:moeda].to_s == '0'
          moeda = 'AND MOEDA = 0'
        else  
          moeda = 'AND MOEDA = 1'
        end
        @gastos_contado          = ComprasFinanca.all( :conditions => ["data >= ? AND data <= ? AND tipo = 0 AND tipo_compra = 1  #{conta} #{moeda}",params[:inicio],params[:final]] )
        @gastos_credito          = ComprasFinanca.all( :conditions => ["data >= ? AND data <= ? AND tipo = 1 AND tipo_compra = 1 #{conta} #{moeda}",params[:inicio],params[:final]] )        
        @vendas_contado          = Venda.all( :conditions => ["data >= ? AND data <= ? AND tipo = 0  #{vendedor} #{conta} #{moeda}",params[:inicio],params[:final]] )
        @vendas_contado          = Venda.all( :conditions => ["data >= ? AND data <= ? AND tipo = 0  #{vendedor} #{conta} #{moeda}",params[:inicio],params[:final]] )        
        @vendas_credito          = Venda.all( :conditions => ["data >= ? AND data <= ? AND tipo = 1 #{vendedor} #{conta} #{moeda}",params[:inicio],params[:final]] )
        @cobros                  = CobrosFinanca.all( :conditions => ["data >= ? AND data <= ? AND data = diferido #{conta} #{moeda}",params[:inicio],params[:final]] )
        @cobros_diferido         = CobrosFinanca.all( :conditions => ["data >= ? AND data <= ? AND data != diferido #{conta} #{moeda}",params[:inicio],params[:final]] )
        @financas_anterior = Financa.relatorio_financas_saldo_anterior(params)

        conta = Conta.find_by_id(params[:busca]["conta"])


        head =
        "                                                                             #{$empresa_nome}
                                                                                         CIERRE DE CAJA
- Fecha : #{params[:inicio]} hasta #{params[:final]}
- Cuenta : #{conta.nome}    

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.     Fecha               Vendedor             Cliente                                   Factura                                Cantidad             Total Gs.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_fechamento_caixa",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_vendas                            #

        vendedor = "AND VENDEDOR_ID = #{params[:busca]['vendedor']}" unless  params[:busca]['vendedor'].blank?
        cli      = "AND PERSONA_ID = #{params[:busca]['cliente']}" unless  params[:busca]['cliente'].blank?
        moeda    = "AND MOEDA = #{params[:moeda]}" unless  params[:moeda].blank?


        if params[:clase_produto] == "2"
            set      = ""
        else 
            set      = "AND clase_produto = #{params[:clase_produto]}" unless  params[:clase_produto].blank?
        end
        find_setor = Setor.find_by_id(params[:clase_produto])
        @vendas_contado          = Venda.all( :conditions => ["data BETWEEN ? AND ? AND tipo = 0 #{vendedor} #{moeda} #{cli} #{set} ",params[:inicio],params[:final]],:order => 'data' )
        @vendas_credito          = Venda.all( :conditions => ["data BETWEEN ? AND ? AND tipo = 1 #{vendedor} #{moeda} #{cli} #{set}",params[:inicio],params[:final]],:order => 'data' )

        if params[:moeda].to_s == '0'
            moeda = 'DOLAR'
        elsif params[:moeda].to_s == '1'
            moeda = 'GUARANI'        
        else
            moeda = 'REAIS'        
        end 

    head =
        "                                                   #{$empresa_nome}
                                                        Listado de Ventas
- Fecha...: #{params[:inicio]} hasta #{params[:final]}
- Secto...: #{find_setor.nome}
- Moneda..: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
   Lanz.      Fecha      Vendedor             Cliente                            Factura           Tipo            Cantidad         Total
-----------------------------------------------------------------------------------------------------------------------------------------
"


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_vendas",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_historico_precos                  #


        @historico_preco          = Relatorios.historico_precos(params)

        head =
        "                                                                                       #{$empresa_nome}
                                                                                      Historico de Precios
    Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Fecha                 Cod.                                     Produto                                                                       Precio Gs.          Precio U$.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_historico_precos",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_tabela_preco                      #

        if params[:inf].to_s == "0"
            if params[:moeda].to_s == "0"
                titulo = 'Final Gs.       1 Gs.                          Obs.'
            elsif params[:moeda].to_s == "1"
                titulo = 'Final Gs.       1 U$.                          Obs.'
            else
                titulo = 'Final Gs.   U$.        1 Gs.      U$.                 Obs.'
            end
        elsif params[:inf].to_s == "1"
            if params[:moeda].to_s == "0"
                titulo = '            12x Gs.                          Obs.'
            elsif params[:moeda].to_s == "1"
                titulo = '            7x U$.                          Obs.'
            else
                titulo = '            7x Gs.      U$.                 Obs.'
            end

        elsif params[:inf].to_s == "2"
            if params[:moeda].to_s == "0"
                titulo = '            12x Gs.                          Obs.'
            elsif params[:moeda].to_s == "1"
                titulo = '            12x U$.                          Obs.'
            else
                titulo = '            12x Gs.      U$.                Obs.'
            end

        else
            if params[:moeda].to_s == "0"
                titulo = '          Final Gs.           7xGs.       12x Gs.                   Obs.'
            elsif params[:moeda].to_s == "1"
                titulo = '          Final U$.       	 7xU$.       12x U$.                  Obs.'
            else
                titulo = '          Final Gs.     U$.     7x Gs.    U$       12x Gs.    U$.              Obs.'
            end
        end
        if params[:stock].to_s == "0"
            saldo = "Saldo"
        end
        @tabela_preco          = Relatorios.tabela_preco(params)

        head =
        "                                                                                                      #{$empresa_nome}
                                                                                                               Tabla de Precio


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        Cod.                        Producto                                                                               Desc.       #{saldo}    #{titulo}
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_tabela_preco",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_remicao                           #


        @remicao             = Relatorios.remicao(params)


        head =
        "                                                                                       #{$empresa_nome}
                                                                                       Nota de Remicion
    Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                         Cod.                 Producto                                              Cantidad           Costo           Total       Precio Venta    Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_remicao",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end

    end

    def resultado_cheque_diferido                   #


        @cheque_diferido             = Relatorios.cheque_diferido(params)
        if params[:cheque].to_s == '0'
            cheque = 'A Depositar'
        elsif params[:cheque].to_s == '1'
            cheque = 'Depositado'
        else
            cheque = 'Todos'
        end

        if params[:moeda].to_s == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end


        head =
        "                                                                                                        #{$empresa_nome}
                                                                                                      Cheques Diferidos
    - Fecha   : #{params[:inicio]} hasta #{params[:final]}
    - Cheque : #{cheque}
    - Moneda : #{moeda}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Emicion   Diferido    Deposito          Nombre                        Cuenta            Titula            Banco              N. Cheque    Entrada   Salida    Saldo
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_cheque_diferido",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_gastos                            #
    
        if params[:moeda] == '0'
           moeda  = 'DOLAR'
        else
           moeda  = 'GUARANIES'        
        end

        
        if params[:tipo_gasto].to_s == '0'
           gasto  = 'Legal'
        elsif params[:tipo_gasto].to_s == '1'
           gasto  = 'Legal Revertido'
        elsif params[:tipo_gasto].to_s == '2'
           gasto  = 'Comun'
        elsif params[:tipo_gasto].to_s == '3'           
           gasto  = 'Comun Revertido'                                     
        else           
           gasto  = 'Todos'
        end 
           
        if params[:busca]["rodados"] != ''
           rd = Rodado.last(:conditions => ["id = #{params[:busca]["rodados"]}"]) 
        end
        
        @gastos = Relatorios.gastos(params)
        if params[:tp] == "0" or params[:tp] == "2" 
        head =
        "                                                                                   #{$empresa_nome}
                                                                                                 Gastos
  - Fecha...: #{params[:inicio]} hasta #{params[:final]} Unidad..:#{params[:busca]['unidade']}
  - Moneda.: #{moeda}
  - Tipo....: #{gasto}
  - Rodado...: #{rd.placa unless params[:busca]["rodados"].blank? }
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Lanz. Unidad  Fecha   Nombre                                      Rubro                                                          Doc.             Rodado         Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "
       else


        head =
        "                                                                                          #{$empresa_nome}
                                                                                                 Gastos Por Rubros
  - Fecha  : #{params[:inicio]} hasta #{params[:final]}
  - Moneda : #{moeda}
  - Tipo   : #{gasto}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   Cod.                                Rubro                                                                                                                                            Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "
        end

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_gastos",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_compras                           #
    
    if params[:clase_produto] == '0'
       clase = 'REPUESTOS'
    elsif params[:clase_produto] == '1'  
       clase = 'MAQUINARIOS'
    elsif params[:clase_produto] == '2'         
       clase = 'REPUESTOS/MAQUINARIOS'    
    else
       clase = 'TODOS'    
    end   
    
    if params[:tipo_compra] == '0'
       tipo = 'COMPRA MERCADERIAS'
    elsif params[:tipo_compra] == '2'
       tipo = 'COMPRA MERCADERIAS IMPORTACION'
    elsif params[:clase_produto] == '3'         
       tipo = 'COMPRA DE BIENS'    
    end   
    
        @compras = Relatorios.compras(params)
        head =
        "                                                                                        #{$empresa_nome}
                                                                                                 Compras
  - Fecha : #{params[:inicio]} hasta #{params[:final]}
  - Clase : #{clase}
  - Tipo  : #{tipo}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Fecha                            Proveedor                                                                      Doc.                                Cant.                Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_compras",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_cobros                            #
        @cobros = Relatorios.cobros(params)
        head =
        "                                                                                   #{$empresa_nome}
                                                                                                 Cobros
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Cod.           Fecha                           Vend                                             Nombre                                         Doc.                   Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_cobros",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end



    def resultado_pagos                            #
        @cobros = Relatorios.pagos(params)
        head =
        "                                                                                                   #{$empresa_nome}
                                                                                                  Pagos
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.     Fecha    taRecibo  Nombre                                                Desc.                    Interes                    Valor                                Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "
  
    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_pagos",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_resumo_mes                            #
        head =
        "                                                                                          #{$empresa_nome}
                                                                                  Resumen Del Mes
  - Mes : #{params[:mes]} de #{params[:ano]}




        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_resumo_mes",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end



    def resultado_consumicao_interna                   #
      
        vendedor    = "AND vendedor_id = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
        @consumicao = ConsumicaoInterna.all(:conditions => ["DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{vendedor}"])
        head =
        "                                                                                   #{$empresa_nome}
                                                                                                 Consumicion Interna
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       Cod.               Fecha                 Vendedor                       Concepto.                       Cantidad                                            Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_consumicao_interna",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end




    def resultado_comissoes                  #
      empl  = "AND ID = #{params[:busca]['empregado']}" unless params[:busca]['empregado'].blank? 
      @empl = Persona.all(:select => 'id,nome,comissao', :conditions => ["tipo_funcionario = 1 #{empl}"])
      @form = Form.first(:select => 'rl_comissao')
      
        head =
        "                                                                                   #{$empresa_nome}
                                                                                         Comision
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.        Empleado                                                                        Ventas      Cobro        Adel.        Devoluc.  Comision %    Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_comissoes",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end

    def resultado_folha_de_pagamento                  #
      @sueldo = Relatorios.sueldo(params)
      
        head =
        "                                                                                   #{$empresa_nome}
                                                                               Hoja de Pago
  - Fecha : #{params[:mes]} hasta #{params[:ano]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.        Empleado                                                                                          Debe                   Haber                   Saldo
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_folha_de_pagamento",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end


    def resultado_adelantos                  #
      @adelantos = Relatorios.adelantos(params)
      
        head =
        "                                                                                                           #{$empresa_nome}
                                                                                                          Adelantos 
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.     Fecha                 Persona                                            Concepto                               Cuenta                       Cheque          Credito         Debito
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_adelantos",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end




    def resultado_controle_func                  #
      @fx_emp = Relatorios.controle_func(params)
      
        head =
        "                                                                                                           #{$empresa_nome}
                                                                                                          Fluxo de Empleados 
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Cod.     Fecha Entrada Fecha Salida     Ob.        Resp.                                            Empleado                                      Status   Concepto
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_controle_func",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end






    def resultado_pedidos_vendas                  #
      @pedidos_vendas = Relatorios.pedidos_vendas(params)
     if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
     elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'        
    else
      moeda = 'REAIS'        
     end 

     if params[:status].to_s == '0'
      filtro = 'Solo En Abertas'
     elsif params[:status].to_s == '1'
      filtro = 'Solo Facturados'        
     elsif params[:status].to_s == '2'
      filtro = 'Solo Cancelados'        
     else 
      filtro = 'Todos'        
     end 
      
    head =
        "                                                   #{$empresa_nome}
                                                        Listado Pedido de Ventas
- Fecha....: #{params[:inicio]} hasta #{params[:final]}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
  Lanz.    Doc.     Fecha     Prazo Entr.  Vend.          Cliente                                     Status        Cantidad        Total
-----------------------------------------------------------------------------------------------------------------------------------------
"

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_pedidos_vendas",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end
def resultado_controle_visitas
    @visitas = Relatorios.controle_visitas(params)
      
    head =
        "                                                   #{$empresa_nome}
                                                        Listado de Visitas
- Fecha....: #{params[:inicio]} hasta #{params[:final]}

-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha     Prox. Visi.    Dias     Consultor                     Cliente                     Servicio                           NC
-----------------------------------------------------------------------------------------------------------------------------------------
"

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_pedidos_vendas",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.20in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :left       => head,
                            :spacing    => 25},
                :footer => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,
                            :right      => "Pagina [page] de [toPage]",
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
    end
end
