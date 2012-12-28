class StocksController < ApplicationController
    def get_clase                                  #
        @clase =  Clase.find(:first, :conditions =>  [ "id = ?", params[:campo_clase]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_clase').value                = '#{@clase.id.to_i}';
                            </script>"
    end

    def get_moeda                                  #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('stock_cotacao').value       = '#{format("%.2f",@moeda.dolar_venda.to_f)}';
                            </script>"
    end

    def get_grupo                                  #
        @grupo =  Grupo.find(:first, :conditions =>  [ "id = ?", params[:campo_grupo]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_grupo').value                = '#{@grupo.id.to_i}';
                            </script>"
    end

    def get_produto                                #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:campo_produto]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_produto').value                = '#{@produto.id.to_i}';
                            </script>"
    end

    def get_produto_inicial                        #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:cod]])
        
        return render :text => "<script type='text/javascript'>
                                document.getElementById('stock_produto_id').value             = '#{@produto.id.to_i}';
                                document.getElementById('stock_taxa').value                   = '#{@produto.taxa.to_i}';
                            </script>"
    end

    def relatorio_consumo_bomba                    #

        respond_to do |format|
            format.html # show.html.erb
        end
    end
  
    def resultado_relatorio_consumo_bomba          #
        cond = "data >= '#{params[:inicio]}' AND data <= '#{params[:final]}' AND tipo = 1"
        cond = cond + " AND turno_created = #{params[:busca]["turno"]}" if params[:busca]["turno"].to_s != ""
        cond = cond + " AND produto_id = #{params[:busca]["bomba"]}" if params[:busca]["bomba"].to_s != ""
        @stocks = Stock.all(:conditions => cond, :order => 'status,data')
        respond_to do |format|
            format.html # show.html.erb
            format.xls  { render :action => "resultado_relatorio_consumo_bomba", :layout => false }
            format.pdf  { render :action => "resultado_relatorio_consumo_bomba", :layout => false }
        end

    end

    def index                                      #

        respond_to do |format|
            format.html # show.html.erb
        end
    end

    def stock_inicial                              #

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @diarios }
        end
    end

    def dinamic_busca_stock_inicial                #

        @stocks = Stock.resultaro_stock_inicial(params)
    
        render :layout => false
    end

    def relatorio_stock                            #

        #VERIFICA SE  TEM CLASE E IMPRIME
        if params[:busca]["clase"].blank?
            clase = 'Todos'
        else
            clase = params[:busca]["clase"]
        end
        #VERIFICA SE  TEM GRUPO E IMPRIME
        if params[:busca]["grupo"].blank?
            grupo = 'Todos'
        else
            grupo = params[:busca]["grupo"]
        end

        #VERIFICA SE  TEM PRODUTO E IMPRIME
        if params[:busca]["produto"].blank?
            produto = 'Todos'
        else
            produto = params[:busca]["produto"]
        end

        #VERIFICA SE  TEM DEPOSITO E IMPRIME
        if params[:busca]["deposito"].blank?
            deposito = 'Todos'
        else
            deposito = params[:busca]["deposito"]
        end

        if params[:status].to_s == '0'
            @stocks = Stock.ficha_stock_resumido(params)
            @saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )

            head =
            "                                                                                                         #{$empresa_nome}
                                                                                                                            FICHA STOCK
    Fecha : #{params[:inicio]} hasta #{params[:final]}
    Clase : #{clase}   Grupo : #{grupo}  Produto : #{produto}   Deposito : #{deposito}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   Lanz.    Fecha         Persona                              Deposito       Producto                                                                                    Unit Tot. Entrada Tot. Salida    Entrada        Salida        Saldo
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            "

        else
            @stocks = Stock.relatorio_ficha_stock(params)
            @saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )
    head =
             "                                                                                                     #{$empresa_nome}
                                                                                                                            FICHA STOCK
    Fecha : #{params[:inicio]} hasta #{params[:final]}
    Clase : #{clase}   Grupo : #{grupo}  Produto : #{produto}   Deposito : #{deposito}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Cod.  Fecha   Deposito                                Producto                                       Entrada   Salida   Saldo       Unit.           Costo          Tot. Entr.       Tot. Salida     Tot. Stock
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
"

        end


    respond_to do |format|
      format.html do
        render  :pdf                    => "relatorio_stock",                
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

    def resultado_iventario                        #
    
        @stocks = Stock.resultaro_iventario( params )


        head =
        "                                                                                    #{$empresa_nome}
                                                                                       Iventario


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Cod.                      Productos                                                                            Saldo   Unit. Gs.   Total Gs.    Unit. U$   Total. U$
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

        head_consulta =
        "                                                                                    #{$empresa_nome}
                                                                                       Iventario


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Cod.                      Productos                                                                            Saldo                      Observacion
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_iventario",                
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

    def resultado_rentabilidade                    #
		if params[:modelo] == "0"
        @stocks = Stock.rentabilidade( params )


        head =
        "                                                                                    #{$empresa_nome}
                                                                                       Rentabilidad

-Fecha #{params[:inicio]} Hasta #{params[:final]}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Cod.                      Productos                                                                     Cantidad     Venta         Costo         Renta.   Margen%
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "


		else
        @stocks = Stock.rentabilidade_detalhado( params )


        head =
        "                                                                                    #{$empresa_nome}
                                                                                       Rentabilidad

-Fecha #{params[:inicio]} Hasta #{params[:final]}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Cod.                      Productos                                                                     Cantidad     Venta         Costo         Renta.   Margen%
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

		end

        respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_rentabilidade",                
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

    def relatorio_stock_print                      #
        cond = "data >= '#{params[:inicio]}' AND data <= '#{params[:final]}'"
        cond = cond + " AND produto_id = #{params[:busca]["produto"]}" if params[:busca]["produto"].to_s != ""
        cond = cond + " AND produto_id = #{params[:busca]["clase"]}" if params[:busca]["clase"].to_s != ""
        cond = cond + " AND produto_id = #{params[:busca]["grupo"]}" if params[:busca]["grupo"].to_s != ""
        @stocks = Stock.all(:conditions => cond, :order => 'status,data')
        render :layout => false
    end

    def show                                       #
        @stock = Stock.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @stock }
        end
    end

    def new                                        #
        @stock = Stock.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @stock }
        end
    end

    def edit                                       #
        @stock = Stock.find(params[:id])
    end

    def create                                     #
        @stock = Stock.new(params[:stock])

        #USUARIO UNIDADE
        @stock.usuario_created = current_user.id
        @stock.unidade_created = current_unidade.id

        respond_to do |format|
            if @stock.save
                flash[:notice] = 'Grabado con Sucesso'
                format.html { redirect_to('/stocks/stock_inicial') }
                format.xml  { render :xml => @stock, :status => :created, :location => @stock }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                                     #
        @stock = Stock.find(params[:id])

        #USUARIO UNIDADE
        @stock.usuario_updated = current_user.id
        @stock.unidade_updated = current_unidade.id

        respond_to do |format|
            if @stock.update_attributes(params[:stock])
                flash[:notice] = 'Actulizado con Sucesso'
                format.html { redirect_to('/stocks/stock_inicial') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                                    #
        @stock = Stock.find(params[:id])
        @stock.destroy

        respond_to do |format|
            format.html { redirect_to('/stocks/stock_inicial') }
            format.xml  { head :ok }
        end
    end
end
