class Cliente < ActiveRecord::Base
    belongs_to :venda

    def before_create
        if self.documento_numero == ''
         self.documento_numero = '999'<< Cliente.count(:id).to_s
         self.documento_numero_01 = '000'
         self.documento_numero_02 = '000'
        end 
    end 
    def before_save
        @persona = Persona.find_by_id(self.persona_id);
        self.persona_nome = @persona.nome.to_s unless self.persona_id.blank?    

    end

    def self.relatorio_contas_receber(params)

        pers      = "AND C.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        vend      = "AND C.VENDEDOR_ID = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        liq_open  = "AND C.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND C.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.moeda = 1"
            else
              moeda = "AND C.moeda = 2"
           end
        end

        if params[:clase] == "0"
            clase     = "AND C.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND C.clase_produto = 1"
        else
            clase     = ""
        end
        
        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond = "C.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{vend}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "C.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{vend}"
        end
        if params[:tipo_cliente].to_s == "0"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 0"
        elsif params[:tipo_cliente] == "1"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 1"
        else 
         sub_cons = ""
        end

        Cliente.find_by_sql("SELECT 
                                   C.id,
                                   C.data,
                                   P.id AS PERSONA_ID,
                                   P.nome AS PERSONA_NOME,
                                   P.ruc,
                                   P.telefone,
                                   C.vendedor_id,
                                   C.vendedor_nome,
                                   C.local_pago,
                                   C.documento_numero_01,
                                   C.documento_numero_02,
                                   C.documento_numero,
	                                 C.documento_nome,                                   
	                                 C.cota,
	                                 C.tabela,
	                                 C.liquidacao,
	                                 C.venda_id,
	                                 C.cheque,
	                                 C.vencimento,
	                                 C.divida_guarani,
	                                 C.divida_dolar,
                                   C.divida_real,
	                                 C.cobro_guarani,
	                                 C.cobro_dolar,
                                   C.cobro_real

                              FROM 
                                   CLIENTES C
                              LEFT JOIN PERSONAS P 
                              ON  C.PERSONA_ID = P.ID
                              WHERE #{cond} #{sub_cons} ORDER BY  4,2,13,14,1" )
    end


    def self.contas_receber_planilha_detalhado(params)

        pers      = "AND PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        persvp    = "AND VP.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        vend      = "AND VENDEDOR_ID = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        vendv     = "AND V.VENDEDOR_ID = #{params[:busca]["vendedor"]} " unless params[:busca]["vendedor"].blank?
        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda   = "AND moeda = 0"
              moedavp = "AND VP.moeda = 0"
           elsif params[:moeda] == "1"
              moeda   = "AND moeda = 1"
              moedaVP = "AND VP.moeda = 1"
            else
              moeda   = "AND moeda = 2"
              moedaVP = "AND VP.moeda = 2"              
           end

        end

        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond   = "data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}'#{pers} #{moeda} #{vend}"
            condvp = "VP.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{persvp} #{moedavp} #{vendv}"

        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "C.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{vend}"
            cond = "C.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{vend}"
        end

     sql="SELECT 
                CAST(1 AS INTEGER) AS ORDEM,
                V.ID AS ID,
                VP.DATA,
                V.VENDEDOR_NOME,
                V.PERSONA_NOME,
                VP.PRODUTO_ID,
                VP.PRODUTO_NOME,
                V.DOCUMENTO_NUMERO AS FATURA,
                VP.QUANTIDADE,
                VP.DATA AS VENC,
                CAST(0 AS INTEGER) AS PAGARE,
                VP.TOTAL_DOLAR AS TOTAL_PRODUTO, 
                CAST(0.00 AS NUMERIC(15,2)) AS DEBITO,
                CAST(0.00 AS NUMERIC(15,2)) AS CREDITO
          FROM
                VENDAS_PRODUTOS VP
          LEFT JOIN VENDAS V 
          ON VP.VENDA_ID = V.ID
          WHERE #{condvp}  AND V.CLASE_PRODUTO = 1
 
          UNION ALL

          SELECT 
                 CAST(2 AS INTEGER) AS ORDEM,
                 VENDA_ID AS ID,
                 DATA,
                 CAST('' AS VARCHAR) AS VENDEDOR_NOME,
                 PERSONA_NOME,
                 PRODUTO_ID,
                 PRODUTO_NOME, 
                 FATURA_NUMERO AS FATURA,
                 QUANTIDADE,
                 DATA AS VENC, 
                 CAST(0 AS INTEGER) AS PAGARE,
                 CAST(0.00 AS NUMERIC(15,2)) AS TOTAL_PRODUTO,
                 CAST(0.00 AS NUMERIC(15,2)) AS DEBITO,
                 TOTAL_DOLAR AS CREDITO 
          FROM
                 VENDAS_ENTRADA_PRODUTOS
          WHERE #{cond}  AND CLASE_PRODUTO = 1

          UNION ALL
          SELECT 
                  CAST(3 AS INTEGER) AS ORDEM,
                  COD_PROC AS ID,
                  DATA,
                  VENDEDOR_NOME,
                  PERSONA_NOME,
                  CAST(0 AS INTEGER) AS PRODUTO_ID,
                  CAST('' AS VARCHAR) AS PRODUTO_NOME,
                  DOCUMENTO_NUMERO  AS FATURA,
                  CAST(0.00 AS NUMERIC(15,2)) AS QUANTIDADE,
                  VENCIMENTO AS VENC, 
                  PAGARE,
                  CAST(0.00 AS NUMERIC(15,2)) AS TOTAL_PRODUTO,
                  DIVIDA_DOLAR AS DEBITO,
                  COBRO_DOLAR AS CREDITO 
          FROM
                  CLIENTES 
          WHERE #{cond} AND COALESCE(TABELA ,'INICIO') <> 'VENDAS_ENTRADA_PRODUTOS' AND  CLASE_PRODUTO = 1

          UNION ALL
          SELECT 
                  CAST(3 AS INTEGER) AS ORDEM,
                  COD_PROC AS ID,
                  DATA,
                  VENDEDOR_NOME,
                  PERSONA_NOME,
                  CAST(0 AS INTEGER) AS PRODUTO_ID,
                  CAST('' AS VARCHAR) AS PRODUTO_NOME,
                  DOCUMENTO_NUMERO  AS FATURA,
                  CAST(0.00 AS NUMERIC(15,2)) AS QUANTIDADE,
                  VENCIMENTO AS VENC, 
                  PAGARE,
                  CAST(0.00 AS NUMERIC(15,2)) AS TOTAL_PRODUTO,
                  DIVIDA_DOLAR AS DEBITO,
                  COBRO_DOLAR AS CREDITO 
          FROM
                  CLIENTES 
          WHERE #{cond}  AND DATA <> VENCIMENTO AND TABELA <> 'VENDAS_FINANCAS'  AND TABELA <> 'COBROS_DETALHE'  AND TABELA <> 'COBROS' AND TABELA <> 'VENDAS_ENTRADA_PRODUTOS' AND CLASE_PRODUTO = 1


          ORDER BY 5,1,3,10
 "


        Cliente.find_by_sql(sql)
    end


    def self.relatorio_contas_receber_saldo_anterior(params)
        
        pers      = "AND clientes.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        liq_open  = "AND clientes.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND clientes.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND clientes.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND clientes.moeda = 1"
            else
              moeda = "AND clientes.moeda = 2"
           end
        end

        if params[:moeda] == "0"
            valor = "clientes.divida_dolar - clientes.cobro_dolar"
        elsif params[:moeda] == "1"
            valor = "clientes.divida_guarani - clientes.cobro_guarani"
        else
            valor = "clientes.divida_real - clientes.cobro_real"
        end
        if params[:clase] == "0"
            clase     = "AND clientes.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND clientes.clase_produto = 1"
        else
            clase     = ""
        end
        if params[:tipo_cliente].to_s == "0"
           sub_cons = "AND personas.TIPO_FUNCIONARIO = 0"
        elsif params[:tipo_cliente] == "1"
           sub_cons = "AND personas.TIPO_FUNCIONARIO = 1"
        else 
         sub_cons = ""
        end


        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond = "clientes.data < '#{params[:inicio_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "clientes.vencimento < '#{params[:inicio_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons}"
        end

        Cliente.sum(valor,:conditions => cond, :joins=> 'INNER JOIN  personas on clientes.persona_id = personas.id' )
    end





    def self.relatorio_por_fatura(params)
        #filtros
        pers      = "AND C.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        doc       = "AND C.DOCUMENTO_NUMERO = '#{params[:doc]}'" unless params[:doc].blank?
        liq_open  = "AND C.LIQUIDACAO = 0 #{pers} #{doc}"                     if params[:filtro] == "0"
        liq_close = "AND C.LIQUIDACAO = 1 #{pers} #{doc}"                     if params[:filtro] == "1"
        liq_all   = "#{pers} #{doc}"                                          if params[:filtro] == "2"
        city      = "AND P.cidade_id = #{params[:busca]["direcao"]}" unless params[:busca]["direcao"].blank?
        vend      = "AND C.vendedor_id = #{params[:busca]["vendedor"]}" unless params[:busca]["vendedor"].blank?

        #moeda
        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.MOEDA = 1"
          else
              moeda = "AND C.MOEDA = 2"
           end
        end
        #setor
        if params[:clase] == "0"
            clase     = "AND C.CLASE_PRODUTO = 0"
        elsif params[:clase] == "1"
            clase     = "AND C.CLASE_PRODUTO = 1"
        else
            clase     = ""
        end
        #persona funcionario
        if params[:tipo_cliente].to_s == "0"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 0"
        elsif params[:tipo_cliente] == "1"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 1"
        else 
         sub_cons = ""
        end
        #data/vencimento
        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond = "C.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons} #{city} #{vend}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "C.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons} #{city} #{vend}"
        end



    sql="SELECT                    
                  P.NOME AS PERSONA_NOME,                  
                  C.DOCUMENTO_NUMERO,                      
                  C.COTA,                
                  MIN(C.DATA) AS DATA_FAC,                                                 
                  MAX(P.RUC) AS RUC,
                  MAX(P.TELEFONE) AS TELEFONE,
                  MAX(P.CLASSIFICACAO) AS CLASSIFICACAO,
                  MAX(P.DIRECAO) AS DIRECAO,
                  MAX(P.CIDADE) AS CIDADE,
                  MAX(P.OBSERVACAO) AS OBSERVACAO,
                  MAX(P.ID) AS PERSONA_ID,
                  MAX(C.VENCIMENTO) AS VENCIMENTO,      
                  MAX(C.LIQUIDACAO) AS LIQUIDACAO,    
                  SUM(C.DIVIDA_DOLAR) AS SUM_DD,
                  SUM(C.COBRO_DOLAR) AS SUM_CD,      
                  SUM(C.DIVIDA_GUARANI) AS SUM_DG,
                  SUM(C.COBRO_GUARANI) AS SUM_CG,
                  SUM(C.DIVIDA_REAL) AS SUM_DR,
                  SUM(C.COBRO_REAL) AS SUM_CR     


         FROM 
                  CLIENTES C
         INNER JOIN 
              PERSONAS P
                  ON C.PERSONA_ID = P.ID  
         WHERE 
                            #{cond}
         GROUP BY
                  1,2,3
           ORDER BY
                    1,4,2,3,14"
    Cliente.find_by_sql(sql)

    end


	def self.contas_receber_resumido(params) #LISTADO DE CLIENTE RESUMIDO POR CLIENTE
	
        pers      = "AND C.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        liq_open  = "AND C.LIQUIDACAO = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND C.LIQUIDACAO = 1 #{pers}"                      if params[:filtro] == "1"
        liq_all   = "#{pers}"                                                         if params[:filtro] == "2"

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND C.MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND C.MOEDA = 1"
            else
              moeda = "AND C.MOEDA = 2"
           end
        end

        if params[:clase] == "0"
            clase     = "AND C.CLASE_PRODUTO = 0"
        elsif params[:clase] == "1"
            clase     = "AND C.CLASE_PRODUTO = 1"
        else
            clase     = ""
        end
        if params[:tipo_cliente].to_s == "0"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 0"
        elsif params[:tipo_cliente] == "1"
           sub_cons = "AND P.TIPO_FUNCIONARIO = 1"
        else 
         sub_cons = ""
        end

        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond = "C.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "C.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{sub_cons}"
        end

		sql="SELECT 
                  P.ID AS PERSONA_ID,
                  P.NOME,
                  MAX(P.TELEFONE) AS TELEFONE,
						      SUM( C.DIVIDA_DOLAR ) AS DIV_US,
						      SUM( C.COBRO_DOLAR ) AS COB_US,
                  SUM( C.DIVIDA_GUARANI ) AS DIV_GS,
                  SUM( C.COBRO_GUARANI ) AS COB_GS,
                  SUM( C.DIVIDA_REAL ) AS DIV_RS,
                  SUM( C.COBRO_REAl ) AS COB_RS,
                  (SUM( C.DIVIDA_GUARANI ) - SUM( C.COBRO_GUARANI )) AS SALDO,
							  MAX(C.VENCIMENTO) AS VENCI
				 FROM  
							CLIENTES C
				 INNER JOIN 
							PERSONAS P
				 ON C.PERSONA_ID = P.ID
				 WHERE #{cond}
				 GROUP BY 1,2
				 ORDER BY 10 DESC"
		Cliente.find_by_sql(sql)
	end


  def self.contas_receber_resumido_vencimento(params) #LISTADO DE CLIENTE RESUMIDO POR CLIENTE
  
        pers      = "P.ID = #{params[:busca]["persona"]} AND" unless params[:busca]["persona"].blank?

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND MOEDA = 1"
          else
              moeda = "AND MOEDA = 2"
           end
        end

        if params[:clase] == "0"
            clase     = "AND CLASE_PRODUTO = 0"
        elsif params[:clase] == "1"
            clase     = "AND CLASE_PRODUTO = 1"
        else
            clase     = ""
        end
        if params[:tipo_cliente].to_s == "0"
           sub_cons = "P.TIPO_FUNCIONARIO = 0 AND"
        elsif params[:tipo_cliente] == "1"
           sub_cons = "P.TIPO_FUNCIONARIO = 1 AND"
        else 
         sub_cons = ""
        end

        if !params[:inicio_faturacao].blank?


          sql="SELECT P.ID,
                      P.NOME,
                      P.TELEFONE,
                      (SELECT SUM(DIVIDA_DOLAR - COBRO_DOLAR) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final_faturacao]}' #{clase} #{moeda}) AS VENCIDA_US,
                      (SELECT SUM(DIVIDA_DOLAR - COBRO_DOLAR) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final_faturacao]}' #{clase} #{moeda}) AS A_VENCER_US,
                      (SELECT SUM(DIVIDA_GUARANI - COBRO_GUARANI) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final_faturacao]}' #{clase} #{moeda}) AS VENCIDA_GS,
                      (SELECT SUM(DIVIDA_GUARANI - COBRO_GUARANI) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final_faturacao]}' #{clase} #{moeda}) AS A_VENCER_GS,
                      (SELECT SUM(DIVIDA_REAL - COBRO_REAL) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final_faturacao]}' #{clase} #{moeda}) AS VENCIDA_RS,
                      (SELECT SUM(DIVIDA_REAL - COBRO_REAL) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final_faturacao]}' #{clase} #{moeda}) AS A_VENCER_RS,
                      (SELECT MIN(VENCIMENTO) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final_faturacao]}' #{clase} #{moeda}) AS VENCIDO_DESDE
               FROM  PERSONAS P 
               WHERE #{pers} #{sub_cons}
                     ( (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO <= '#{params[:final_faturacao]}' #{clase} #{moeda}) +
                     (SELECT COALESCE(SUM(DIVIDA_DOLAR - COBRO_DOLAR),0) FROM CLIENTES WHERE PERSONA_ID = P.ID AND LIQUIDACAO = 0 AND VENCIMENTO > '#{params[:final_faturacao]}' #{clase} #{moeda})) > 0                     
                     ORDER BY 2"
        Cliente.find_by_sql(sql)


        end
  end



  def self.relatorio_acerto_entre_contas(params)
    unless params[:busca]["persona"].blank?      
      Persona.all(:select => "id,nome,telefone,ruc", :conditions => ["ID = #{params[:busca]["persona"]} "])
    else
      Persona.all(:select => "id,nome,telefone,ruc")
    end
  end



end
