class PedidoComprasController < ApplicationController
  before_filter :authenticate

  def get_moeda                 #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                                  document.getElementById('pedido_compra_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
  end

   def get_codigo_barra_produto  #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

        stock = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )
        quantidade    = Stock.sum('entrada',:conditions => ["produto_id = ? AND entrada > 0 ",@produto.id])

        ultimo_custo   =  Stock.last(:conditions =>  [ "produto_id = ? AND status = 0", @produto.id]) 
        if ultimo_custo.nil?
           uc_us = 0
           uc_gs = 0
        else
           uc_us = ultimo_custo.unitario_dolar
           uc_gs = ultimo_custo.unitario_guarani
        end   
        
        return render :text => "<script type='text/javascript'>
                                  document.getElementById('pedido_compra_produto_produto_id').value             = '#{@produto.id.to_i}';
                                  document.getElementById('pedido_compra_produto_produto_nome').value           = '#{@produto.nome.to_s}';
                                  document.getElementById('pedido_compra_produto_clase_id').value               = '#{@produto.clase_id.to_i}';
                                  document.getElementById('pedido_compra_produto_grupo_id').value               = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('pedido_compra_produto_sub_grupo_id').value           = '#{@produto.sub_grupo_id.to_i}';
                                  document.getElementById('pedido_compra_produto_produto_fabricante_cod').value = '#{@produto.fabricante_cod.to_s}';                                  
                                  document.getElementById('pedido_compra_produto_unitario_dolar').value         = number_format(#{uc_us},2, ',', '.');
                                  document.getElementById('pedido_compra_produto_unitario_guarani').value       = number_format(#{uc_gs},0, ',', '.');                                

                                   if ( '#{stock}' <= 0 )
                                     {
                                      document.getElementById('red').innerHTML                             =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('green').innerHTML                           =  '' ;
                                     }
                                   else
                                     {
                                      document.getElementById('green').innerHTML                           =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('red').innerHTML                             =  '' ;
                                     }


                                </script>"
  end

  def print_pedido
    @pedido_compra = PedidoCompra.find(params[:id])
    @pcp = PedidoCompraProduto.all(:conditions => ["pedido_compra_id = ?",@pedido_compra.id])

        head =
        "                                                                                            #{$empresa_nome}
                                                                                    Pedido de Compra
        "

            pdf = render :layout => 'layer_relatorios'
            kit = PDFKit.new(pdf,:page_size     => 'A4',
                :print_media_type  => true,
                :header_font_name  => 'bold',
                :header_font_size  => "9" ,
                :header_spacing    => "9",
                :header_left       => head,
                :footer_font_size  => "7",
                :footer_right  => "Pagina [page] de [toPage]",
                :footer_left   => "MercoSys Enteprise - Fecha de la imprecion: #{Time.now.strftime("%d/%m/%Y")} Hora: #{Time.now.strftime("%H:%M:%S")} - Usuario: #{current_user.usuario_nome}",
                :margin_top    => '0.60in',
                :margin_bottom => '0.25in',
                :margin_left   => '0.10in',
                :margin_right  => '0.10in')
            kit.stylesheets << RAILS_ROOT + '/public/stylesheets/relatorios.css'
            send_data(kit.to_pdf, :filename => "Pedido_Compra_Nr_#{@pedido_compra.id}.pdf")

  end


  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def busca_pedido_compra
        @pc = PedidoCompra.filtro_busca_pedido(params)
        render :layout => false
  end

  def show
    @pedido_compra = PedidoCompra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pedido_compra }
    end
  end

  def new
    @pedido_compra = PedidoCompra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pedido_compra }
    end
  end

  def edit
    @pedido_compra = PedidoCompra.find(params[:id])
  end

  def create
    @pedido_compra = PedidoCompra.new(params[:pedido_compra])
    @pedido_compra.usuario_created = current_user.usuario_nome
    @pedido_compra.unidade_created = current_unidade.unidade_nome

    respond_to do |format|
      if @pedido_compra.save
        format.html { redirect_to(@pedido_compra, :notice => 'Grabado con Sucesso !') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @pedido_compra = PedidoCompra.find(params[:id])

    @pedido_compra.usuario_updated = current_user.usuario_nome
    @pedido_compra.unidade_updated = current_unidade.unidade_nome

    respond_to do |format|
      if @pedido_compra.update_attributes(params[:pedido_compra])
        format.html { redirect_to(@pedido_compra, :notice => 'Grabado con Sucesso !') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @pedido_compra = PedidoCompra.find(params[:id])
    @pedido_compra.destroy

    respond_to do |format|
      format.html { redirect_to(pedido_compras_url) }
    end
  end
end
