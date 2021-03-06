class ProdutosController < ApplicationController

    before_filter :authenticate

    def roteiro
        @produto = Produto.find(params[:id])
    end

    def cod_barra
        @produto = Produto.find(params[:id])
    end

    def composicao
        @produto = Produto.find(params[:id])
    end

    def relatorio_detalhes_produto
        @pd = Produto.find(params[:id])

        @quantidade = Stock.sum("entrada - saida",:conditions => ["produto_id = ?",params[:id]])

        @cp = ProdutoComposicao.all(:conditions => ["produto_id = ?", @pd.id])

        @pr = ProdutosRoteiro.all(:conditions => ["produto_id = ?", @pd.id])

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

    def get_componente                                #
        @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:campo_produto]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('produto_composicao_componente_nome').value                = '#{@produto.nome}';
                    document.getElementById('produto_composicao_componente_id').value                = '#{@produto.id.to_i}';
                    document.getElementById('produto_composicao_clase_id').value                = '#{@produto.clase_id.to_i}';
                    document.getElementById('produto_composicao_grupo_id').value                = '#{@produto.grupo_id.to_i}';
                            </script>"
    end


    def get_clase                              #
        @clase =  Clase.find(:first, :conditions =>  [ "id = ?", params[:campo_clase]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_clase').value                = '#{@clase.id.to_i}';
                            </script>"
    end

    def get_grupo                              #
        @grupo =  Grupo.find(:first, :conditions =>  [ "id = ?", params[:campo_grupo]])
        return render :text => "<script type='text/javascript'>
                    document.getElementById('busca_grupo').value                = '#{@grupo.id.to_i}';
                            </script>"
    end

    def get_moeda                              #
        @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:produto_data]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('produto_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                              document.getElementById('produto_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end

    def dinamic_busca_compra_produto           #
        tipo = "nome"            if params[:tipo] == "DESCRIPCION"
        tipo = "barra"           if params[:tipo] == "BARRA"
        sql = "SELECT P.ID,
                      P.FABRICANTE_COD,
                      P.NOME,
                      P.TAXA,
                      P.CODIGO,
                      P.REFERENCIA,
                      P.CLASE_ID,
                      P.SUB_GRUPO_ID,
                      P.GRUPO_ID,
                      G.PORCEN_BALCAO,
                      G.PORCEN_MAYO,
                      G.PORCEN_MINO,
                      (SELECT SUM(ENTRADA - SAIDA) FROM STOCKS WHERE PRODUTO_ID = P.ID) AS STOCK
                FROM PRODUTOS P
                INNER JOIN GRUPOS G
                ON P.GRUPO_ID = G.ID
                WHERE #{tipo} LIKE '%#{params[:busca]}%'
                ORDER BY P.NOME, P.ID"
        @produtos = Produto.find_by_sql(sql)
        render :layout => false
    end

    def busca_compra_produto
        render :layout => 'consulta'
    end

    def dinamic_busca_pedido_compra_produto           #
        tipo = "nome"            if params[:tipo] == "DESCRIPCION"
        tipo = "barra"           if params[:tipo] == "BARRA"

        @produtos = Produto.all( :conditions => ["#{tipo} LIKE ? ","%#{params[:busca]}%"],:order => 'nome,fabricante')
        render :layout => false
    end

    def busca_pedido_compra_produto                   #
        @produtos = Produto.find(:all, :order => 1)
        render :layout => 'consulta'
    end


    def busca_venda_produto_maiorista          #
        render :layout => 'consulta'
    end

    def dinamic_busca_venda_produto_maiorista  #

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"
        tipo = "cod_velho"       if params[:tipo] == "CODIGO"

        if tipo == "cod_velho"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                              nome,
                                              clase_id,
                                              grupo_id,
                                              tipo,
                                              preco_venda_dolar,
                                              preco_maiorista_dolar,
                                              preco_maiorista_guarani,
                                              codigo,
                                              barra,
                                              taxa,
                                              desconto,
                                              fabricante_cod,
                                              cod_velho ',
            :conditions =>   cond,
            :order      => ' nome,
                                              cod_velho ')

        respond_to do |format|
            format.js # show.html.erb
            format.html {render :layout => false}
            format.xml  { render :xml => @produtos }
        end
    end

    def busca_manutencao_mq_produto            #
        render :layout => 'consulta'
    end

    def dinamic_busca_manutencao_mq_produto    #
        tipo = "id"           if params[:tipo] == "CODIGO"

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"

        tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                                  nome,
                                                  clase_id,
                                                  grupo_id,
                                                  sub_grupo_id,
                                                  preco_venda_dolar,
                                                  preco_venda_guarani,
                                                  tipo,
                                                  locacao,
                                                  fabricante_cod,
                                                  cod_velho ',
            :conditions =>   cond,
            :order      => "nome,#{tipo}")

        render :layout => false
    end


    def busca_composicao_produto            #
        render :layout => 'consulta'
    end

    def dinamic_busca_composicao_produto    #
        tipo = "id"           if params[:tipo] == "CODIGO"

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"

        tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                                  nome,
                                                  clase_id,
                                                  grupo_id,
                                                  sub_grupo_id,
                                                  preco_venda_dolar,
                                                  preco_venda_guarani,
                                                  tipo,
                                                  locacao,
                                                  fabricante_cod,
                                                  cod_velho ',
            :conditions =>   cond,
            :order      => "nome,#{tipo}")

        render :layout => false
    end


    def busca_consumicao_interna_produto            #
        render :layout => 'consulta'
    end

    def dinamic_busca_consumicao_interna_produto    #
        tipo = "id"           if params[:tipo] == "CODIGO"

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"

        tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                                  nome,
                                                  taxa,
                                                  clase_id,
                                                  grupo_id,
                                                  sub_grupo_id,
                                                  preco_venda_dolar,
                                                  preco_venda_guarani,
                                                  tipo,
                                                  locacao,
                                                  fabricante_cod,
                                                  cod_velho ',
            :conditions =>   cond,
            :order      => "nome,#{tipo}")

        render :layout => false
    end


    def busca_producao_produto                 #
        render :layout => 'consulta'
    end

    def dinamic_busca_producao_produto         #
        tipo = "id"           if params[:tipo] == "CODIGO"

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"

        tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                                  nome,
                                                  clase_id,
                                                  grupo_id,
                                                  sub_grupo_id,
                                                  tipo,
                                                  locacao,
                                                  fabricante_cod,
                                                  cod_velho ',
            :conditions =>   cond,
            :order      => "nome,#{tipo}")

        render :layout => false
    end

    def busca_venda_produto                    #
        render :layout => 'consulta'
    end

    def dinamic_busca_venda_produto            #

        tipo = "P.ID"           if params[:tipo] == "CODIGO"

        tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"

        tipo = "P.FABRICANTE_COD"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

          sql = "SELECT
                       P.ID,
                       P.NOME,
                       P.CLASE_ID,
                       P.GRUPO_ID,
                       P.TIPO,
                       P.PRECO_VENDA_DOLAR,
                       P.PRECO_VENDA_GUARANI,
                       P.PRECO_MAIORISTA_DOLAR,
                       P.PRECO_MAIORISTA_GUARANI,
                       P.PRECO_MINORISTA_DOLAR,
                       P.PRECO_MINORISTA_GUARANI,
                       P.CODIGO,
                       P.BARRA,
                       P.TAXA,
                       P.LOCACAO,
                       P.DESCONTO,
                       P.FABRICANTE_COD,
                       P.COD_VELHO,
                       (SELECT SUM(ENTRADA - SAIDA) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DEPOSITO_ID = #{params[:deposito_id]}) AS STOCK
                 FROM  PRODUTOS P
                 WHERE #{cond}
                   ORDER BY #{tipo} "

        @produtos = Produto.paginate_by_sql(sql, :page => params[:page], :per_page => 20)

        render :layout => false
    end

    def busca_presupuesto_produto              #
        render :layout => 'consulta'
    end

    def dinamic_busca_presupuesto_produto      #

        tipo = "id"           if params[:tipo] == "CODIGO"

        tipo = "nome"            if params[:tipo] == "DESCRIPCION"

        tipo = "fabricante_cod"  if params[:tipo] == "COD FABRICANTE"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

        @produtos = Produto.all( :select     => ' id,
                                              nome,
                                              clase_id,
                                              grupo_id,
                                              tipo,
                                              preco_venda_dolar,
                                              preco_venda_guarani,
                                              preco_venda_real,
                                              preco_maiorista_dolar,
                                              preco_maiorista_guarani,
                                              preco_maiorista_real,
                                              preco_minorista_dolar,
                                              preco_minorista_guarani,
                                              preco_minorista_real,
                                              codigo,
                                              taxa,
                                              locacao,
                                              desconto,
                                              fabricante_cod,
                                              cod_velho ',
            :conditions =>   cond,
            :order      => "nome,#{tipo}")

        render :layout => false
    end

    def busca_remicao_produto                  #
        render :layout => 'consulta'
    end

    def dinamic_busca_remicao_produto          #

        tipo = "P.ID"           if params[:tipo] == "CODIGO"

        tipo = "P.NOME"            if params[:tipo] == "DESCRIPCION"

        if params[:tipo] == "CODIGO"
            cond  = " #{tipo} = #{params[:busca]} "
        else
            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        end

          sql = "SELECT
                       P.ID,
                       P.NOME,
                       P.CLASE_ID,
                       P.GRUPO_ID,
                       P.TIPO,
                       P.PRECO_VENDA_DOLAR AS PRECO_US,
                       P.PRECO_VENDA_GUARANI AS PRECO_GS,
                       P.PRECO_MAIORISTA_DOLAR,
                       P.PRECO_MAIORISTA_GUARANI,
                       P.PRECO_MINORISTA_DOLAR,
                       P.PRECO_MINORISTA_GUARANI,
                       P.CODIGO,
                       P.BARRA,
                       P.TAXA,
                       P.LOCACAO,
                       P.DESCONTO,
                       P.FABRICANTE_COD,
                       P.COD_VELHO,
                       (SELECT SUM(ENTRADA - SAIDA) FROM STOCKS WHERE PRODUTO_ID = P.ID) AS STOCK
                 FROM  PRODUTOS P
                 WHERE #{cond}
                   ORDER BY #{tipo} "

        @produtos = Produto.paginate_by_sql(sql, :page => params[:page], :per_page => 20)

        render :layout => false
    end

    def dinamic_busca_ordem_produto            #
        @produtos = Produto.find(:all, :conditions => ["fabricante_cod LIKE ? OR nome LIKE ? OR fabricante LIKE ?","%#{params[:busca]}%","%#{params[:busca]}%","%#{params[:busca]}%"])
        render :layout => false
    end

    def busca_ordem_produto                    #
        @produtos = Produto.find(:all, :order => 1)

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @produtos }
        end
    end

    def historico_preco_produto                #
        @tabela = TabelaPrecoProduto.all(:conditions => ['produto_id = ?',params[:id]])
        render :layout => 'consulta'
    end

    def consulta_stock                         #
        render :layout => 'consulta'
    end

    def dinamic_busca_consulta_stock           #


        tipo = "nome"            if params[:tipo] == "DESCRIPCION"
        tipo = "fabricante_cod"  if params[:tipo] == "CODIGO"

            cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
        sql = "SELECT
                      P.ID,
                      P.NOME,
                      P.FABRICANTE_COD,
                      P.LOCACAO,
                      ( SELECT UNITARIO_DOLAR FROM STOCKS WHERE PRODUTO_ID = P.ID AND STATUS = 0  ORDER BY DATA DESC LIMIT 1) AS CUSTO_DOLAR,
                      ( SELECT UNITARIO_GUARANI FROM STOCKS WHERE PRODUTO_ID = P.ID AND STATUS = 0  ORDER BY DATA DESC LIMIT 1) AS CUSTO_GUARANI,
                      ( SELECT SUM(ENTRADA - SAIDA) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DEPOSITO_ID = #{params[:deposito_id]} ) AS STOCK ,
                      P.DESCONTO,
                      P.PRECO_VENDA_DOLAR,
                      P.PRECO_VENDA_GUARANI,
                      P.PRECO_MAIORISTA_DOLAR,
                      P.PRECO_MAIORISTA_GUARANI,
                      P.PRECO_MINORISTA_DOLAR,
                      P.PRECO_MINORISTA_GUARANI
               FROM
                      PRODUTOS P
               WHERE   #{cond}
               ORDER BY 2,7 "

        @produtos = Produto.find_by_sql(sql)
        @form = Form.first(:select => 'consulta_stock')
        respond_to do |format|
            format.html {render :layout => false}
        end

    end

    def dinamic_busca                          #

        @produtos = Produto.busca_produto(params)

        respond_to do |format|
            format.html {render :layout => false}
        end
    end

    #METHOD BASE
    def index                        #
        @produtos = Produto.all(:select => 'id,nome', :conditions => ["nome LIKE ?","%#{params[:busca]}%"])
        respond_to do |format|
            format.js # show.html.erb
            format.html # index.html.erb
            format.xml  { render :xml => @produtos }
        end
    end

    def index_print                  #

        @produtos = Produto.busca_produto(params)

    end

    def show                         #
        @produto = Produto.find(params[:id])
        @quantidade = Stock.sum("entrada - saida",:conditions => ["produto_id = ?",params[:id]])
        @ultima_compra = ComprasProduto.all(:select => 'id,data,compra_id,persona_nome,quantidade,unitario_dolar',:conditions => ["produto_id = ?",params[:id]],
                                            :order => 'compra_id desc',:limit => 5)
        @ultima_venda = VendasProduto.all(:select => 'id,data,venda_id,persona_nome,quantidade,unitario_dolar',:conditions => ["produto_id = ?",params[:id]],
                                            :order => 'venda_id desc',:limit => 5)

        render :layout => 'consulta'
    end

    def imagem                         #
        @produto = Produto.find(params[:id])

        render :layout => 'consulta'
    end


    def new                          #
        @produto = Produto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @produto }
        end
    end

    def edit                         #
        @produto = Produto.find(params[:id])
    end

    def create                       #
        @produto = Produto.new(params[:produto])
        @produto.usuario_created = current_user.usuario_nome
        @produto.unidade_created = current_unidade.unidade_nome

        respond_to do |format|
            if @produto.save
                
                flash[:notice] = 'Grabado con Sucesso'
                format.html { redirect_to(produtos_url) }
                format.xml  { render :xml => @produto, :status => :created, :location => @produto }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
            end
        end
    end



    def update                       #
        @produto = Produto.find(params[:id])
        @produto.usuario_updated = current_user.usuario_nome
        @produto.unidade_updated = current_unidade.unidade_nome
        respond_to do |format|
            if @produto.update_attributes(params[:produto])
                flash[:notice] = 'Actualizado con Sucesso'
                format.html { redirect_to(produtos_url) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                      #
        @produto = Produto.find(params[:id])
        @produto.destroy

        respond_to do |format|
            format.html { redirect_to(produtos_url) }
            format.xml  { head :ok }
        end
    end
end

