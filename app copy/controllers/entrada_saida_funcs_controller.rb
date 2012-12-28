class EntradaSaidaFuncsController < ApplicationController
before_filter :authenticate

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entrada_saida_funcs }
    end
  end

    def busca                         #
        @esf = EntradaSaidaFunc.filtro(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end


  def show
    @entrada_saida_func = EntradaSaidaFunc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entrada_saida_func }
    end
  end

  def relatorio
    @esf = EntradaSaidaFunc.find(params[:id])

    @esfd = EntradaSaidaFuncDetalhe.all(:conditions => ["entrada_saida_func_id = ?",@esf.id], :order => 'status,data,id')

        head =
        "                                                                                    #{$empresa_nome}
                                                                                       Control de Empleados
    Fecha : #{@esf.data.strftime("%d/%m/%Y")}
    Obra : #{@esf.produto_nome}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Fecha Entrda  Fecha Salida    Obra     Responsable                                   Empleado                                            Status          Concepto
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        "

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

  end


  def new
    @entrada_saida_func = EntradaSaidaFunc.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entrada_saida_func }
    end
  end

  def edit
    @entrada_saida_func = EntradaSaidaFunc.find(params[:id])
  end

  # POST /entrada_saida_funcs
  # POST /entrada_saida_funcs.xml
  def create
    @entrada_saida_func = EntradaSaidaFunc.new(params[:entrada_saida_func])

    respond_to do |format|
      if @entrada_saida_func.save
        format.html { redirect_to(@entrada_saida_func, :notice => 'EntradaSaidaFunc was successfully created.') }
        format.xml  { render :xml => @entrada_saida_func, :status => :created, :location => @entrada_saida_func }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entrada_saida_func.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entrada_saida_funcs/1
  # PUT /entrada_saida_funcs/1.xml
  def update
    @entrada_saida_func = EntradaSaidaFunc.find(params[:id])

    respond_to do |format|
      if @entrada_saida_func.update_attributes(params[:entrada_saida_func])
        format.html { redirect_to(@entrada_saida_func, :notice => 'EntradaSaidaFunc was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entrada_saida_func.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entrada_saida_funcs/1
  # DELETE /entrada_saida_funcs/1.xml
  def destroy
    @entrada_saida_func = EntradaSaidaFunc.find(params[:id])
    @entrada_saida_func.destroy

    respond_to do |format|
      format.html { redirect_to(entrada_saida_funcs_url) }
      format.xml  { head :ok }
    end
  end
end
