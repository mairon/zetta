class Stock < ActiveRecord::Base
    before_save :finds
    def finds
        @produto = Produto.find_by_id(self.produto_id);
        self.produto_nome = @produto.nome.to_s;

        @deposito = Deposito.find_by_id(self.deposito_id);
        self.deposito_nome = @deposito.nome.to_s unless self.deposito_id.blank?;

        if self.entrada > 0
          self.status = '0'
        else 
          self.status = '1'
        end 

    end

    def self.ficha_stock_resumido( params )                              #
        #FILTRO
        filtro   = " AND status      = #{params[:filtro]} "  unless params[:filtro].blank?
        #CLASE
        clase    = " AND clase_id    = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        #GRUPO
        grupo    = " AND grupo_id    = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto  = " AND produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        #DEPOSITO
        deposito = " AND deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        persona = " AND stocks.persona_id = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

        cond = " data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} #{persona}"

        if params[:orden] == '0'
          order = '2,1'
        elsif params[:orden] == '1'
          order = '6,1'
        elsif params[:orden] == '2'
          order = '7,1'
        end


        Stock.all(:select     => "id,
                              data,
                              status,
                              venda_id,
                              produto_id,
                              produto_nome,
                              persona_nome,
                              deposito_id,
                              entrada,
                              cod_processo,
                              persona_nome,
                              unitario_dolar,
                              unitario_guarani,
                              saida,
                              tabela_id",
            :conditions => cond,
            :order      => order )

    end
    #FICHA STOCK
    def self.relatorio_ficha_stock( params )                             #
        #FILTRO
        filtro   = " AND stocks.status      = #{params[:filtro]} "  unless params[:filtro].blank?
        #CLASE
        clase    = " AND stocks.clase_id    = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        #GRUPO
        grupo    = " AND stocks.grupo_id    = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto  = " AND stocks.produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        #DEPOSITO
        deposito = " AND stocks.deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        persona = " AND stocks.persona_id = #{params[:busca]["persona"]}" unless params[:busca]["persona"].blank?

        cond = "produtos.tipo_produto = 0 AND stocks.data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} #{persona}"

        Stock.all(:select     => "stocks.id,
                              stocks.data,
                              stocks.status,
                              stocks.cod_processo,
                              stocks.produto_id,
                              stocks.produto_nome,
                              stocks.persona_nome,
                              stocks.deposito_nome,
                              stocks.entrada,
                              stocks.persona_nome,
                              stocks.unitario_guarani,
                              stocks.unitario_dolar,
                              stocks.promedio_guarani,
                              stocks.promedio_dolar,
                              stocks.deposito_id,
                              stocks.saida,
                              stocks.tabela,
                              stocks.tabela_id",
            :joins      => 'LEFT JOIN produtos ON stocks.produto_id = produtos.id',
            :conditions => cond,
            :order      => '2,3' )

    end

    def self.relatorio_ficha_stock_saldo_anterio( params )               #
        #FILTRO
        filtro   = " AND status      = #{params[:filtro]} "  unless params[:filtro].blank?
        #CLASE
        clase    = " AND clase_id    = #{params[:busca]["clase"]}"    unless params[:busca]["clase"].blank?
        #GRUPO
        grupo    = " AND grupo_id    = #{params[:busca]["grupo"]}"    unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto  = " AND produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
        #DEPOSITO
        deposito = " AND deposito_id = #{params[:busca]["deposito"]}" unless params[:busca]["deposito"].blank?

        cond = " data < '#{params[:inicio]}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} "

        Stock.sum( 'entrada - saida',:conditions => cond )

    end
    #IVENTARIO
    def self.resultaro_iventario( params )                               #
        #CONDICOES
        #CLASE
        clase   = "AND clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
        #GRUPO
        grupo   = "AND grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto = "AND id = #{params[:busca]["produto"]}"     unless params[:busca]["produto"].blank?
      
        sql = "SELECT 
                      p.CLASE_ID,
                      P.GRUPO_ID,
                      P.ID,
                      P.FABRICANTE_COD,
                      P.NOME,
                      (SELECT SUM(ENTRADA - SAIDA ) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA <= '#{params[:final]}') AS SALDO,
                      (SELECT MAX(PROMEDIO_DOLAR) FROM STOCKS WHERE PRODUTO_ID = P.ID  AND DATA <= '#{params[:final]}') AS CUSTO_US
                FROM
                      PRODUTOS P
                WHERE                      
                      ( SELECT SUM(ENTRADA - SAIDA ) FROM STOCKS WHERE PRODUTO_ID = P.ID ) > 0
                      #{clase} #{grupo} #{produto} 
                ORDER BY 
                      1,2,3"

        Produto.find_by_sql(sql)                      
    end

    def self.resultaro_stock_inicial( params )                           #

        if params[:tipo] == "CODIGO"
            prod = Produto.first(:conditions => ["fabricante_cod = '#{params[:busca]}'"])
            cond =  ["produto_id = ? AND tabela = 'INICIAL'","#{prod.id}"] unless params[:busca].blank?
        else
            tipo = "produto_nome"
            cond =  ["#{tipo} LIKE ? AND tabela = 'INICIAL'","%#{params[:busca]}%"] unless params[:busca].blank?

        end


        Stock.all( :conditions =>   cond, :order      => 'id desc' )

    end
    
    #RENTABILIDAD
    def self.rentabilidade( params )                                     #
        #CONDICOES
        #CLASE
        clase   = "AND P.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
        #GRUPO
        grupo   = "AND P.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto = "AND P.id = #{params[:busca]["produto"]}"     unless params[:busca]["produto"].blank?

		if params[:moeda] == '0'
			unit  = 'UNITARIO_DOLAR'
		else
			unit = 'UNITARIO_GUARANI'
		end

        sql = "SELECT 
                      P.ID,
                      P.CLASE_ID,
                      P.GRUPO_ID,
                      P.NOME,
                      ( SELECT SUM(SAIDA) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID) AS QTD_VENDA,
                      ( SELECT SUM( SAIDA * #{unit} ) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID) AS TOT_VENDA,
                      ( ( ( SELECT SUM( ( ENTRADA * #{unit} ) ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID AND STATUS = 0 AND ENTRADA > 0 ) / ( SELECT SUM( ENTRADA ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID) ) * ( SELECT SUM(SAIDA) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID ) ) AS CUSTO,
                      (( SELECT SUM( SAIDA * #{unit} ) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID) - ( ( ( SELECT SUM( ( ENTRADA * #{unit} ) ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID AND STATUS = 0 AND ENTRADA > 0 ) / ( SELECT SUM( ENTRADA ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID) ) * ( SELECT SUM(SAIDA) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID ) ) ) AS DIF,
                      (((( SELECT SUM( SAIDA * #{unit} ) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID) - ( ( ( SELECT SUM( ( ENTRADA * #{unit} ) ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID AND STATUS = 0 AND ENTRADA > 0 ) / ( SELECT SUM( ENTRADA ) FROM STOCKS WHERE TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA < '#{params[:final]}' AND PRODUTO_ID = P.ID) ) * ( SELECT SUM(SAIDA) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID ) ) )*100)/( SELECT SUM( SAIDA * #{unit} ) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID)) AS RENDA
             
               FROM 
                     PRODUTOS P
               WHERE 
                   TIPO_PRODUTO = 0  #{clase} #{grupo} #{produto}
               GROUP BY 
                     1,2,3,4
               HAVING 
                     ( SELECT SUM(SAIDA) FROM STOCKS WHERE DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND PRODUTO_ID = P.ID ) > 0
               ORDER BY 2,3,9,5 DESC, 8 DESC

      
           "

        Produto.find_by_sql( sql )

    end

    def self.rentabilidade_detalhado( params )                                     #
        #CONDICOES
        #CLASE
        clase   = "AND VP.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
        #GRUPO
        grupo   = "AND VP.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto = "AND VP.produto_id = #{params[:busca]["produto"]}"    unless params[:busca]["produto"].blank?
        #VENDEDOR
        vend    = "AND V.VENDEDOR_ID = #{params[:busca]["vendedor"]}"   unless params[:busca]["vendedor"].blank?
        #PERSONA
        vend    = "AND V.PERSONA_ID = #{params[:busca]["persona"]}"     unless params[:busca]["persona"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND VP.MOEDA = 0"
           else
              moeda = "AND VP.MOEDA = 1"
           end
        end

        if params[:legal].to_s == "1"
              fatura = "AND V.FATURA = 1"
        end

        if params[:prod].to_s == "0"
             prod = "AND P.TIPO_PRODUTO = 0"
        elsif params[:prod].to_s == "1"
             prod = "AND P.TIPO_PRODUTO = 1"
		else
			 prod = ""
        end


        sql = "SELECT 
                    V.DATA,
								    VP.PRODUTO_ID,
       							VP.CLASE_ID,
						        VP.GRUPO_ID,
						        VP.PRODUTO_NOME,
                    V.VENDEDOR_NOME,
                    V.TIPO_MAIORISTA,
                    v.PERSONA_ID,
                    VP.TOTAL_DESCONTO,
                    P.fabricante_cod,
						        VP.QUANTIDADE,
						        VP.UNITARIO_DOLAR,
						        VP.UNITARIO_GUARANI,
						        ( SELECT S.PROMEDIO_DOLAR FROM STOCKS S WHERE TABELA_ID = VP.ID AND TABELA = 'VENDAS_PRODUTOS' ) AS CUSTO_PROMED_US,
						        ( SELECT S.PROMEDIO_GUARANI FROM STOCKS S WHERE TABELA_ID = VP.ID AND TABELA = 'VENDAS_PRODUTOS' ) AS CUSTO_PROMED_GS,
                    (((VP.UNITARIO_DOLAR * VP.QUANTIDADE) - (( SELECT S.PROMEDIO_DOLAR FROM STOCKS S WHERE TABELA_ID = VP.ID AND TABELA = 'VENDAS_PRODUTOS' ) * VP.QUANTIDADE ) *100) / ( ( SELECT S.PROMEDIO_DOLAR FROM STOCKS S WHERE TABELA_ID = VP.ID AND TABELA = 'VENDAS_PRODUTOS' ) * VP.QUANTIDADE ) )
				  FROM  
						       VENDAS_PRODUTOS VP
				  INNER JOIN 
							   PRODUTOS P
				  ON      VP.PRODUTO_ID = P.ID	
				  INNER JOIN 
							   VENDAS V
				  ON      VP.VENDA_ID = V.ID	

				  WHERE 
				             VP.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
  							 #{clase} #{grupo} #{produto} #{moeda} #{fatura} #{vend}
							 #{prod}
				  ORDER BY 11 DESC,3,4"

        Produto.find_by_sql( sql )

    end
    def self.rentabilidade_agrupado_setor(params)
      sql ="SELECT VP.CLASE_ID,
                   C.DESCRICAO,
                   SUM(VP.QUANTIDADE) AS  SUM_QTD,
                   SUM(VP.TOTAL_DOLAR) AS SUM_US,
                   SUM(VP.TOTAL_GUARANI) AS SUM_GS,
                   SUM(VP.TOTAL_REAL) AS SUM_RS
            FROM VENDAS_PRODUTOS VP
            INNER JOIN CLASES C
            ON VP.CLASE_ID = C.ID
            GROUP BY 1,2"
            Produto.find_by_sql( sql )
    end

  def self.projecao_compras(params)
   #CONDICOES
    #CLASE
    clase   = "AND p.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
    #GRUPO
    grupo   = "AND P.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?

    #GRUPO
    sub_grupo   = "AND P.sub_grupo_id = #{params[:busca]["sub_grupo"]}" unless params[:busca]["sub_grupo"].blank?

    #PRODUTO
    produto = "AND P.produto_id = #{params[:busca]["produto"]}"    unless params[:busca]["produto"].blank?
    #VENDEDOR

    if params[:lancamento].to_s != "1"
       if params[:moeda] == "0"
          moeda = "AND VP.MOEDA = 0"
       else
          moeda = "AND VP.MOEDA = 1"
       end
    end

    sql = "SELECT  
                P.CLASE_ID,
                P.GRUPO_ID,
                P.ID,
                P.NOME,
                P.EMBALAGEM,
                (SELECT coalesce(SUM(ENTRADA - SAIDA), 0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:inicio]}') AS ANTERIOR,                  
                (SELECT coalesce(SUM(ENTRADA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA <> 'NOTA_CREDITOS_DETALHES' AND DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}') AS ENTRADA,
                (SELECT coalesce(SUM(SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA = 'NOTA_CREDITOS_PROVEEDOR_PRODUTOS' AND DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}') AS ENTRADA_NC_PROV,
                (SELECT coalesce(SUM(SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND  TABELA <> 'NOTA_CREDITOS_PROVEEDOR_PRODUTOS' AND  DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}') AS SAIDA,
                (SELECT coalesce(SUM(ENTRADA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND TABELA = 'NOTA_CREDITOS_DETALHES' AND DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}') AS SAIDA_NC_CLI,
                ( (SELECT coalesce(SUM(ENTRADA - SAIDA), 0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:inicio]}') + (SELECT coalesce(SUM(ENTRADA - SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND  DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}') ) AS SALDO_PERIODO,
                (SELECT coalesce(SUM(ENTRADA - SAIDA),0) FROM STOCKS WHERE PRODUTO_ID = P.ID) AS SALDO_STOCK

          FROM PRODUTOS P
          WHERE   (SELECT coalesce(COUNT(ID),0) FROM STOCKS WHERE PRODUTO_ID = P.ID AND DATA < '#{params[:final]}') > 0 #{clase} #{grupo} #{produto}
          ORDER BY 11 DESC, 3"

          Produto.find_by_sql( sql )
  end

end
