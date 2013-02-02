class RelatoriosController < ApplicationController

    def get_produto                                 #
        @produto =  Produto.find(:first, :conditions =>  [ "cod_velho = ?", params[:campo_produto]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_produto').value                = '#{@produto.id.to_i}';
                            </script>"
    end

    def resultado_relatorio_fechamento_turno        #
        @fechamento_turnos = Relatorios.fechamento_turno(params)

        head =
        "                                                                                    #{$empresa_nome}
                                                                                       Cierre de Turno
    Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Fecha             Turno                                                                 Inicio                                       Cierre                                    Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Pratic - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')

            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Cierre_Turno.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Cierre_Turno.xls')
                }
            end
        end

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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Cierre_Caja.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Cierre_Caja.xls')
                }
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


        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_size  => "7" ,
                :header_spacing    => "25",
                :header_left       => head,
                :header_font_name  => 'Lucida Console, Courier, Monotype, bold',
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Ventas.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Ventas.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Historico_Preco.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Historico_Preco.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "7" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Tabela_Preco.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Tabela_Preco.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Remicao.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Remicao.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "8" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Cheque_Diferido.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_cheque_diferido", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Cheque_Diferido.xls')
                }
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
            @group_setores = Relatorios.agrupado_setor(params)
        head =
        "                                                      #{$empresa_nome}
                                                          Gastos
  - Fecha...: #{params[:inicio]} hasta #{params[:final]} Unidad..:#{params[:busca]['unidade']}
  - Moneda..: #{moeda}
  - Tipo....: #{gasto}
  - Rodado..: #{rd.placa unless params[:busca]["rodados"].blank? }
-----------------------------------------------------------------------------------------------------------------------------------------
  Lanz. Unid. Sect.   Fecha   Nombre                          Rubro                                 Doc.        Rodado    Ctd.      Total
-----------------------------------------------------------------------------------------------------------------------------------------
        "
       else


    head =
        "                                                   #{$empresa_nome}
                                                        Gastos Por Rubros
- Fecha....: #{params[:inicio]} hasta #{params[:final]}
- Moneda...: #{moeda}
- Tipo.....: #{gasto}
-----------------------------------------------------------------------------------------------------------------------------------------
  Cod      Rubro                                                                                         Total   Transf.   Cred.     Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"


        end
        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_size  => "7" ,
                :header_spacing    => "25",
                :header_left       => head,
                :header_font_name  => 'Lucida Console, Courier, Monotype, bold',
                :footer_font_size  => "7",                
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.30in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Gastos.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "relatorio_stock", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Remicao.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Compras.pdf")




        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_compras", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Compras.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Cobros.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_cobros", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'resultado_cobros.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "8" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Pagos.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_cobros", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'resultado_cobros.xls')
                }
            end
        end
    end



    def resultado_resumo_mes                            #
        head =
        "                                                                                          #{$empresa_nome}
                                                                                  Resumen Del Mes
  - Mes : #{params[:mes]} de #{params[:ano]}




        "

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "20",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.00in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Resume_mes.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_resumo_mes", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'resultado_resumo_mes.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Consumicao_interna.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_consumicao_interna", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Consumicao_interna.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",

                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "comision.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_consumicao_interna", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'comision.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "comision.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_consumicao_interna", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'comision.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "8" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "adelantos.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_adelantos", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'adelantos.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "8" ,
                :header_spacing    => "25",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Fluxo_Empleados.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_adelantos", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'Fluxo_Empleados.xls')
                }
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

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_size  => "7" ,
                :header_spacing    => "25",
                :header_left       => head,
                :header_font_name  => 'Lucida Console, Courier, Monotype, bold',
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '1.20in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "List_Pedido_Venda.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_pedidos_vendas", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'List_Pedido_Venda.xls')
                }
            end
        end
    end


    def resultado_egressos                  #
      @egressos = Relatorios.egressos(params)
     if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
     elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'        
    else
      moeda = 'REAIS'        
     end 

    head =
        "                                                   #{$empresa_nome}
                                                        Listado de Egressos
- Fecha....: #{params[:inicio]} hasta #{params[:final]}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  Fecha  Sect.Cuenta                    Rubro                         Concepto                                                Total
-----------------------------------------------------------------------------------------------------------------------------------------
"

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_size  => "7" ,
                :header_spacing    => "15",
                :header_left       => head,
                :header_font_name  => 'Lucida Console, Courier, Monotype, bold',
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '0.90in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "List_Egressos.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_pedidos_vendas", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'List_Egresso.xls')
                }
            end
        end
    end

    def resultado_ingressos
      @ingressos = Relatorios.ingressos(params)
     if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
     elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'        
    else
      moeda = 'REAIS'        
     end 

    head =
        "                                                   #{$empresa_nome}
                                                        Listado de Ingressos
- Fecha....: #{params[:inicio]} hasta #{params[:final]}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  Fecha  Sect.Cuenta                    Rubro                         Concepto                                                Total
-----------------------------------------------------------------------------------------------------------------------------------------
"

        if params[:tipo].to_s == "0"
            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_size  => "7" ,
                :header_spacing    => "15",
                :header_left       => head,
                :header_font_name  => 'Lucida Console, Courier, Monotype, bold',
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '0.90in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "List_Ingresso.pdf")

        else

            respond_to do |format|
                format.xls {
                    xls = render :action => "resultado_pedidos_vendas", :layout => false

                    kit = PDFKit.new(xls,
                        :encoding => 'UTF-8')
                    kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'

                    send_data(xls,:filename => 'List_Ingresso.xls')
                }
            end
        end
    end

end

