class ProveedoresController < ApplicationController
    before_filter :authenticate

  def index_inicio                         #
    @clientes = Proveedore.find(:all, :conditions => ["tabela is null"])

    respond_to do |format|
      format.html # index.html.erb
    end
  end




  def get_persona                 #
    @persona =  Persona.find(:first, :conditions =>  [ "id = ?", params[:campo_persona]])

    return render :text => "<script type='text/javascript'>

                             document.getElementById('busca_persona').value                = '#{@persona.id.to_i}';

                            </script>"
  end

  def relatorio_contas_pagar      #

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

     if params[:tipo_prov].to_s == '0'
      tp_prov = 'LOCAL'
     elsif params[:tipo_prov].to_s == '1'
      tp_prov = 'EXTERIOR'        
     else 
      tp_prov = 'TODOS'        
     end 

	if params[:inicio_faturacao] == ''
		data_ini = params[:inicio_vencimento] 
		data_fin = params[:final_vencimento] 
	else
		data_ini = params[:inicio_faturacao] 
		data_fin = params[:final_faturacao] 
	end


	if params[:detalhe] == "2"
		@resumo = Proveedore.contas_pagar_resumido(params)

    head =
        "                                                   #{$empresa_nome}
                                                        Cuentas a Pagar Resumido Por Prov.
- Fecha.....: #{data_ini} hasta #{data_fin}
- Filtro....: #{filtro}
- Moneda....: #{moeda}
- Proveedor.: #{tp_prov} 
-----------------------------------------------------------------------------------------------------------------------------------------
Cod.   Proveedor                                                                                                 Saldo      Ultimo Venci.
-----------------------------------------------------------------------------------------------------------------------------------------
"

	else

	    @proveedores = Proveedore.relatorio_contas_pagar(params)
    	@saldo_anterior = Proveedore.relatorio_contas_pagar_saldo_anterior(params)

    head =
        "                                                   #{$empresa_nome}
                                                            Cuentas a Pagar
- Fecha.....: #{data_ini} hasta #{data_fin}
- Filtro....: #{filtro}
- Moneda....: #{moeda}
- Proveedor.: #{tp_prov} 
-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha          Cod.         Doc.                         Numero        Cuota         Venc.              Deuda         Pago      Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"


	end
    
    respond_to do |format|
      format.html do
        render  :pdf                    => "relatorio_contas_pagar",                
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
                            :left       => "MercoSys Zetta - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}"}
      end
    end
  end

  #METHODS BASE ----------------------------------------------------------------

  def index                       #

    respond_to do |format|
      format.html # index.html.erb

    end
  end

  def show                        #
    @proveedore = Proveedore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proveedore }
    end
  end

  def new                         #
    @proveedore = Proveedore.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proveedore }
    end
  end

  def edit                        #
    @proveedore = Proveedore.find(params[:id])
  end

  def create                      #
    @proveedore = Proveedore.new(params[:proveedore])

    respond_to do |format|
      if @proveedore.save
        flash[:notice] = 'Proveedore was successfully created.'
          format.html { redirect_to('/proveedores/index_inicio') }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proveedore.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update                      #
    @proveedore = Proveedore.find(params[:id])

    respond_to do |format|
      if @proveedore.update_attributes(params[:proveedore])
        flash[:notice] = 'Proveedore was successfully updated.'
          format.html { redirect_to('/proveedores/index_inicio') }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proveedore.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy                     #
    @proveedore = Proveedore.find(params[:id])
    @proveedore.destroy

    respond_to do |format|
          format.html { redirect_to('/proveedores/index_inicio') }
    end
  end
end
