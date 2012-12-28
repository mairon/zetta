class FinancasController < ApplicationController

  respond_to :html, :pdf

  def relatorio_financas          #

    @financas         = Financa.relatorio_financas(params)
    @financas_anterior = Financa.relatorio_financas_saldo_anterior(params)

    if params[:moeda] == '0'
      moeda = 'Dolar'
    elsif params[:moeda] == '1'
      moeda = 'Guaranies'
    else
      moeda = 'Reais'
    end
    conta = Conta.find_by_id(params[:busca]["conta"])
    head =
"                                                   #{$empresa_nome}
                                                              EXTRACTO CAJA
- Fecha...: #{params[:inicio]} hasta #{params[:final]}
- Cuenta..: #{conta.nome}    
- Moneda..: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
    Fecha    Concepto                                                                    N. Cheque       Credito      Debito       Saldo
-----------------------------------------------------------------------------------------------------------------------------------------

"

    respond_to do |format|
      format.html do
        render  :pdf                    => "relatorio_financas",                
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

  def index                       #
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @financas }
    end
  end

  def extrato_bancario            #
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @financas }
    end
  end

  def resultado_extrato_bancario  #

    @financas         = Financa.relatorio_financas(params)
    @financas_anterior = Financa.relatorio_financas_saldo_anterior(params)
    if params[:filtro] == '1'
      @lanz_futuros = Financa.lanz_futuros_extr_bc(params)
    end 

    if params[:moeda] == '0'
      moeda = 'Dolar'
    elsif params[:moeda] == '1'
      moeda = 'Guaranies'
    else
      moeda = 'Reais'
    end

    conta = Conta.find_by_id(params[:busca]["conta"])
    head =
"                                                          #{$empresa_nome}
                                                          EXTRACTO BANCARIO
- Fecha.....: #{params[:inicio]} hasta #{params[:final]}
- Cuenta....: #{conta.nome}    
- Moneda....: #{moeda}
-----------------------------------------------------------------------------------------------------------------------------------------
  Fecha         Concepto                                                              N. Cheque       Credito        Debito        Saldo
-----------------------------------------------------------------------------------------------------------------------------------------
"

    respond_to do |format|
      format.html do
        render  :pdf                    => "resultado_extrato_bancario",                
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

  def show                        #
    @financa = Financa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @financa }
    end
  end
end
