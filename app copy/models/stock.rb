class Stock < ActiveRecord::Base

    def before_save                                                      #
        @produto = Produto.find_by_id(self.produto_id);
        self.produto_nome = @produto.nome.to_s;

        @deposito = Deposito.find_by_id(self.deposito_id);
        self.deposito_nome = @deposito.nome.to_s unless self.deposito_id.blank?;

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

        cond = " data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} "

        Stock.all(:select     => "id,
                              data,
                              status,
                              venda_id,
                              produto_id,
                              produto_nome,
                              persona_nome,
                              deposito_nome,
                              entrada,
                              cod_processo,
                              persona_nome,
                              unitario_dolar,
                              unitario_guarani,
                              saida,
                              tabela_id",
            :conditions => cond,
            :order      => '2,1' )

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

        cond = "produtos.tipo_produto = 0 AND stocks.data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{filtro} #{clase} #{grupo} #{produto} #{deposito} "

        Stock.all(:select     => "stocks.id,
                              stocks.data,
                              stocks.status,
                              stocks.venda_id,
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
            :order      => '2,1' )

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
        clase   = "clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
        #GRUPO
        grupo   = "AND grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
        #PRODUTO
        produto = "AND id = #{params[:busca]["produto"]}"     unless params[:busca]["produto"].blank?

        cond    = "#{clase} #{grupo} #{produto}"

        Produto.all( :select     => ' id,
                                   clase_id,
                                   grupo_id,
                                   fabricante_cod,
                                   cod_velho,
                                   nome',
            :conditions =>   cond,
            :order      => ' clase_id,
                             grupo_id,
                             fabricante_cod' )

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
        produto = "AND VP.produto_id = #{params[:busca]["produto"]}"     unless params[:busca]["produto"].blank?

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
								    VP.PRODUTO_ID,
       							VP.CLASE_ID,
						        VP.GRUPO_ID,
						        VP.PRODUTO_NOME,
                    P.fabricante_cod,
						        VP.QUANTIDADE,
						        VP.UNITARIO_DOLAR,
						        VP.UNITARIO_GUARANI,
						        (SELECT (SUM(S.ENTRADA * S.UNITARIO_DOLAR)/SUM(S.ENTRADA)) FROM STOCKS S WHERE S.STATUS = 0 AND S.DATA <= VP.DATA AND S.PRODUTO_ID = VP.PRODUTO_ID) AS CUSTO_PROMED_US,
						        (SELECT (SUM(S.ENTRADA * S.UNITARIO_GUARANI)/SUM(S.ENTRADA)) FROM STOCKS S WHERE S.STATUS = 0 AND S.DATA <= VP.DATA AND S.PRODUTO_ID = VP.PRODUTO_ID) AS CUSTO_PROMED_GS,
                    (((VP.UNITARIO_DOLAR * VP.QUANTIDADE) - ((SELECT (SUM(S.ENTRADA * S.UNITARIO_DOLAR)/SUM(S.ENTRADA)) FROM STOCKS S WHERE S.STATUS = 0 AND S.DATA <= VP.DATA AND S.PRODUTO_ID = VP.PRODUTO_ID) * VP.QUANTIDADE ) *100) / ((SELECT (SUM(S.ENTRADA * S.UNITARIO_DOLAR)/SUM(S.ENTRADA)) FROM STOCKS S WHERE S.STATUS = 0 AND S.DATA <= VP.DATA AND S.PRODUTO_ID = VP.PRODUTO_ID) * VP.QUANTIDADE))
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
  							 #{clase} #{grupo} #{produto} #{moeda} #{fatura}
							 #{prod}
				  ORDER BY 11 DESC,3,4"

        Produto.find_by_sql( sql )

    end
end
