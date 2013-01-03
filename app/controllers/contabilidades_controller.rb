#!/bin/env ruby
# encoding: utf-8

class ContabilidadesController < ApplicationController

    #RELATORIOS CONTABEIS========================================================#

    def resultado_livro_compra                      #

        @compra = Contabilidade.livro_compra(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_compra",                
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

    def resultado_livro_venda                       #

    @venda = Contabilidade.livro_venda(params)
    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_venda",                
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

    def resultado_livro_diario                      #
        if params[:moeda] == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end

        head =
        "                                                       #{$empresa_nome}
                                                            LIBRO DIARIO
- Fecha..: #{params[:inicio]} Hasta #{params[:final]}
- Moneda.: #{moeda}


-----------------------------------------------------------------------------------------------------------------------------------------
  Fecha    Lanz.  Diario          Doc.         Cuenta   Concepto                                                    Debe           Haber        
-----------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_diario(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_diario",                
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

    def resultado_livro_mayor                       #

        if params[:moeda] == '0'
            moeda = 'Dolar'
        else
            moeda = 'Guaranies'
        end
        rubro_descr = PlanoDeConta.find_by_codigo(params[:codigo_inicio])
        head =
        "                                                     #{$empresa_nome}
                                                     LISTADO PRELIMINAR DEL MAYOR ANALITICO
Fecha..........: #{params[:inicio]} Hasta #{params[:final]}
Contabilidade..: #{params[:codigo_inicio]} - #{rubro_descr.descricao}
Moneda.........: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha      Lanz.    Diario        Doc.      Concepto                                               Debe          Haber         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_mayor(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_mayor",                
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


    def resultado_livro_mayor_produtos                       #

        head =
        "                                                                                    #{$empresa_nome}
                                                                                        LIBRO MAYOR
    Fecha : #{params[:inicio]} Hasta #{params[:final]}
    Contabilidade : #{params[:codigo]}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Cod.       Fecha                   Proceso               N. Proceso         	Documento                        Debe            Haber                  Saldo
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


        @diario = Contabilidade.livro_mayor_produtos(params)

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_livro_mayor_produtos",                
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



    def resultado_generar_acientos_contables        #

        @log = Contabilidade.generar_acientos_contables(params)

        render :layout => false
    end

    def resultado_balance                           #

        @balance = Contabilidade.balance(params)


        head =
        "                                                                                    #{$empresa_nome}
                                                                               Balance de Sumas y Saldos
    Fecha : #{params[:inicio]} Hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Codigo               Descripcion                                                   Anterior                    Debe                    Haber                    Saldo
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_balance",                
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

    def resultado_balance_general                   #

        @balance = Contabilidade.balance_general(params)


        head =
        "                                                                                    #{$empresa_nome}
                                                                                     Balance General
    Fecha : #{params[:inicio]} Hasta #{params[:final]}
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_balance_general",                
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


    def resultado_resumo_compra                  #
    
        @compra =   Contabilidade.resumo_compra(params)    
        head =
        "                                                                                            #{$empresa_nome}
                                                                                    Resumen de Compra
  - Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Descripcion                                           Exentas          Grav. 05           Impost. 05            Grav. 10       Impost. 10              Total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_resumo_compra",                
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


    def resultado_resumo_vendas                  #
    
        @venda =   Contabilidade.resumo_vendas(params)    
        head =
        "                                                        #{$empresa_nome}
                                                         Resumen de Vendas
- Fecha : #{params[:inicio]} hasta #{params[:final]}


-----------------------------------------------------------------------------------------------------------------------------------------
Descripcion                           Exentas           Grav. 05        Impost. 05          Grav. 10           Impost. 10          Total
-----------------------------------------------------------------------------------------------------------------------------------------
        "

        respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_resumo_vendas",                
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
