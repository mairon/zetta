class NotaRemicaosController < ApplicationController    
    before_filter :authenticate

    def get_unidade_cod         #

        @unidade =  Unidade.find(:first, :conditions =>  [ "id = ?", params[:nota_remicao_destino_unidade_id]])

        return render :text => "<script type='text/javascript'>
                                          document.getElementById('nota_remicao_destino_unidade_nome').value     = '#{@unidade.unidade_nome.to_s}';
                                          document.getElementById('nota_remicao_direcao').value                  = '#{@unidade.direcao.to_s}';
                                          document.getElementById('nota_remicao_bairro').value                   = '#{@unidade.bairro.to_s}';
                                          document.getElementById('nota_remicao_cidade_id').value                = '#{@unidade.cidade_id.to_i}';
                                        </script>"
    end

    def get_persona_cod         #

        @persona =  Persona.find(:first, :conditions =>  [ "cod_velho = ?", params[:nota_remicao_destino_persona_cod]])

        return render :text => "<script type='text/javascript'>
                                                      document.getElementById('nota_remicao_destino_persona_id').value       = '#{@persona.id.to_i}';
                                                      document.getElementById('nota_remicao_direcao').value                  = '#{@persona.direcao.to_s}';
                                                      document.getElementById('nota_remicao_bairro').value                   = '#{@persona.bairro.to_s}';
                                                      document.getElementById('nota_remicao_cidade_id').value                = '#{@persona.cidade_id.to_i}';
                                              </script>"
    end

    def get_produto_cod         #
         
        @produto            =  Produto.find(:first, :conditions =>  [ "cod_velho = ?", params[:nota_remicao_produto_produto_cod]])

        @stock               = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )
        @ultimo_custo        = Stock.find(:last,:conditions => ['status = 0 and produto_id = ?',@produto.id])
        return render :text => "<script type='text/javascript'>
                                                      document.getElementById('nota_remicao_produto_produto_nome').value       = '#{ @produto.nome.to_s }';
                                                      document.getElementById('nota_remicao_produto_produto_id').value         = '#{ @produto.id.to_i }';
                                                      document.getElementById('nota_remicao_produto_clase_id').value           = '#{ @produto.clase_id.to_i }';
                                                      document.getElementById('nota_remicao_produto_grupo_id').value           = '#{ @produto.grupo_id.to_i }';
                                                      document.getElementById('nota_remicao_produto_valor_dolar').value        = '#{ @produto.preco_venda_dolar.to_f }';
                                                      document.getElementById('nota_remicao_produto_valor_guarani').value      = '#{ @produto.preco_venda_guarani.to_f }';
                                                      document.getElementById('nota_remicao_produto_saldo').value              = '#{ @stock }';
                                                      document.getElementById('nota_remicao_produto_custo_dolar').value             = '#{ @ultimo_custo.custo_contabil_dolar.to_f + @ultimo_custo.iva_dolar.to_f }';
                                                      document.getElementById('nota_remicao_produto_custo_guarani').value           = '#{ @ultimo_custo.custo_contabil_guarani.to_f + @ultimo_custo.iva_guarani.to_f }';
                                                      document.getElementById('nota_remicao_produto_custo_contabil_dolar').value    = '#{ @ultimo_custo.custo_contabil_dolar.to_f }';
                                                      document.getElementById('nota_remicao_produto_custo_contabil_guarani').value  = '#{ @ultimo_custo.custo_contabil_guarani.to_i }';
                                              </script>"
    end

    def detalhes_produtos_print #
        @nota_remicao = NotaRemicao.find(params[:id])

        @nota_produtos = NotaRemicaoProduto.all(:conditions => ["nota_remicao_id = #{params[:id]}"])
        @qtd           = NotaRemicaoProduto.sum(:quantidade,:conditions => ["nota_remicao_id = #{params[:id]}"])

        render :layout => false
    end

    def comprovante             #
        @nota_remicao = NotaRemicao.find(params[:id])

        @nota_produtos = NotaRemicaoProduto.all(:conditions => ["nota_remicao_id = #{params[:id]}"])
        @qtd           = NotaRemicaoProduto.sum(:quantidade,:conditions => ["nota_remicao_id = #{params[:id]}"])        
        @custo_guarani = NotaRemicaoProduto.sum(:custo_guarani,:conditions => ["nota_remicao_id = #{params[:id]}"])        
        @valor_guarani = NotaRemicaoProduto.sum(:valor_guarani,:conditions => ["nota_remicao_id = #{params[:id]}"])

        render :layout => false
    end

    def index                   #
        @nota_remicaos = NotaRemicao.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @nota_remicaos }
        end
    end

    def show                    #
        @nota_remicao = NotaRemicao.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota_remicao }
        end
    end

    def new                     #
        @nota_remicao = NotaRemicao.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @nota_remicao }
        end
    end

    def edit                    #
        @nota_remicao = NotaRemicao.find(params[:id])
    end
    
    def create                  #
        @nota_remicao = NotaRemicao.new(params[:nota_remicao])
        @nota_remicao.usuario_created = current_user.usuario_nome
        @nota_remicao.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @nota_remicao.save
                format.html { redirect_to(@nota_remicao, :notice => 'Grabado con Sucesso.') }
                format.xml  { render :xml => @nota_remicao, :status => :created, :location => @nota_remicao }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @nota_remicao.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                  #
        @nota_remicao = NotaRemicao.find(params[:id])
        @nota_remicao.usuario_updated = current_user.usuario_nome
        @nota_remicao.unidade_updated = current_unidade.unidade_nome


        respond_to do |format|
            if @nota_remicao.update_attributes(params[:nota_remicao])
                format.html { redirect_to(@nota_remicao, :notice => 'Actualizado con Sucesso') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @nota_remicao.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                 #
        @nota_remicao = NotaRemicao.find(params[:id])
        @nota_remicao.destroy

        respond_to do |format|
            format.html { redirect_to(nota_remicaos_url) }
            format.xml  { head :ok }
        end
    end

end
