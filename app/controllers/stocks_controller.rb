class StocksController < ApplicationController
    def get_clase                                  #
        @clase =  Clase.find(:first, :conditions =>  [ "id = ?", params[:campo_clase]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_clase').value                = '#{@clase.id.to_i}';
                            </script>"
    end

    def get_vend                                  #
        vend =  Persona.find(:first, :conditions =>  [ "id = ?", params[:campo_vend]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_vendedor').value                = '#{vend.id.to_i}';
                            </script>"
    end

    def get_client                                  #
        per =  Persona.first(:select => 'id', :conditions =>  [ "id = ?", params[:campo_client]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_persona').value                = '#{per.id.to_i}';
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
        cotacao =  Moeda.last
        stock = Stock.sum( 'entrada - saida',:conditions => ["produto_id = ?  AND data <= '#{cotacao.data}' ",@produto.id] ) 
        suma_entrada       = Stock.sum(:entrada, :conditions => ["produto_id = #{@produto.id} AND data <= '#{cotacao.data}'"])
        suma_custo_dolar   = Stock.sum('( entrada * unitario_dolar)',   :conditions => ["produto_id = #{@produto.id} AND STATUS = 0 AND data <= '#{cotacao.data}'"])
        suma_custo_guarani = Stock.sum('( entrada * unitario_guarani )', :conditions => ["produto_id = #{@produto.id} AND STATUS = 0 AND data <= '#{cotacao.data}'"])        
        stock_custo_dolar   = ( suma_custo_dolar.to_f / suma_entrada.to_f )
        stock_custo_guarani = ( suma_custo_guarani.to_f / suma_entrada.to_f )        
        return render :text => "<script type='text/javascript'>
                                document.getElementById('stock_produto_id').value             = '#{@produto.id.to_i}';
                                document.getElementById('stock_taxa').value                   = '#{@produto.taxa.to_i}';
                                document.getElementById('saldo').value                   = '#{stock.to_f}';
                                document.getElementById('stock_unitario_dolar').value         = '#{format("%.2f",stock_custo_dolar.to_f)}';
                                document.getElementById('stock_unitario_guarani').value       = '#{stock_custo_guarani.to_i}';

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
        if params[:filtro] == '0'
            f = 'SOLO ENTRADAS'
        elsif params[:filtro] == '1'
            f = 'SOLO SALIDAS'
        else
            f = 'ENTRADA Y SALIDAS'
        end
        if params[:status].to_s == '0'
            @stocks = Stock.ficha_stock_resumido(params)
            @saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )

            head =
"                                                       #{$empresa_nome}
                                                           FICHA STOCK FISICO                                                          
 Fecha....: #{params[:inicio]} hasta #{params[:final]}
 Clase....: #{clase}   
 Grupo....: #{grupo}  
 Produto..: #{produto}   
 Deposito.: #{deposito}
 Filtro...: #{f}
-----------------------------------------------------------------------------------------------------------------------------------------
 Lanz.  Fecha    Persona             St Dep. Cod. Producto                                Unit  Tot.Entr  Tot.Sali Entrada  Salida  Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
            "

        else
            @stocks = Stock.relatorio_ficha_stock(params)
            @saldo_anterior = Stock.relatorio_ficha_stock_saldo_anterio( params )
    head =
"                                                       #{$empresa_nome}
                                                           FICHA STOCK FINANCIERO                                                          
 Fecha....: #{params[:inicio]} hasta #{params[:final]}
 Clase....: #{clase}   
 Grupo....: #{grupo}  
 Produto..: #{produto}   
 Deposito.: #{deposito}
------------------------------------------------------------------------------------------------------------------------------------------
  Lanz.  Fecha   Dep.  Produto                                Entrada Salida Saldo      Unit.     Costo    Tot.Entr. Tot.Salida Tot Stock           
------------------------------------------------------------------------------------------------------------------------------------------
"

        end


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

    def resultado_iventario                        #
    
        @stocks = Stock.resultaro_iventario( params )

        head =
        "                                                               #{$empresa_nome}
                                                        LISTADO DE IVENTARIO
Fecha..: #{params[:inicio]} Hasta #{params[:final]}

-----------------------------------------------------------------------------------------------------------------------------------------
    Cod.           Producto                                                                        Cantidad       Unitario          Total
-----------------------------------------------------------------------------------------------------------------------------------------

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

    def resultado_rentabilidade
  		if params[:modelo] == "0"
        @stocks = Stock.rentabilidade( params )


        head =
  "                                                                 #{$empresa_nome}
                                                                 Rentabilidad                                                                                                                          

  -Fecha #{params[:inicio]} Hasta #{params[:final]}
  -----------------------------------------------------------------------------------------------------------------------------------------
      Cod.           Productos                                                    Cantidad     Venta         Costo         Renta.   Margen%
  -----------------------------------------------------------------------------------------------------------------------------------------
          "


		elsif params[:modelo] == "1"

      @stocks = Stock.rentabilidade_detalhado( params )

      unless params[:busca]["produto"].blank?
          pd = Produto.find_by_id(params[:busca]["produto"], :select => 'id,nome')
          pd = pd.nome
      else
          pd = 'Todos'
      end 

      unless params[:busca]["persona"].blank?
          per = Persona.find_by_id(params[:busca]["persona"], :select => 'id,nome')
          per = per.nome
      else
          per = 'Todos'
      end 

      head =
"                                                            #{$empresa_nome}
                                                   Rentabilidad Detalhado Por Producto                                                  

 - Fecha....: #{params[:inicio]} Hasta #{params[:final]}
 - Producto.: #{pd}
 - Cliente..: #{per}
-----------------------------------------------------------------------------------------------------------------------------------------
 Fecha   Vend.             Cod.       Fab. Producto                   Tipo Cli. Desc.  Cantidad     Venta      Costo     Renta    Margen%
-----------------------------------------------------------------------------------------------------------------------------------------
        "
    else 
       @stocks = Stock.rentabilidade_agrupado_setor(params)

 head =
  "                                                                 #{$empresa_nome}
                                                                 Rentabilidad                                                                                                                          

  -Fecha #{params[:inicio]} Hasta #{params[:final]}
  -----------------------------------------------------------------------------------------------------------------------------------------
   Cod.   Productos                                                           Cantidad     Venta         Costo         Renta.   Margen%
  -----------------------------------------------------------------------------------------------------------------------------------------
          "       
		end

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


def resultado_projecao_compras

    @stocks = Stock.projecao_compras(params)              
    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_fechamento_caixa",                
                :layout                 => "layer_relatorios",
                :margin => {:top        => '1.55in',
                            :bottom     => '0.25in',
                            :left       => '0.10in',
                            :right      => '0.10in'},        
                :header => {:font_name  => 'Lucida Console, Courier, Monotype, bold',
                            :font_size  => 7,                            
                            :html => { :template => 'stocks/headers/projecao_compras.html',
                            :layout     => "layer_relatorios" },
                            :spacing    => 0},
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
                format.html { redirect_to('/stocks/new') }
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
