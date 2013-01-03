class FechamentoCaixasController < ApplicationController
  before_filter :authenticate

    def get_moeda               #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('fechamento_caixa_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def print               #
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
     
        pdf = render :layout => 'layer_relatorios'
        kit = PDFKit.new(pdf,:page_size     => 'A4',
            :print_media_type  => true,
            :header_font_name  => 'bold',
            :header_font_size  => "9" ,
            :header_spacing    => "0",
            :footer_font_size  => "7",
            :footer_right  => "Pagina [page] de [toPage]",
            :footer_left   => "MercoSys Enterprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
            :margin_top    => '0.20in',
            :margin_bottom => '0.25in',
            :margin_left   => '0.10in',
            :margin_right  => '0.10in')
        kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
        send_data(kit.to_pdf, :filename => "producto#{@pd.id}.pdf")        

    end


  def index
    @fechamento_caixas = FechamentoCaixa.all(:order => "data,id")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fechamento_caixas }
    end
  end

  def show
    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fechamento_caixa }
    end
  end

  def new
    @fechamento_caixa = FechamentoCaixa.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fechamento_caixa }
    end
  end

  def edit
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
  end

  def create
    @fechamento_caixa = FechamentoCaixa.new(params[:fechamento_caixa])
    respond_to do |format|
      if @fechamento_caixa.save
        format.html { redirect_to(@fechamento_caixa, :notice => 'FechamentoCaixa was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @fechamento_caixa = FechamentoCaixa.find(params[:id])

    respond_to do |format|
      if @fechamento_caixa.update_attributes(params[:fechamento_caixa])
        format.html { redirect_to(@fechamento_caixa, :notice => 'FechamentoCaixa was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @fechamento_caixa = FechamentoCaixa.find(params[:id])
    @fechamento_caixa.destroy

    respond_to do |format|
      format.html { redirect_to(fechamento_caixas_url) }
    end
  end
end
