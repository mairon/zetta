class PresupuestosController < ApplicationController
    before_filter :authenticate

    def get_moeda                 #
      @moeda =  Moeda.find(:first,:select => 'dolar_compra', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('presupuesto_cotacao').value       = '#{@moeda.dolar_compra.to_i}';
                            </script>"
    end

    def get_moeda_real                 #
      @moeda =  Moeda.find(:first,:select => 'real_compra', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('presupuesto_cotacao_real').value       = '#{@moeda.real_compra.to_i}';
                            </script>"
    end


    def get_cliente               #
        @cliente =  Persona.find(:first, :conditions =>  [ "id = ?", params[:persona_busca]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('presupuesto_persona_nome').value       = '#{@cliente.nome.to_s}';
                              document.getElementById('presupuesto_persona_id').value         = '#{@cliente.id.to_i}';
                              document.getElementById('presupuesto_ruc').value                = '#{@cliente.ruc.to_s}';
                              document.getElementById('presupuesto_tipo_maiorista').value     = '#{@cliente.tipo_maiorista.to_i}';
                              document.getElementById('presupuesto_classificacao').value      = '#{@cliente.classificacao.to_s}';
                              document.getElementById('presupuesto_direcao').value            = '#{@cliente.direcao.to_s}';
                              document.getElementById('presupuesto_cidade_id').value          = '#{@cliente.cidade_id.to_i}';
                              document.getElementById('presupuesto_bairro').value             = '#{@cliente.bairro.to_s}';
                            </script>"
    end

    def get_codigo_barra_produto  #
        @presupuesto = Presupuesto.find(params[:id])
        @produto     =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])
        stock        = Stock.sum('entrada - saida',:conditions => ['produto_id = ?',@produto.id] )

        if @presupuesto.tipo_maiorista == 0
            preco_dolar   = @produto.preco_venda_dolar.to_f
            preco_guarani = @produto.preco_venda_guarani.to_f
        elsif @presupuesto.tipo_maiorista == 1
            preco_dolar   = @produto.preco_maiorista_dolar.to_f
            preco_guarani = @produto.preco_maiorista_guarani.to_f
        else
            preco_dolar   = @produto.preco_minorista_dolar.to_f
            preco_guarani = @produto.preco_minorista_guarani.to_f
        end


        return render :text => "<script type='text/javascript'>
                                  document.getElementById('presupuesto_produto_produto_id').value             = '#{@produto.id.to_i}';
                                  document.getElementById('presupuesto_produto_produto_nome').value           = '#{@produto.nome.to_s}';
                                  document.getElementById('presupuesto_produto_clase_id').value               = '#{@produto.clase_id.to_i}';
                                  document.getElementById('presupuesto_produto_grupo_id').value               = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('presupuesto_produto_sub_grupo_id').value           = '#{@produto.sub_grupo_id.to_i}';
                                  document.getElementById('presupuesto_produto_unitario_dolar').value         =  number_format( #{preco_dolar},2, ',', '.')
                                  document.getElementById('presupuesto_produto_unitario_guarani').value       = number_format( #{preco_guarani},0, ',', '.');

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

    def print_presupuesto        #
        @presupuesto = Presupuesto.find(params[:id])

        @presupuesto_produto = PresupuestoProduto.all(:conditions => ['presupuesto_id = ?',params[:id]])

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
        send_data(kit.to_pdf, :filename => "PRESUPUESTO_.pdf")

    end

    def index                     #
        @presupuestos = Presupuesto.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @presupuestos }
        end
    end

    def show                      #
        @presupuesto = Presupuesto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @presupuesto }
        end
    end

    def new                       #
        @presupuesto = Presupuesto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @presupuesto }
        end
    end

    def edit                      #
        @presupuesto = Presupuesto.find(params[:id])
    end

    def create                    #
        @presupuesto = Presupuesto.new(params[:presupuesto])

        respond_to do |format|
            if @presupuesto.save
                format.html { redirect_to(@presupuesto) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                    #
        @presupuesto = Presupuesto.find(params[:id])

        respond_to do |format|
            if @presupuesto.update_attributes(params[:presupuesto])
                format.html { redirect_to(@presupuesto) }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                   #
        @presupuesto = Presupuesto.find(params[:id])
        @presupuesto.destroy

        respond_to do |format|
            format.html { redirect_to(presupuestos_url) }
        end
    end
end
