class ClientesController < ApplicationController


    def get_moeda           #
      @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
      return render :text => "<script type='text/javascript'>
                                 document.getElementById('cliente_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                              </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('cliente_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end



    def atualizacao_carpeta_cliente           #
    end


    def busca_atualizacao_carpeta_cliente           #
      
      sql = "SELECT ID,
                    DATA,
                    TABELA,
                    DOCUMENTO_NUMERO,
                    COD_PROC,
                    PERSONA_ID,
                    PERSONA_NOME,
                    COTA,
                    VENCIMENTO,
                    DIVIDA_DOLAR,
                    DIVIDA_GUARANI,
                    PAGARE          
              FROM CLIENTES
              WHERE 
              (DIVIDA_DOLAR + DIVIDA_GUARANI) > 0
              AND COTA> 0
              AND PERSONA_NOME LIKE '%#{params[:busca]}%'"
       @busca_carpeta =  Cliente.find_by_sql(sql)
       render :layout => false
    end


  def edit_carpeta                          #
    @cliente = Cliente.find(params[:id])
            session[:pagina] = 'carpeta'
  end


    def busca_cliente               #
        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              cota,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',
                                 :conditions => [" persona_id = ? AND documento_numero LIKE '%#{params[:filtro]}%' AND liquidacao != 2  AND tipo = '1'",params[:busca]],:order => 'data,venda_id,cota')

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @cobros }
        end
    end

    def filtro_busca_cliente        #
        @cobro    = Cobro.find(params[:id])
        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              cota,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',
                                 :conditions => [" persona_id = ? AND documento_numero LIKE '%#{params[:filtro]}%' AND liquidacao != 2  AND tipo = '1'",params[:busca]],:order => 'data,venda_id,cota')

    end

  def get_persona                   #
    @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:campo_persona]])
    return render :text => "<script type='text/javascript'>
                                     document.getElementById('busca_persona').value                = '#{@persona.id.to_i}';
                            </script>"
  end

  def relatorio_contas_receber      #

     if params[:moeda].to_s == '0'
      moeda = 'DOLAR'
     elsif params[:moeda].to_s == '1'
      moeda = 'GUARANI'        
    else
      moeda = 'REAIS'        
     end 

     if params[:filtro].to_s == '0'
      filtro = 'EN ABERTAS'
     elsif params[:filtro].to_s == '1'
      filtro = 'CANCELADAS'        
     else 
      filtro = 'TODOS'        
     end 
    
	if params[:inicio_faturacao] == ''
		data_ini = params[:inicio_vencimento] 
		data_fin = params[:final_vencimento] 
	else
		data_ini = params[:inicio_faturacao] 
		data_fin = params[:final_faturacao] 
	end

if params[:detalhe] == "0"
    folha = 'portrait'
	@resumo       = Cliente.contas_receber_resumido(params)

    head =
        "                                                      #{$empresa_nome}
                                                       Cuentas a Receber Por Cliente
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
Cod. Cliente                                                                            Divida        Cobrado          Saldo  Ult. Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"
elsif params[:detalhe] == "3"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_por_fatura(params)

    head =
"                                                             #{$empresa_nome}
                                                            Cuentas a Receber
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
	  Doc.    Cuota         Deudas        Cobros             			   Saldos  			            Interes 	Saldo Corrig.     Dias       		 Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"

elsif params[:detalhe] == "4"
    folha = 'portrait'
    @clientes       = Cliente.contas_receber_resumido_vencimento(params)
    head =
"                                                         #{$empresa_nome}
                                                      Cuentas a Receber Por Vencimiento
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
 Cod. Cliente                                                            Venc. Desde   Dias        Vencido          A Venc.         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

elsif params[:detalhe] == "5"
    folha = 'Landscape'
    @clientes       = Cliente.contas_receber_planilha_detalhado(params)
    head =
"                                                                                                                                                                #{$empresa_nome}
                                                                                                                                                                 Cuentas a Receber Planilha
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    Cod.    Fecha      Vendedor  Cliente     Doc.     Cod    Producto    Cant.   Venc.   Precio Total           Credito    Debito  Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

elsif params[:detalhe] == "6"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_por_fatura(params)

    head =
"                                                        #{$empresa_nome}
                                                        Extracto de Clientes
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha Fac.     Doc.    Cuota         Deudas        Cobros                    Saldos                   Dias          Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"



elsif params[:detalhe] == "7"
    folha = 'portrait'

    @clientes       = Cliente.relatorio_acerto_entre_contas(params)

    head =
"                                                    #{$empresa_nome}
                                                        Arreglo entre Contas
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha Fac.     Doc.     Cuota            Deudas       Cobro/Pago                  Saldos                  Dias          Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"

    

else
    folha = 'portrait'
   @clientes       = Cliente.relatorio_contas_receber(params)
   @saldo_anterior = Cliente.relatorio_contas_receber_saldo_anterior(params)

if params[:int].to_s == "2"
    head =
"                                                           #{$empresa_nome}
                                                            Cuentas a Receber
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
  Fecha    Vend.              Doc.             Numero       Cuota   Venc.    Dias    Int.      Con Int.     Deuda       Pago       Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"
else

    head =
"                                                          #{$empresa_nome}
                                                          Cuentas a Receber
- Fecha....: #{data_ini} hasta #{data_fin}
- Filtro...: #{filtro}
- Moneda...: #{moeda}

-----------------------------------------------------------------------------------------------------------------------------------------
  Fecha    Vend.              Doc.                    Numero        Cuota   Venc.    Dias     Deuda         Pago         Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

end


end


    respond_to do |format|
      format.html do
        render  :pdf                    => "relatorio_contas_receber",                
                :layout                 => "layer_relatorios",
                :formats => [:html],
                :user_style_sheet       => '/assets/relatorios.css',
                :show_as_html           => params[:debug].present?,
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
                            :left       => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end

  end
  
  #METHOS BASE------------------------------------------------------------------

  def index                         #
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clientes }
    end
  end

  def index_inicio                         #
    @clientes = Cliente.find(:all, :conditions => ["tabela is null"])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clientes }
    end
  end


  def show                          #
    @cliente = Cliente.find(params[:id])

    render :layout => false
  end

  def new                           #
    @cliente = Cliente.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cliente }
    end
  end

  def edit                          #
    @cliente = Cliente.find(params[:id])
    session[:pagina] = ''
  end

  def create                        #
    @cliente = Cliente.new(params[:cliente])

    respond_to do |format|
      if @cliente.save
        flash[:notice] = 'Cliente was successfully created.'
        format.html { redirect_to('/clientes/index_inicio') }
        format.xml  { render :xml => @cliente, :status => :created, :location => @cliente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update                        #
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        flash[:notice] = 'Cliente was successfully updated.'
        if session[:pagina] == 'carpeta' 
          format.html { redirect_to('/clientes/atualizacao_carpeta_cliente') }
        else 
          format.html { redirect_to('/clientes/index_inicio') }
        end     
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy                       #
    @cliente = Cliente.find(params[:id])
    @cliente.destroy

    respond_to do |format|
        format.html { redirect_to('/clientes/index_inicio') }
      format.xml  { head :ok }
    end
  end
end
