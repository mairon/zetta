class VendasProdutosController < ApplicationController

    def get_codigo                           #
        @persona =  Persona.find(:first, :conditions =>  [ "#{id} = ?", params[:codigo]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('venda_persona_id').value           = '#{@persona.id.to_i}';
                              document.getElementById('venda_persona_cod').value          = '#{@persona.cod_velho.to_s}';
                              document.getElementById('venda_persona_nome').value         = '#{@persona.nome.to_s}';
                              document.getElementById('venda_limite_credito').value       = '#{@persona.limite_credito.to_i}';
                              document.getElementById('venda_classificacao').value        = '#{@persona.classificacao.to_s}';
                              document.getElementById('venda_ruc').value                  = '#{@persona.ruc.to_s}';
                              document.getElementById('venda_cliente').value              = '#{@persona.tipo_maiorista.to_i}';
                              document.getElementById('venda_direcao').value              = '#{@persona.direcao.to_s}';
                              document.getElementById('venda_cidade_id').value            = '#{@persona.cidade_id.to_i}';
                              document.getElementById('venda_cidade_nome').value          = '#{@persona.cidade.to_s}';
                              document.getElementById('venda_bairro').value               = '#{@persona.bairro.to_s}';
                            </script>"
    end

    def get_codigo_barra_produto             #
        @venda = Venda.find(params[:id])
        if $empresa == 'E01'
            @produto =  Produto.find(:first, :conditions =>  [ "cod_velho = ?", params[:codigo]])
        else
            @produto =  Produto.find(:first, :conditions =>  [ "id = ?", params[:codigo]])
        end
        @stock    = Stock.sum('entrada - saida',:conditions => ['produto_id = ?',@produto.id] )

        if @venda.tipo_maiorista == 0
            preco_dolar   = @produto.preco_venda_dolar.to_f
            preco_guarani = @produto.preco_venda_guarani.to_f
        elsif @venda.tipo_maiorista == 1
            preco_dolar   = format("%,2f",@produto.preco_maiorista_dolar.to_f)
            preco_guarani = @produto.preco_maiorista_guarani.to_f
        else
            preco_dolar   = format("%,2f",@produto.preco_minorista_dolar.to_f)
            preco_guarani = @produto.preco_minorista_guarani.to_f
        end


        return render :text => "<script type='text/javascript'>
                                  document.getElementById('venda_produto_produto_busca_').value            = '#{@produto.nome.to_s}';
                                  document.getElementById('vendas_produto_produto_nome').value             = '#{@produto.nome.to_s}';
                                  document.getElementById('vendas_produto_produto_cod').value              = '#{@produto.cod_velho.to_i}';
                                  document.getElementById('vendas_produto_produto_id').value               = '#{@produto.id.to_i}';
                                  document.getElementById('vendas_produto_codigo').value                   = '#{@produto.codigo.to_i}';
                                  document.getElementById('vendas_produto_clase_id').value                 = '#{@produto.clase_id.to_i}';
                                  document.getElementById('vendas_produto_grupo_id').value                 = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('vendas_produto_tipo').value                     = '#{@produto.tipo.to_i}';
                                  document.getElementById('vendas_produto_desconto').value                 = '#{@produto.desconto.to_i}';
                                  document.getElementById('vendas_produto_unitario_dolar').value           = #{preco_dolar}
                                  document.getElementById('vendas_produto_unitario_guarani').value         = #{preco_guarani}
                                  document.getElementById('vendas_produto_saldo').value                    = '#{@stock}';
                                  document.getElementById('vendas_produto_taxa').value                     = '#{@produto.taxa.to_i}';
                                   if ( '#{@stock}' <= 0 )
                                     {
                                      document.getElementById('red').innerHTML                             =  '<span>'+'#{@stock}'+'</span>' ;
                                      document.getElementById('green').innerHTML                           =  '' ;
                                     }
                                   else
                                     {
                                      document.getElementById('green').innerHTML                           =  '<span>'+'#{@stock}'+'</span>' ;
                                      document.getElementById('red').innerHTML                             =  '' ;
                                     }
                                </script>"
    end

    def get_produto                          #

        @venda = Venda.find(params[:id])

        @produto =  Produto.find(:first, :conditions =>  [ "nome = ?", params[:produto_busca]])

        @stock    = Stock.sum('entrada - saida',:conditions => ['produto_id = ?',@produto.id] )

        if @venda.tipo_maiorista == 0
            preco_dolar   = format("%.2f",@produto.preco_venda_dolar.to_f)
            preco_guarani = @produto.preco_venda_guarani.to_f
        elsif @venda.tipo_maiorista == 1
            preco_dolar   = format("%.2f",@produto.preco_maiorista_dolar.to_f)
            preco_guarani = @produto.preco_maiorista_guarani.to_f
        else
            preco_dolar   = format("%.2f",@produto.preco_minorista_dolar.to_f)
            preco_guarani = @produto.preco_minorista_guarani.to_f
        end


        return render :text => "<script type='text/javascript'>
                                  document.getElementById('venda_produto_produto_busca_').value            = '#{@produto.nome.to_s}';
                                  document.getElementById('vendas_produto_produto_nome').value             = '#{@produto.nome.to_s}';
                                  document.getElementById('vendas_produto_produto_cod').value              = '#{@produto.cod_velho.to_i}';
                                  document.getElementById('vendas_produto_produto_id').value               = '#{@produto.id.to_i}';
                                  document.getElementById('vendas_produto_codigo').value                   = '#{@produto.codigo.to_i}';
                                  document.getElementById('vendas_produto_clase_id').value                 = '#{@produto.clase_id.to_i}';
                                  document.getElementById('vendas_produto_grupo_id').value                 = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('vendas_produto_tipo').value                     = '#{@produto.tipo.to_i}';
                                  document.getElementById('vendas_produto_desconto').value                 = '#{@produto.desconto.to_i}';
                                  document.getElementById('vendas_produto_unitario_dolar').value           = #{preco_dolar}
                                  document.getElementById('vendas_produto_unitario_guarani').value         = #{preco_guarani}
                                  document.getElementById('vendas_produto_saldo').value                    = '#{@stock}';
                                  document.getElementById('vendas_produto_taxa').value                     = '#{@produto.taxa.to_i}';
                                   if ( '#{@stock}' <= 0 )
                                     {
                                      document.getElementById('red').innerHTML                             =  '<span>'+'#{@stock}'+'</span>' ;
                                      document.getElementById('green').innerHTML                           =  '' ;
                                     }
                                   else
                                     {
                                      document.getElementById('green').innerHTML                           =  '<span>'+'#{@stock}'+'</span>' ;
                                      document.getElementById('red').innerHTML                             =  '' ;
                                     }
                                </script>"
    end

    def busca_nota_credito_produto  #
        @vendas_produtos = VendasProduto.nota_credito_produto(params)
        render :layout => 'consulta'
    end

    def index                       #
        @vendas_produtos = VendasProduto.find(:all)

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @vendas_produtos }
        end
    end

    def show                        #
        @vendas_produto = VendasProduto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @vendas_produto }
        end
    end

    def new                         #
        @vendas_produto = VendasProduto.new
        @vendas_produto.current_user = current_user.tipo

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @vendas_produto }
        end
    end

    def edit                        #
        @vendas_produto = VendasProduto.find(params[:id])
        @vendas_produto.current_user = current_user.tipo
        render :layout => 'layout_vendas'
    end

    def create                      #

        @vendas_produto = VendasProduto.new(params[:vendas_produto])

        respond_to do |format|
            if @vendas_produto.save
                flash[:notice] = 'Producto Adcionado'
                format.html {  redirect_to venda_path(@vendas_produto.venda_id) }
                format.js
            else
                format.html { render :action => "new" }
                format.js
            end
        end

    end
    
    def update                      #
        @vendas_produto = VendasProduto.find(params[:id])
        @vendas_produto.usuario_updated   = current_user.id
        @vendas_produto.unidade_updated   = current_unidade.id

        respond_to do |format|
            if @vendas_produto.update_attributes(params[:vendas_produto])

                flash[:notice] = 'Actualizado con Sucesso'
                format.html { redirect_to "/vendas/#{@vendas_produto.venda_id}" }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @vendas_produto.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
      @vendas_produto = VendasProduto.destroy(params[:id])
      respond_to do |format|
            format.html { redirect_to "/vendas/#{@vendas_produto.venda_id}" }
      end
    end
end
