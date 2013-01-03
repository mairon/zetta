#!/bin/env ruby
# encoding: utf-8

class Contabilidade < ActiveRecord::Base

  #RELATORIOS CONTABEIS==========================================================#
  def self.livro_compra(params)                    #

    filtro = "date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 12"

    filtro_mq_usado = "date_part('month', C.DATA_EMICAO) = '#{params[:mes]}'  AND  date_part('year', C.DATA_EMICAO) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 12"

    filtro_nc = "date_part('month', NC.DATA) = '#{params[:mes]}'  AND  date_part('year', NC.DATA) = '#{params[:ano]}'"
 
    sql = "SELECT 
                  C.ID,
                  C.COMPRA_ID,
                  C.DATA,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  C.TIPO,
                  C.PERSONA_TIMBRADO  AS TIMBRADO,
                  CP.RUBRO_DESCRICAO AS RN,
                  C.TIPO_COMPRA,
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  C.PERSONA_RUC,
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  COMPRAS_DOCUMENTOS C 
           INNER JOIN 
                  MOEDAS M
           ON     C.DATA = M.DATA
           LEFT JOIN 
                  COMPRAS CP
           ON     C.COMPRA_ID = CP.ID

           WHERE  #{filtro}

           UNION ALL 

           SELECT C.ID,
                  CAST(0 AS INTEGER),
                  C.DATA_EMICAO,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_TIMBRADO AS TIMBRADO,
                  CAST('---' AS VARCHAR) AS RN,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  CAST('--' AS VARCHAR),
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  VENDAS_ENTRADA_PRODUTOS C 
           LEFT JOIN 
                  MOEDAS M
           ON     C.DATA_EMICAO = M.DATA
           WHERE  #{filtro_mq_usado}


           UNION ALL
           
           SELECT
                 NC.ID,
                 CAST(0 AS INTEGER),                 
                 NC.DATA,
                 M.COTACAO_OFICIAL_VENDA AS COT_VD,                 
                 NC.TIPO,   
                 CAST('--' AS VARCHAR),    
                 CAST('---' AS VARCHAR) AS RN,
                 CAST(4 AS INTEGER),                                                                              
                 NC.DOCUMENTO_NUMERO_01 AS DN_01,
                 NC.DOCUMENTO_NUMERO_02 AS DN_02,
                 NC.DOCUMENTO_NUMERO AS DN,
                 NC.MOEDA,                 
                 NC.DOCUMENTO_ID,
                 NC.PERSONA_NOME,
                 NC.RUC AS PERSONA_RUC,     
                 NC.EXENTA_GUARANI AS EXG,
                 NC.EXENTA_DOLAR AS EXD,
                 NC.GRAVADA_05_GUARANI AS GV_05_G,
                 NC.GRAVADA_05_DOLAR AS GV_05_D,
                 NC.IMPOSTO_05_GUARANI AS IP_05_G,
                 NC.IMPOSTO_05_DOLAR AS IP_05_D,
                 NC.GRAVADA_10_GUARANI AS GV_10_G,
                 NC.GRAVADA_10_DOLAR AS  GV_10_D,
                 NC.IMPOSTO_10_GUARANI AS IP_10_G, 
                 NC.IMPOSTO_10_DOLAR AS IP_10_D,
                 NC.TOTAL_GUARANI AS TOT_G, 
                 NC.TOTAL_DOLAR AS TOT_D
           FROM 
                 NOTA_CREDITOS NC
           LEFT JOIN 
                  MOEDAS M
           ON    NC.DATA = M.DATA
                       
           WHERE #{filtro_nc}

           ORDER BY 3,1 "

     ComprasDocumento.find_by_sql(sql)
  end

  def self.livro_venda(params)                     #

    filtro = "date_part('month', data) = '#{params[:mes]}'  AND  date_part('year', data) = '#{params[:ano]}'"

    sql = "SELECT 
                  CAST(0 AS integer) AS def,
                  id,
                  tabela_id,
                  documento_numero_01,
                  documento_numero_02,
                  documento_numero,
                  tipo,
                  status,
                  moeda,
                  data,
                  ruc,
                  persona_id,
                  persona_nome,
                  total_guarani,
                  exentas_guarani,
                  gravadas_05_guarani,
                  imposto_05_guarani,
                  gravadas_10_guarani,
                  imposto_10_guarani,
                  total_dolar,
                  exentas_dolar,
                  gravadas_05_dolar,
                  imposto_05_dolar,
                  gravadas_10_dolar,
                  imposto_10_dolar
         FROM FATURAS
         WHERE  #{filtro}  
                         
         UNION ALL
         
         SELECT
               CAST(1 AS integer) AS def,         
               id,
               CAST(0 AS integer) AS tabela_id,
               documento_numero_01,
               documento_numero_02,
               documento_numero,
               tipo,
               CAST(0 AS INTEGER) AS status,
               moeda,
               data,
               CAST('---' AS VARCHAR) AS ruc,
               persona_id,
               persona_nome,
               TOTAL_GUARANI AS total_guarani,
               CAST(0 AS INTEGER) AS exentas_guarani,
               CAST(0 AS INTEGER) AS gravadas_05_guarani,
               CAST(0 AS INTEGER) AS imposto_05_guarani,
               TOTAL_GUARANI AS gravadas_10_guarani,
               CAST(0 AS INTEGER) AS imposto_10_guarani,
               TOTAL_DOLAR AS total_dolar,
               CAST(0 AS INTEGER) AS exentas_dolar,
               CAST(0 AS INTEGER) AS gravadas_05_dolar,
               CAST(0 AS INTEGER) As imposto_05_dolar,
               TOTAL_DOLAR AS gravadas_10_dolar,
               CAST(0 AS INTEGER) AS imposto_10_dolar
         FROM NOTA_CREDITO_PROVEEDORS         
         WHERE  #{filtro}
        
         ORDER BY 10,6"
                  
    Fatura.find_by_sql(sql)
  end

  def self.livro_diario(params)                    #

      if params[:lancamento].to_s != "1"
         if params[:moeda] == "0"
            moeda = "AND D.MOEDA = 0"
         elsif params[:moeda] == "1"
            moeda = "AND D.MOEDA = 1"
          else
            moeda = "AND D.MOEDA = 2"
         end
      end

    filtro = "D.DATA BETWEEN '#{params[:inicio]}'  AND  '#{params[:final]}' #{moeda}"

    Diario.find_by_sql("SELECT
                                  D.ID,
                                  0 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( DD.CONTABILIDADE AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( P.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  DD.VALOR_GUARANI AS DEBE_GS,
                                  DD.VALOR_DOLAR AS DEBE_US,
                                  0.00 AS HABER_GS,
                                  0.00 AS HABER_US

                            FROM
                                  DIARIOS D
                            LEFT JOIN
                                  DIARIO_DEBES DD
                                  ON ( DD.DIARIO_ID=D.ID )
                            LEFT JOIN
                                  PLANO_DE_CONTAS P
                                  ON ( P.CODIGO=DD.CONTABILIDADE )
                            WHERE
                                 #{filtro}

                            UNION ALL

                            SELECT
                                  D.ID,
                                  1 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( DH.CONTABILIDADE AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( P.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  0.00 AS DEBE_GS,
                                  0.00 AS DEBE_US,
                                  DH.VALOR_GUARANI AS HABER_GS,
                                  DH.VALOR_DOLAR AS HABER_US

                            FROM
                                  DIARIOS D
                            LEFT JOIN
                                  DIARIO_HABERS DH
                                  ON ( DH.DIARIO_ID=D.ID )
                            LEFT JOIN
                                  PLANO_DE_CONTAS P
                                  ON ( P.CODIGO=DH.CONTABILIDADE )
                            WHERE
                                 #{filtro}

                            UNION ALL

                            SELECT
                                  D.ID,
                                  2 AS ORDEM,
                                  D.DATA,
                                  ( SELECT SIGLA FROM DOCUMENTOS WHERE NOME = D.DOCUMENTO_NOME ) AS SIGLA,
                                  D.TABELA_ID,
                                  D.DOCUMENTO_NUMERO_01,
                                  D.DOCUMENTO_NUMERO_02,
                                  D.DOCUMENTO_NUMERO,
                                  D.TABELA_NOME,
                                  CAST( ' ' AS VARCHAR(25) ) AS CONTABILIDADE,
                                  CAST( D.DESCRICAO AS VARCHAR(80) ) AS DESCRIPCION,
                                  (SELECT COALESCE(SUM(SDD.VALOR_GUARANI),0 ) FROM DIARIO_DEBES SDD WHERE SDD.DIARIO_ID = D.ID ) AS DEBE_GS,
                                  (SELECT COALESCE(SUM(SDD.VALOR_DOLAR),0 ) FROM DIARIO_DEBES SDD WHERE SDD.DIARIO_ID = D.ID ) AS DEBE_US,
                                  (SELECT COALESCE(SUM(SDH.VALOR_GUARANI),0 ) FROM DIARIO_HABERS SDH WHERE SDH.DIARIO_ID = D.ID ) AS HABER_GS,
                                  (SELECT COALESCE(SUM(SDH.VALOR_DOLAR),0 ) FROM DIARIO_HABERS SDH WHERE SDH.DIARIO_ID = D.ID ) AS HABER_US

                            FROM
                                  DIARIOS D
                            WHERE
                                 #{filtro}

                            ORDER BY
                                  3, 1, 2

            ")
  end

  def self.livro_mayor(params)             

        if params[:lancamento].to_s != "1"
         if params[:moeda] == "0"
            moeda = "AND D.MOEDA = 0"
         elsif params[:moeda] == "1"
            moeda = "AND D.MOEDA = 1"
          else
            moeda = "AND D.MOEDA = 2"
         end
      end
    filtro  = "AND CONTABILIDADE  BETWEEN  '#{params[:codigo_inicio]}' AND '#{params[:codigo_final]}' #{moeda}" unless params[:codigo_inicio].blank?

    sql = "
        SELECT
              DD.DIARIO_ID,
              DD.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DD.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DD.VALOR_GUARANI AS DEBE_GS,
              DD.VALOR_DOLAR AS DEBE_US,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_US,
              D.ID
        FROM
              DIARIO_DEBES DD
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DD.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DD.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
              #{filtro}
        UNION ALL
        SELECT
              DH.DIARIO_ID,
              DH.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DH.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_US,
              DH.VALOR_GUARANI AS HABER_GS,
              DH.VALOR_DOLAR AS HABER_US,
              D.ID
        FROM
              DIARIO_HABERS DH
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DH.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DH.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
              #{filtro}
        ORDER BY
              2, 3, 4, 5,11

        "
    Diario.find_by_sql(sql)
  end

  def self.livro_mayor_produtos(params)                     #
    dd_prod  = " AND dd.produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    dd_clase = " AND dd.clase_id  = #{params[:busca]["clase"]}"  unless params[:busca]["clase"].blank?
    dd_grupo = " AND dd.grupo_id  = #{params[:busca]["grupo"]}"  unless params[:busca]["grupo"].blank?
    
    dh_prod  = " AND dh.produto_id  = #{params[:busca]["produto"]}"  unless params[:busca]["produto"].blank?
    dh_clase = " AND dh.clase_id  = #{params[:busca]["clase"]}"  unless params[:busca]["clase"].blank?
    dh_grupo = " AND dh.grupo_id  = #{params[:busca]["grupo"]}"  unless params[:busca]["grupo"].blank?

    filtro  = "AND CONTABILIDADE  BETWEEN  '#{params[:codigo_inicio]}' AND '#{params[:codigo_final]}'" unless params[:codigo_inicio].blank?

    sql = "
        SELECT
              DD.DIARIO_ID,
              DD.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DD.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DD.CLASE_ID,
              DD.GRUPO_ID,
              DD.PRODUTO_ID,
              DD.PRODUTO_NOME,
              DD.VALOR_GUARANI AS DEBE_GS,
              DD.VALOR_DOLAR AS DEBE_US,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS HABER_US,
              D.ID
        FROM
              DIARIO_DEBES DD
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DD.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DD.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
              #{filtro} #{dd_prod} #{dd_clase} #{dd_grupo}
        UNION ALL
        SELECT
              DH.DIARIO_ID,
              DH.CONTABILIDADE,
              P.DESCRICAO AS CONTABILIDADE_DESCRICAO,
              DH.DATA,
              D.TABELA_NOME,
              D.TABELA_ID AS PROCESO_NUMERO,
              D.DOCUMENTO_NOME,
              D.DOCUMENTO_NUMERO,
              D.DESCRICAO,
              DH.CLASE_ID,
              DH.GRUPO_ID,
              DH.PRODUTO_ID,
              DH.PRODUTO_NOME,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_GS,
              CAST( 0.00 AS NUMERIC(15,2) ) AS DEBER_US,
              DH.VALOR_GUARANI AS HABER_GS,
              DH.VALOR_DOLAR AS HABER_US,
              D.ID
        FROM
              DIARIO_HABERS DH
        LEFT JOIN
              DIARIOS D
              ON ( D.ID=DH.DIARIO_ID )
        LEFT JOIN
              PLANO_DE_CONTAS P
              ON ( P.CODIGO=DH.CONTABILIDADE )
        WHERE
              D.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
              #{filtro} #{dh_prod} #{dh_clase} #{dh_grupo}
        ORDER BY
              2, 3, 4, 5,11

        "
    Diario.find_by_sql(sql)
  end


  def self.balance(params)                         #

    filtro = "data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"

    PlanoDeConta.all(:order => 'codigo')

  end

  def self.balance_general(params)                 #

    filtro = "data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"

    PlanoDeConta.all(:order => 'codigo')

  end

  def self.resumo_compra(params)                          #

    filtro = "date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 11"

    filtro_mq_usado = "date_part('month', C.DATA_EMICAO) = '#{params[:mes]}'  AND  date_part('year', C.DATA_EMICAO) = '#{params[:ano]}' AND C.DOCUMENTO_ID > 1 AND C.DOCUMENTO_ID < 4 OR date_part('month', C.DATA) = '#{params[:mes]}'  AND  date_part('year', C.DATA) = '#{params[:ano]}' AND C.DOCUMENTO_ID = 11"

    filtro_nc = "date_part('month', NC.DATA) = '#{params[:mes]}'  AND  date_part('year', NC.DATA) = '#{params[:ano]}'"
 
    sql = "SELECT 
                  C.ID,
                  C.COMPRA_ID,
                  C.RUBRO_ID,
                  C.RUBRO_NOME,
                  C.DATA,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  C.TIPO,
                  C.PERSONA_TIMBRADO  AS TIMBRADO,
                  CP.RUBRO_DESCRICAO AS RN,
                  C.TIPO_COMPRA,
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  C.PERSONA_RUC,
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  COMPRAS_DOCUMENTOS C 
           INNER JOIN 
                  MOEDAS M
           ON     C.DATA = M.DATA
           LEFT JOIN 
                  COMPRAS CP
           ON     C.COMPRA_ID = CP.ID

           WHERE  #{filtro}

           UNION ALL 

           SELECT C.ID,
                  CAST(0 AS INTEGER),
                  CAST(0 AS INTEGER),
                  CAST('COMPRAS' AS VARCHAR),
                  C.DATA_EMICAO,
                  M.COTACAO_OFICIAL_VENDA AS COT_VD,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_TIMBRADO AS TIMBRADO,
                  CAST('---' AS VARCHAR) AS RN,
                  CAST(0 AS INTEGER),
                  C.DOCUMENTO_NUMERO_01 AS DN_01,
                  C.DOCUMENTO_NUMERO_02 AS DN_02,
                  C.DOCUMENTO_NUMERO    AS DN,
                  C.MOEDA,
                  C.DOCUMENTO_ID,
                  C.PERSONA_NOME,
                  CAST('--' AS VARCHAR),
                  C.EXENTAS_GUARANI AS EXG,
                  C.EXENTAS_DOLAR  AS EXD ,
                  C.GRAVADAS_05_GUARANI AS GV_05_G,
                  C.GRAVADAS_05_DOLAR  AS GV_05_D,
                  C.IMPOSTO_05_GUARANI AS IP_05_G,
                  C.IMPOSTO_05_DOLAR AS IP_05_D,
                  C.GRAVADAS_10_GUARANI AS GV_10_G,
                  C.GRAVADAS_10_DOLAR AS GV_10_D,
                  C.IMPOSTO_10_GUARANI AS IP_10_G,
                  C.IMPOSTO_10_DOLAR AS IP_10_D,       
                  C.TOTAL_GUARANI AS TOT_G,
                  C.TOTAL_DOLAR AS TOT_D
           FROM   
                  VENDAS_ENTRADA_PRODUTOS C 
           LEFT JOIN 
                  MOEDAS M
           ON     C.DATA_EMICAO = M.DATA
           WHERE  #{filtro_mq_usado}


           UNION ALL
           
           SELECT
                 NC.ID,
                 CAST(0 AS INTEGER),  
                 CAST(0 AS INTEGER),   
                 CAST('COMPRAS' AS VARCHAR),                             
                 NC.DATA,
                 M.COTACAO_OFICIAL_VENDA AS COT_VD,                 
                 NC.TIPO,   
                 CAST('--' AS VARCHAR),    
                 CAST('---' AS VARCHAR) AS RN,
                 CAST(4 AS INTEGER),                                                                              
                 NC.DOCUMENTO_NUMERO_01 AS DN_01,
                 NC.DOCUMENTO_NUMERO_02 AS DN_02,
                 NC.DOCUMENTO_NUMERO AS DN,
                 NC.MOEDA,                 
                 NC.DOCUMENTO_ID,
                 NC.PERSONA_NOME,
                 CAST('--' AS VARCHAR),     
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 0 AND NOTA_CREDITO_ID = NC.ID) AS EXG,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 0 AND NOTA_CREDITO_ID = NC.ID) AS EXD,
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS GV_05_G,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS GV_05_D,
                 ( SELECT SUM(TOTAL_GUARANI / 11) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS IP_05_G,
                 ( SELECT SUM(TOTAL_DOLAR / 11) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 5 AND NOTA_CREDITO_ID = NC.ID) AS IP_05_D,
                 ( SELECT SUM(TOTAL_GUARANI) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS GV_10_G,
                 ( SELECT SUM(TOTAL_DOLAR) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS  GV_10_D,
                 ( SELECT SUM(TOTAL_GUARANI  / 11 ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS IP_10_G, 
                 ( SELECT SUM(TOTAL_DOLAR / 11 ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS IP_10_D,
                 ( SELECT SUM(TOTAL_GUARANI ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS TOT_G, 
                 ( SELECT SUM(TOTAL_DOLAR ) FROM NOTA_CREDITOS_DETALHES WHERE TAXA = 10 AND NOTA_CREDITO_ID = NC.ID) AS TOT_D
           FROM 
                 NOTA_CREDITOS NC
           LEFT JOIN 
                  MOEDAS M
           ON    NC.DATA = M.DATA
                       
           WHERE #{filtro_nc}

           ORDER BY 3,1 "

     ComprasDocumento.find_by_sql(sql)  
  end
  
  def self.resumo_vendas(params)                     #

    filtro = "DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"

   sql = "SELECT 
                  CAST(0 AS integer) AS def,
                  id,
                  tabela_id,
                  documento_numero_01,
                  documento_numero_02,
                  documento_numero,
                  tipo,
                  status,
                  moeda,
                  data,
                  ruc,
                  persona_id,
                  persona_nome,
                  total_guarani,
                  exentas_guarani,
                  gravadas_05_guarani,
                  imposto_05_guarani,
                  gravadas_10_guarani,
                  imposto_10_guarani,
                  total_dolar,
                  exentas_dolar,
                  gravadas_05_dolar,
                  imposto_05_dolar,
                  gravadas_10_dolar,
                  imposto_10_dolar
         FROM FATURAS
         WHERE  #{filtro}  
                         
         UNION ALL
         
         SELECT
               CAST(1 AS integer) AS def,         
               id,
               CAST(0 AS integer) AS tabela_id,
               documento_numero_01,
               documento_numero_02,
               documento_numero,
               tipo,
               CAST(0 AS INTEGER) AS status,
               moeda,
               data,
               CAST('---' AS VARCHAR) AS ruc,
               persona_id,
               persona_nome,
               TOTAL_GUARANI AS total_guarani,
               CAST(0 AS INTEGER) AS exentas_guarani,
               CAST(0 AS INTEGER) AS gravadas_05_guarani,
               CAST(0 AS INTEGER) AS imposto_05_guarani,
               TOTAL_GUARANI AS gravadas_10_guarani,
               CAST(0 AS INTEGER) AS imposto_10_guarani,
               TOTAL_DOLAR AS total_dolar,
               CAST(0 AS INTEGER) AS exentas_dolar,
               CAST(0 AS INTEGER) AS gravadas_05_dolar,
               CAST(0 AS INTEGER) As imposto_05_dolar,
               TOTAL_DOLAR AS gravadas_10_dolar,
               CAST(0 AS INTEGER) AS imposto_10_dolar
         FROM NOTA_CREDITO_PROVEEDORS         
         WHERE  #{filtro}
        
         ORDER BY 10,6"
                  
    Fatura.find_by_sql(sql)
  end
  
  def self.generar_acientos_contables(params)      #

    #FILTRO MES ANO
    filtro = "DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"
    filtro_fin = "data_financa BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"
    filtro_diferido_mes_anterior = "date_part('month', data) < '#{params[:mes]}' AND date_part('month', DIFERIDO) = '#{params[:mes]}' AND DATA <> DIFERIDO"
    filtro_diferido_mes = "date_part('month', DIFERIDO) = '#{params[:mes]}' AND DATA <> DIFERIDO "

    #ELIMINA LANCAMENTOS QUANDO TABELA_ID FOR NULL
    Diario.destroy_all("#{filtro}      AND TABELA_ID IS NOT NULL" )
    DiarioDebe.destroy_all("#{filtro}  AND TABELA_ID IS NOT NULL" )
    DiarioHaber.destroy_all("#{filtro} AND TABELA_ID IS NOT NULL" )




    #lancamento contabil cobros
    cobros = Cobro.all( :conditions =>  filtro + 'AND ADELANTO <> 1' )
  
    cobros.each do |c|

      diario =  Diario.create( :tabela_id        => c.id.to_i,
                               :tabela_nome      => 'COBROS',
                               :data             => c.data,
                               :cotacao          => c.cotacao.to_f,
                               :moeda            => c.moeda,
                               :descricao        => 'COBRO  ' + c.persona_nome.to_s + ' doc. ' + c.documento_numero.to_s,
                               :documento_id     => c.documento_id,
                               :documento_nome   => c.documento_nome,
                               :documento_numero => c.documento_numero )

        #DEBITO FINANCAS
        cobro_financa = CobrosFinanca.all( :conditions => ["cobro_id = ?", c.id.to_i] )

          cobro_financa.each do |cbf|

            cod_contabil_conta     = Conta.find_by_id( cbf.conta_id,:select => 'id,cod_contabil,rubro_nome' );

            
            

              DiarioDebe.create( :tabela_id        => cbf.id.to_i,
                                 :tabela_nome      => 'COBROS FINANCAS',
                                 :diario_id        => diario.id,
                                 :data             => c.data,
                                 :contabilidade    => cod_contabil_conta.cod_contabil,
                                 :descricao        => cod_contabil_conta.rubro_nome,
                                 :cotacao          => c.cotacao.to_f,
                                 :valor_dolar      => cbf.cheque_valor_dolar,
                                 :valor_guarani    => cbf.cheque_valor_guarani )
          
        end

        #HABER CLIENTE
        cobro_detalhe = CobrosDetalhe.all( :conditions => ["cobro_id = ?", c.id.to_i] )

        cobro_detalhe.each do |cbd|

          if c.clase_produto == 0
            cod = '1.02.01.001'
            desc_cod = 'Clientes Repuestos'
          else
            cod = '1.02.01.002'
            desc_cod = 'Clientes Máquinas'
          end


          DiarioHaber.create( :tabela_id        => cbd.id.to_i,
                              :tabela_nome      => 'COBROS DETALHES',
                              :diario_id        => diario.id,
                              :data             => c.data,
                              :contabilidade    => cod,
                              :descricao        => desc_cod,
                              :cotacao          => c.cotacao.to_f,
                              :valor_dolar      => cbd.cobro_dolar,
                              :valor_guarani    => cbd.cobro_guarani )

          if cbd.interes_guarani.to_f > 0

            DiarioHaber.create( :tabela_id        => cbd.id.to_i,
                :tabela_nome      => 'COBROS DETALHES',
                :diario_id        => diario.id,
                :data             => c.data,
                :contabilidade    => '4.02.01.002',
                :descricao        => 'INTERESES COBRADOS',
                :cotacao          => c.cotacao.to_f,
                :valor_dolar      => cbd.interes_dolar,
                :valor_guarani    => cbd.interes_guarani )
          end

        end
    end 






    #lancamento contabil pagos
    pagos = Pago.all( :conditions =>  filtro + 'AND ADELANTO <> 1' )
  
    pagos.each do |p|

      pagos_fin = PagosFinanca.last(:conditions => ["pago_id = ?", p.id])
      if pagos_fin != nil
      diario =  Diario.create( :tabela_id        => p.id.to_i,
                               :tabela_nome      => 'PAGOS',
                               :data             => pagos_fin.data,
                               :cotacao          => p.cotacao.to_f,
                               :moeda            => p.moeda,
                               :descricao        => 'PAGO  ' + p.persona_nome.to_s + ' doc. ' + pagos_fin.numero_recibo.to_s,
                               :documento_id     => pagos_fin.documento_id,
                               :documento_nome   => pagos_fin.documento_nome,
                               :documento_numero => pagos_fin.numero_recibo )
    else

      diario =  Diario.create( :tabela_id        => p.id.to_i,
                               :tabela_nome      => 'PAGOS',
                               :data             => p.data,
                               :cotacao          => p.cotacao.to_f,
                               :moeda            => p.moeda,
                               :descricao        => 'PAGO  ' + p.persona_nome.to_s + ' doc. ')

    end

        #CREDITO FINANCAS
        pagos_financa = PagosFinanca.all( :conditions => ["pago_id = ?", p.id.to_i] )

          pagos_financa.each do |pf|

            cod_contabil_conta     = Conta.find_by_id( pf.conta_id,:select => 'id,cod_contabil,rubro_nome' )

          
            DiarioHaber.create( :tabela_id        => pf.id.to_i,
                               :tabela_nome      => 'PAGOS_FINANCAS',
                               :diario_id        => diario.id,
                               :data             => p.data,
                               :contabilidade    => cod_contabil_conta.cod_contabil,
                               :descricao        => cod_contabil_conta.rubro_nome,
                               :cotacao          => p.cotacao.to_f,
                               :valor_dolar      => pf.valor_dolar,
                               :valor_guarani    => pf.valor_guarani )
        end

        #DEBITO PROV
        pagos_detalhe = PagosDetalhe.all( :conditions => ["pago_id = ?", p.id.to_i] )

        pagos_detalhe.each do |pd|

          if p.clase_produto == 0
            cod = '2.01.01.001'
            desc_cod = 'Proveedores repuestos'
          else
            cod = '2.01.01.002'
            desc_cod = 'Proveedores Máquinas'
          end


          DiarioDebe.create( :tabela_id        => pd.id.to_i,
                              :tabela_nome      => 'PAGOS_DETALHES',
                              :diario_id        => diario.id,
                              :data             => p.data,
                              :contabilidade    => cod,
                              :descricao        => desc_cod,
                              :cotacao          => p.cotacao.to_f,
                              :valor_dolar      => pd.pago_dolar,
                              :valor_guarani    => pd.pago_guarani )

        end
    end 



    #lancamento contabil tranferencia
    trs = TransferenciaConta.all( :conditions => filtro )
  
    trs.each do |t|

      diario =  Diario.create( :tabela_id        => t.id.to_i,
                               :tabela_nome      => 'TRANSFERENCIA_CONTAS',
                               :data             => t.data,
                               :cotacao          => t.cotacao.to_f,
                               :descricao        => t.concepto,
                               :moeda            => t.ingreso_moeda,
                               :documento_id     => t.documento_id,
                               :documento_nome   => t.documento_nome)

        #DEBITO FINANCAS
        trs_detalhes = TransferenciaContasDetalhe.all( :conditions => ["transferencia_conta_id = ?", t.id.to_i] )

          trs_detalhes.each do |td|

            destino_rubro   = Conta.find_by_id( td.conta_destino_id,:select => 'id,cod_contabil,rubro_nome' );

            

            DiarioDebe.create( :tabela_id        => td.id.to_i,
                               :tabela_nome      => 'COBROS FINANCAS',
                               :diario_id        => diario.id,
                               :data             => t.data,
                               :contabilidade    => destino_rubro.cod_contabil,
                               :descricao        => destino_rubro.rubro_nome,
                               :cotacao          => t.cotacao.to_f,
                               :valor_dolar      => td.saida_dolar,
                               :valor_guarani    => td.saida_guarani )


            origem_rubro = Conta.find_by_id( td.conta_origem_id,:select => 'id,cod_contabil,rubro_nome' );

            

            DiarioHaber.create( :tabela_id        => td.id.to_i,
                               :tabela_nome      => 'COBROS FINANCAS',
                               :diario_id        => diario.id,
                               :data             => t.data,
                               :contabilidade    => origem_rubro.cod_contabil,
                               :descricao        => origem_rubro.rubro_nome,
                               :cotacao          => t.cotacao.to_f,
                               :valor_dolar      => td.saida_dolar,
                               :valor_guarani    => td.saida_guarani )

        end

    end



    #lancamento contabil gastos
    gastos = Compra.all( :conditions => filtro_fin + ' AND TIPO_COMPRA = 1' )
  
    gastos.each do |g|
      compra_finacas = ComprasFinanca.all
      diario =  Diario.create( :tabela_id        => g.id.to_i,
                               :tabela_nome      => 'COMPRAS_GASTOS',
                               :data             => g.data_financa,
                               :cotacao          => g.cotacao.to_f,
                               :descricao        => g.descricao + ' Doc. ' + g.documento_numero_01 + '-' + g.documento_numero_02 + '-' + g.documento_numero ,
                               :moeda            => g.moeda,
                               :documento_id     => g.documento_id,
                               :documento_nome   => g.documento_nome,
                               :documento_numero_01 => g.documento_numero_01,
                               :documento_numero_02 => g.documento_numero_02,
                               :documento_numero => g.documento_numero)


        #DEBITO RUBRO
        compra_doc = ComprasGasto.all( :conditions => ["compra_id = ?", g.id.to_i] )

          compra_doc.each do |cd|

            DiarioDebe.create( :tabela_id        => cd.id.to_i,
                               :tabela_nome      => 'COMPRAS_GASTOS',
                               :diario_id        => diario.id,
                               :data             => g.data_financa,
                               :persona_id       => cd.persona_id,
                               :persona_nome     => cd.persona_nome,
                               :contabilidade    => cd.rubro_cod_contabil,
                               :descricao        => cd.rubro_descricao,
                               :cotacao          => g.cotacao.to_f,
                               :valor_dolar      => (cd.gravadas_10_dolar.to_f + cd.gravadas_05_dolar.to_f + cd.exentas_dolar.to_f) -(cd.imposto_10_dolar.to_f + cd.imposto_05_dolar.to_f),
                               :valor_guarani    => (cd.gravadas_10_guarani.to_f + cd.gravadas_05_guarani.to_f + cd.exentas_guarani.to_f ) -(cd.imposto_10_guarani.to_f + cd.imposto_05_guarani.to_f))      

            if (cd.imposto_10_dolar.to_f + cd.imposto_05_dolar.to_f) > 0 

              DiarioDebe.create( :tabela_id        => cd.id.to_i,
                                 :tabela_nome      => 'COMPRAS_GASTOS',
                                 :diario_id        => diario.id,
                                 :data             => g.data_financa,
                                 :persona_id       => cd.persona_id,
                                 :persona_nome     => cd.persona_nome,
                                 :contabilidade    => '1.02.03.001',
                                 :descricao        => 'IVA CREDITO FISCAL',
                                 :cotacao          => g.cotacao.to_f,
                                 :valor_dolar      => cd.imposto_10_dolar.to_f + cd.imposto_05_dolar.to_f,
                                 :valor_guarani    => cd.imposto_10_guarani.to_f + cd.imposto_05_guarani.to_f )      
            end       
          end

          #CREDITO FINANZAS/CLIENTE
          compra_finacas = ComprasFinanca.all( :conditions => ["compra_id = ?", g.id.to_i] )

            compra_finacas.each do |cf|

              if cf.tipo == 0 
                conta   = Conta.find_by_id( cf.conta_id,:select => 'id,cod_contabil,rubro_nome' );            
                DiarioHaber.create( :tabela_id        => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => g.data_financa,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => conta.cod_contabil,
                                   :descricao        => conta.rubro_nome,
                                   :cotacao          => g.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              else

                if g.clase_produto == 0
                  cod = '2.01.01.001'
                  desc_cod = 'Proveedores repuestos'
                else
                  cod = '2.01.01.002'
                  desc_cod = 'Proveedores Máquinas'
                end

                DiarioHaber.create( :tabela_id       => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => g.data_financa,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => cod,
                                   :descricao        => desc_cod,
                                   :cotacao          => g.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              end   
          end
      end



    #lancamento contabil compra
    compras = Compra.all( :conditions => filtro + ' AND TIPO_COMPRA = 0' )
  
    compras.each do |c|

      diario =  Diario.create( :tabela_id        => c.id.to_i,
                               :tabela_nome      => 'COMPRAS',
                               :data             => c.data,
                               :cotacao          => c.cotacao.to_f,
                               :descricao        => c.descricao + ' Prov. ' + c.persona_nome + ' Doc. ' + c.documento_numero_01 + '-' + c.documento_numero_02 + '-' + c.documento_numero ,
                               :moeda            => c.moeda,
                               :documento_id     => c.documento_id,
                               :documento_nome   => c.documento_nome,
                               :documento_numero_01 => c.documento_numero_01,
                               :documento_numero_02 => c.documento_numero_02,
                               :documento_numero => c.documento_numero)


        #DEBITO RUBRO
        compra_pros = ComprasProduto.all( :conditions => ["compra_id = ?", c.id.to_i] )

          imp_us = 0
          imp_gs = 0
          compra_pros.each do |cp|
            if cp.tipo_compra == 0
              rubro = '1.03.01.001'
              desc  = 'Mercaderias Repuestos'
            else
              rubro = '1.03.01.002'
              desc  = 'Mercaderias Maquinarias'
            end 


            DiarioDebe.create( :tabela_id        => cp.id.to_i,
                               :tabela_nome      => 'COMPRAS_PRODUTOS',
                               :diario_id        => diario.id,
                               :data             => c.data,
                               :persona_id       => cp.persona_id,
                               :persona_nome     => cp.persona_nome,
                               :produto_id       => cp.produto_id,
                               :produto_nome     => cp.produto_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => ( cp.quantidade.to_f * cp.custo_contabil_dolar.to_f ),
                               :valor_guarani    => ( cp.quantidade.to_f * cp.custo_contabil_guarani.to_f ) )      

          imp_us += ( cp.quantidade.to_f * cp.iva_dolar.to_f )
          imp_gs += ( cp.quantidade.to_f * cp.iva_guarani.to_f ) 

          end
              DiarioDebe.create( :tabela_id        => c.id.to_i,
                                 :tabela_nome      => 'COMPRAS_GASTOS',
                                 :diario_id        => diario.id,
                                 :data             => c.data,
                                 :persona_id       => c.persona_id,
                                 :persona_nome     => c.persona_nome,
                                 :contabilidade    => '1.02.03.001',
                                 :descricao        => 'IVA CREDITO FISCAL',
                                 :cotacao          => c.cotacao.to_f,
                                 :valor_dolar      => imp_us,
                                 :valor_guarani    => imp_gs )      


          #CREDITO FINANZAS/CLIENTE
          compra_finacas = ComprasFinanca.all( :conditions => ["compra_id = ?", c.id.to_i] )

            compra_finacas.each do |cf|

              if cf.tipo == 0 
                conta   = Conta.find_by_id( cf.conta_id,:select => 'id,cod_contabil,rubro_nome' );

                DiarioHaber.create( :tabela_id        => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => conta.cod_contabil,
                                   :descricao        => conta.rubro_nome,
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              else

                if c.clase_produto == 0
                  cod = '2.01.01.001'
                  desc_cod = 'Proveedores repuestos'
                else
                  cod = '2.01.01.002'
                  desc_cod = 'Proveedores Máquinas'
                end

                DiarioHaber.create( :tabela_id       => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => cod,
                                   :descricao        => desc_cod,
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              end   
          end
      end





    #lancamento contabil vendas
    vendas = Venda.all( :conditions => filtro_fin)
  
    vendas.each do |v|

      diario =  Diario.create( :tabela_id        => v.id.to_i,
                               :tabela_nome      => 'VENDAS',
                               :data             => v.data_financa,
                               :cotacao          => v.cotacao.to_f,
                               :descricao        => 'Venta '+ v.persona_nome.to_s + ' doc. ' + v.documento_numero_01.to_s + '-' + v.documento_numero_02.to_s + '-' + v.documento_numero.to_s,
                               :moeda            => v.moeda,
                               :documento_id     => v.documento_id,
                               :documento_nome   => v.documento_nome,
                               :documento_numero_01 => v.documento_numero_01,
                               :documento_numero_02 => v.documento_numero_02,
                               :documento_numero => v.documento_numero)


        #DEBITO RUBRO
        venda_pros = VendasProduto.all( :conditions => ["venda_id = ?", v.id.to_i] )

          imp_us = 0
          imp_gs = 0
          venda_pros.each do |vp|
            if v.clase_produto == 0
              rubro = '4.01.01.001'
              desc  = 'Ventas Repuestos'
            else
              rubro = '4.01.01.002'
              desc  = 'Ventas Maquinarias'
            end 


            DiarioHaber.create( :tabela_id        => vp.id.to_i,
                               :tabela_nome      => 'VENDAS_PRODUTOS',
                               :diario_id        => diario.id,
                               :data             => diario.data,
                               :persona_id       => vp.persona_id,
                               :persona_nome     => vp.persona_nome,
                               :produto_id       => vp.produto_id,
                               :produto_nome     => vp.produto_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => v.cotacao.to_f,
                               :valor_dolar      => ( vp.quantidade.to_f * ( vp.unitario_dolar.to_f - vp.iva_dolar ) ),
                               :valor_guarani    => ( vp.quantidade.to_f * ( vp.unitario_guarani.to_f - vp.iva_guarani) ) )     

          imp_us += ( vp.quantidade.to_f * vp.iva_dolar.to_f )
          imp_gs += ( vp.quantidade.to_f * vp.iva_guarani.to_f ) 

          end
              DiarioHaber.create( :tabela_id        => v.id.to_i,
                                 :tabela_nome      => 'VENDAS_GASTOS',
                                 :diario_id        => diario.id,
                                 :data             => diario.data,
                                 :persona_id       => v.persona_id,
                                 :persona_nome     => v.persona_nome,
                                 :contabilidade    => '2.04.01.003',
                                 :descricao        => 'IVA DEBITO FISCAL',
                                 :cotacao          => v.cotacao.to_f,
                                 :valor_dolar      => imp_us,
                                 :valor_guarani    => imp_gs )      


          #CREDITO FINANZAS/CLIENTE
          venda_finacas = VendasFinanca.all( :conditions => ["venda_id = ?", v.id.to_i] )

            venda_finacas.each do |vf|

              if vf.tipo == 0 
                conta   = Conta.find_by_id( vf.conta_id,:select => 'id,cod_contabil,rubro_nome' );

                DiarioDebe.create( :tabela_id        => vf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => diario.data,
                                   :persona_id       => vf.persona_id,
                                   :persona_nome     => vf.persona_nome,
                                   :contabilidade    => conta.cod_contabil,
                                   :descricao        => conta.rubro_nome,
                                   :cotacao          => v.cotacao.to_f,
                                   :valor_dolar      => vf.valor_dolar_contado,
                                   :valor_guarani    => vf.valor_guarani_contado )      
              else

                if v.clase_produto == 0
                  cod = '1.02.01.001'
                  desc_cod = 'Clientes Repuestos'
                else
                  cod = '1.02.01.002'
                  desc_cod = 'Clientes Máquinas'
                end

                DiarioDebe.create( :tabela_id       => vf.id.to_i,
                                   :tabela_nome      => 'VENDAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => diario.data,
                                   :persona_id       => vf.persona_id,
                                   :persona_nome     => vf.persona_nome,
                                   :contabilidade    => cod,
                                   :descricao        => desc_cod,
                                   :cotacao          => v.cotacao.to_f,
                                   :valor_dolar      => vf.cota_dolar_01,
                                   :valor_guarani    => vf.cota_guarani_01 )      
              end   
          end
      end

    #lancamento contabil adelantos
    adelantos = Adelanto.all( :conditions => filtro)
  
    adelantos.each do |a|
      diario =  Diario.create( :tabela_id        => a.id.to_i,
                               :tabela_nome      => 'ADELANTOS',
                               :data             => a.data,
                               :cotacao          => a.cotacao.to_f,
                               :descricao        => 'Antecipo '+ a.persona_nome.to_s + ' doc. ' + a.documento_numero.to_s,
                               :moeda            => a.moeda,
                               :documento_id     => a.documento_id,
                               :documento_nome   => a.documento_nome,
                               :documento_numero => a.documento_numero )

    #entrada
    if  a.status == 0

      #proveedor
      if a.tipo == 0

        if a.clase_produto == 0
          cod = '2.01.01.001'
          desc_cod = 'Proveedores repuestos'
        else
          cod = '2.01.01.002'
          desc_cod = 'Proveedores Máquinas'
        end

        DiarioHaber.create( :tabela_id       => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :persona_id       => a.persona_id,
                           :persona_nome     => a.persona_nome,
                           :contabilidade    => cod,
                           :descricao        => desc_cod,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )      


        cod_contabil_conta     = Conta.find_by_id( a.conta_id,:select => 'id,cod_contabil,rubro_nome' );

        DiarioDebe.create( :tabela_id        => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :contabilidade    => cod_contabil_conta.cod_contabil,
                           :descricao        => cod_contabil_conta.rubro_nome,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )        
      #entrada cliente
      else

        if a.clase_produto == 0
          cod = '1.02.01.001'
          desc_cod = 'Clientes Repuestos'
        else
          cod = '1.02.01.002'
          desc_cod = 'Clientes Máquinas'
        end

        DiarioHaber.create( :tabela_id       => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :persona_id       => a.persona_id,
                           :persona_nome     => a.persona_nome,
                           :contabilidade    => cod,
                           :descricao        => desc_cod,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )      


        cod_contabil_conta     = Conta.find_by_id( a.conta_id,:select => 'id,cod_contabil,rubro_nome' );

        DiarioDebe.create( :tabela_id        => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :contabilidade    => cod_contabil_conta.cod_contabil,
                           :descricao        => cod_contabil_conta.rubro_nome,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )        


      end

    #saida
    else

      #proveedor
      if a.tipo == 0

        if a.clase_produto == 0
          cod = '2.01.01.001'
          desc_cod = 'Proveedores repuestos'
        else
          cod = '2.01.01.002'
          desc_cod = 'Proveedores Máquinas'
        end

        DiarioDebe.create( :tabela_id       => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :persona_id       => a.persona_id,
                           :persona_nome     => a.persona_nome,
                           :contabilidade    => cod,
                           :descricao        => desc_cod,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )      


        cod_contabil_conta     = Conta.find_by_id( a.conta_id,:select => 'id,cod_contabil,rubro_nome' );

        DiarioHaber.create( :tabela_id        => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :contabilidade    => cod_contabil_conta.cod_contabil,
                           :descricao        => cod_contabil_conta.rubro_nome,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )        
      #entrada cliente
      else

        if a.clase_produto == 0
          cod = '1.02.01.001'
          desc_cod = 'Clientes Repuestos'
        else
          cod = '1.02.01.002'
          desc_cod = 'Clientes Máquinas'
        end

        DiarioDebe.create( :tabela_id       => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :persona_id       => a.persona_id,
                           :persona_nome     => a.persona_nome,
                           :contabilidade    => cod,
                           :descricao        => desc_cod,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )      


        cod_contabil_conta     = Conta.find_by_id( a.conta_id,:select => 'id,cod_contabil,rubro_nome' );

        DiarioHaber.create( :tabela_id        => a.id.to_i,
                           :tabela_nome      => 'ADELANTOS',
                           :diario_id        => diario.id,
                           :data             => a.data,
                           :contabilidade    => cod_contabil_conta.cod_contabil,
                           :descricao        => cod_contabil_conta.rubro_nome,
                           :cotacao          => a.cotacao.to_f,
                           :valor_dolar      => a.valor_dolar,
                           :valor_guarani    => a.valor_guarani )        


      end
    end

  end



    #nota_credito cliente
    nota_credito_cl = NotaCredito.all( :conditions => filtro)
  
    nota_credito_cl.each do |ncl|
      diario =  Diario.create( :tabela_id        => ncl.id.to_i,
                               :tabela_nome      => 'NOTA_CREDITO_CLIENTE',
                               :data             => ncl.data,
                               :cotacao          => ncl.cotacao.to_f,
                               :descricao        => ncl.concepto ,
                               :moeda            => ncl.moeda,
                               :documento_id     => ncl.documento_id,
                               :documento_nome   => ncl.documento_nome,
                               :documento_numero_01 =>  ncl.documento_numero_01,
                               :documento_numero_02 =>  ncl.documento_numero_02,
                               :documento_numero => ncl.documento_numero )

      #devolucao
      if ncl.operacao == 0

        nc_detalhe = NotaCreditosDetalhe.all( :conditions => ["nota_credito_id = ?", ncl.id.to_i] )  

        imp_us = 0
        imp_gs = 0
        nc_detalhe.each do |ncd|

          if ncl.clase_produto == 0
            rubro = '1.03.01.001'
            desc  = 'Mercaderias Repuestos'
          else
            rubro = '1.03.01.002'
            desc  = 'Mercaderias Maquinarias'
          end 

          DiarioDebe.create( :tabela_id          => ncd.id.to_i,
                               :tabela_nome      => 'NOTA_CREDITOS_DETALHES',
                               :diario_id        => diario.id,
                               :data             => ncd.data,
                               :persona_id       => ncd.persona_id,
                               :persona_nome     => ncd.persona_nome,
                               :produto_id       => ncd.produto_id,
                               :produto_nome     => ncd.produto_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => ncl.cotacao.to_f,
                               :valor_dolar      => ncd.quantidade * ( ncd.unitario_dolar - ncd.iva_dolar ),
                               :valor_guarani    => ncd.quantidade * ( ncd.unitario_guarani - ncd.iva_guarani ) )     
        imp_us += ( ncd.quantidade.to_f * ncd.iva_dolar.to_f )
        imp_gs += ( ncd.quantidade.to_f * ncd.iva_guarani.to_f ) 

        end

        DiarioDebe.create( :tabela_id        => ncl.id.to_i,
                           :tabela_nome      => 'NOTA_CREDITOS',
                           :diario_id        => diario.id,
                           :data             => ncl.data,
                           :persona_id       => ncl.persona_id,
                           :persona_nome     => ncl.persona_nome,
                           :contabilidade    => '1.02.03.001',
                           :descricao        => 'IVA CREDITO FISCAL',
                           :cotacao          => ncl.cotacao.to_f,
                           :valor_dolar      => imp_us,
                           :valor_guarani    => imp_gs )      

        if ncl.clase_produto == 0
          cod = '1.02.01.001'
          desc_cod = 'Clientes Repuestos'
        else
          cod = '1.02.01.002'
          desc_cod = 'Clientes Máquinas'
        end

        DiarioHaber.create( :tabela_id          => ncl.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITOS',
                             :diario_id        => diario.id,
                             :data             => ncl.data,
                             :persona_id       => ncl.persona_id,
                             :persona_nome     => ncl.persona_nome,
                             :contabilidade    => cod,
                             :descricao        => desc_cod,
                             :cotacao          => ncl.cotacao.to_f,
                             :valor_dolar      => ncl.total_dolar,
                             :valor_guarani    => ncl.total_guarani )     


      #desconto
      else

        if ncl.clase_produto == 0
          cod_des = '4.03.01.003'
          desc_des = 'Descuentos Recibidos Repuestos'
        else
          cod_des = '4.03.01.004'
          desc_des = 'Descuentos Recibidos Maquinarias'
        end

        DiarioDebe.create( :tabela_id          => ncl.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITOS',
                             :diario_id        => diario.id,
                             :data             => ncl.data,
                             :persona_id       => ncl.persona_id,
                             :persona_nome     => ncl.persona_nome,
                             :contabilidade    => cod_des,
                             :descricao        => desc_des,
                             :cotacao          => ncl.cotacao.to_f,
                             :valor_dolar      => ncl.total_dolar,
                             :valor_guarani    => ncl.total_guarani )     


        if ncl.clase_produto == 0
          cod = '1.02.01.001'
          desc_cod = 'Clientes Repuestos'
        else
          cod = '1.02.01.002'
          desc_cod = 'Clientes Máquinas'
        end

        DiarioHaber.create( :tabela_id          => ncl.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITOS',
                             :diario_id        => diario.id,
                             :data             => ncl.data,
                             :persona_id       => ncl.persona_id,
                             :persona_nome     => ncl.persona_nome,
                             :contabilidade    => cod,
                             :descricao        => desc_cod,
                             :cotacao          => ncl.cotacao.to_f,
                             :valor_dolar      => ncl.total_dolar,
                             :valor_guarani    => ncl.total_guarani )     

      end

    end 








    #nota_credito proveedor
    nota_credito_pr = NotaCreditoProveedor.all( :conditions => filtro)
  
    nota_credito_pr.each do |np|
      diario =  Diario.create( :tabela_id        => np.id.to_i,
                               :tabela_nome      => 'NOTA_CREDITO_PROVEEDOR',
                               :data             => np.data,
                               :cotacao          => np.cotacao.to_f,
                               :descricao        => (np.concepto.to_s + ' doc. ' + np.documento_numero_01.to_s + '-' + np.documento_numero_02.to_s + '-' + np.documento_numero.to_s ),
                               :moeda            => np.moeda,
                               :documento_id     => np.documento_id,
                               :documento_nome   => np.documento_nome,
                               :documento_numero_01 =>  np.documento_numero_01,
                               :documento_numero_02 =>  np.documento_numero_02,
                               :documento_numero => np.documento_numero )

      #devolucao
      if np.operacao == 0

        nc_prov_prod = NotaCreditoProveedorProduto.all( :conditions => ["nota_credito_proveedor_id = ?", np.id.to_i] )  

        imp_us = 0
        imp_gs = 0
        nc_prov_prod.each do |ncp|

          if np.clase_produto == 0
            rubro = '1.03.01.001'
            desc  = 'Mercaderias Repuestos'
          else
            rubro = '1.03.01.002'
            desc  = 'Mercaderias Maquinarias'
          end 

          DiarioHaber.create( :tabela_id          => ncp.id.to_i,
                               :tabela_nome      => 'NOTA_CREDITOS_PRODUTOS',
                               :diario_id        => diario.id,
                               :data             => np.data,
                               :persona_id       => np.persona_id,
                               :persona_nome     => np.persona_nome,
                               :produto_id       => ncp.produto_id,
                               :produto_nome     => ncp.produto_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => ncp.cotacao.to_f,
                               :valor_dolar      => ncp.quantidade * ( ncp.unitario_dolar - ncp.iva_dolar ),
                               :valor_guarani    => ncp.quantidade * ( ncp.unitario_guarani - ncp.iva_guarani ) )     
        imp_us += ( ncp.quantidade.to_f * ncp.iva_dolar.to_f )
        imp_gs += ( ncp.quantidade.to_f * ncp.iva_guarani.to_f ) 

        end

        DiarioHaber.create( :tabela_id        => np.id.to_i,
                           :tabela_nome      => 'NOTA_CREDITO_PROVEEDOR',
                           :diario_id        => diario.id,
                           :data             => np.data,
                           :persona_id       => np.persona_id,
                           :persona_nome     => np.persona_nome,
                           :contabilidade    => '1.02.03.001',
                           :descricao        => 'IVA CREDITO FISCAL',
                           :cotacao          => np.cotacao.to_f,
                           :valor_dolar      => imp_us,
                           :valor_guarani    => imp_gs )      

        if np.clase_produto == 0
          cod = '2.02.01.001'
          desc_cod = 'Proveedores repuestos'
        else
          cod = '2.02.01.002'
          desc_cod = 'Proveedores Máquinas'
        end

        DiarioDebe.create( :tabela_id          => np.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITO_PROVEEDOR',
                             :diario_id        => diario.id,
                             :data             => np.data,
                             :persona_id       => np.persona_id,
                             :persona_nome     => np.persona_nome,
                             :contabilidade    => cod,
                             :descricao        => desc_cod,
                             :cotacao          => np.cotacao.to_f,
                             :valor_dolar      => np.total_dolar,
                             :valor_guarani    => np.total_guarani )     


      #desconto
      else

        if np.clase_produto == 0
          cod_des = '4.03.01.003'
          desc_des = 'Descuentos Recibidos Repuestos'
        else
          cod_des = '4.03.01.004'
          desc_des = 'Descuentos Recibidos Maquinarias'
        end

        DiarioHaber.create( :tabela_id          => np.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITO_PROVEEDOR',
                             :diario_id        => diario.id,
                             :data             => np.data,
                             :persona_id       => np.persona_id,
                             :persona_nome     => np.persona_nome,
                             :contabilidade    => cod_des,
                             :descricao        => desc_des,
                             :cotacao          => np.cotacao.to_f,
                             :valor_dolar      => np.total_dolar,
                             :valor_guarani    => np.total_guarani )     


        if np.clase_produto == 0
          cod = '2.02.01.001'
          desc_cod = 'Proveedores repuestos'
        else
          cod = '2.02.01.002'
          desc_cod = 'Proveedores Máquinas'
        end

        DiarioDebe.create( :tabela_id          => np.id.to_i,
                             :tabela_nome      => 'NOTA_CREDITO_PROVEEDOR',
                             :diario_id        => diario.id,
                             :data             => np.data,
                             :persona_id       => np.persona_id,
                             :persona_nome     => np.persona_nome,
                             :contabilidade    => cod,
                             :descricao        => desc_cod,
                             :cotacao          => np.cotacao.to_f,
                             :valor_dolar      => np.total_dolar,
                             :valor_guarani    => np.total_guarani )     

      end

    end 




    #ingresso
    ing = Ingresso.all( :conditions => filtro)
  
    ing.each do |i|
      diario =  Diario.create( :tabela_id        => i.id.to_i,
                               :tabela_nome      => 'INGRESSOS',
                               :data             => i.data,
                               :cotacao          => i.cotacao.to_f,
                               :descricao        => i.concepto,
                               :moeda            => i.moeda,
                               :documento_id     => i.documento_id,
                               :documento_nome   => i.documento_nome )

            #debe conta
            cod_contabil_conta     = Conta.find_by_id( i.conta_id,:select => 'id,cod_contabil,rubro_nome' );
          
            DiarioDebe.create( :tabela_id        => i.id.to_i,
                               :tabela_nome      => 'INGRESSOS',
                               :diario_id        => diario.id,
                               :data             => i.data,
                               :contabilidade    => cod_contabil_conta.cod_contabil,
                               :descricao        => cod_contabil_conta.rubro_nome,
                               :cotacao          => i.cotacao.to_f,
                               :valor_dolar      => i.valor_dolar,
                               :valor_guarani    => i.valor_guarani )


            #haber conta
            DiarioHaber.create( :tabela_id        => i.id.to_i,
                               :tabela_nome      => 'INGRESSOS',
                               :diario_id        => diario.id,
                               :data             => i.data,
                               :contabilidade    => i.rubro_codigo,
                               :descricao        => i.rubro_nome,
                               :cotacao          => i.cotacao.to_f,
                               :valor_dolar      => i.valor_dolar,
                               :valor_guarani    => i.valor_guarani )

    end



    #egressoa
    egr = Egresso.all( :conditions => filtro)
  
    egr.each do |e|
      diario =  Diario.create( :tabela_id        => e.id.to_i,
                               :tabela_nome      => 'EGRESSOS',
                               :data             => e.data,
                               :cotacao          => e.cotacao.to_f,
                               :descricao        => e.concepto,
                               :moeda            => e.moeda,
                               :documento_id     => e.documento_id,
                               :documento_nome   => e.documento_nome )

            #debe conta
            cod_contabil_conta     = Conta.find_by_id( e.conta_id,:select => 'id,cod_contabil,rubro_nome' );
          
            DiarioHaber.create( :tabela_id        => e.id.to_i,
                               :tabela_nome      => 'EGRESSOS',
                               :diario_id        => diario.id,
                               :data             => e.data,
                               :contabilidade    => cod_contabil_conta.cod_contabil,
                               :descricao        => cod_contabil_conta.rubro_nome,
                               :cotacao          => e.cotacao.to_f,
                               :valor_dolar      => e.valor_dolar,
                               :valor_guarani    => e.valor_guarani )


            #haber conta
            DiarioDebe.create( :tabela_id        => e.id.to_i,
                               :tabela_nome      => 'EGRESSOS',
                               :diario_id        => diario.id,
                               :data             => e.data,
                               :contabilidade    => e.rubro_codigo,
                               :descricao        => e.rubro_nome,
                               :cotacao          => e.cotacao.to_f,
                               :valor_dolar      => e.valor_dolar,
                               :valor_guarani    => e.valor_guarani )

    end








    #lancamento contabil importacao
    compras_imp = Compra.all( :conditions => filtro + ' AND TIPO_COMPRA = 2' )
  
    compras_imp.each do |c|

      diario =  Diario.create( :tabela_id        => c.id.to_i,
                               :tabela_nome      => 'COMPRAS',
                               :data             => c.data,
                               :cotacao          => c.cotacao.to_f,
                               :descricao        => 'Compra de Importacion ' + ' Prov. ' + c.persona_nome + ' Doc. ' + c.documento_numero_01 + '-' + c.documento_numero_02 + '-' + c.documento_numero ,
                               :moeda            => c.moeda,
                               :documento_id     => c.documento_id,
                               :documento_nome   => c.documento_nome,
                               :documento_numero_01 => c.documento_numero_01,
                               :documento_numero_02 => c.documento_numero_02,
                               :documento_numero => c.documento_numero)


        #DEBITO PRODUTOS
        compra_pros = ComprasProduto.all( :conditions => ["compra_id = ?", c.id.to_i] )

          imp_us = 0
          imp_gs = 0
          compra_pros.each do |cp|
            if cp.tipo_compra == 0
              rubro = '1.03.01.001'
              desc  = 'Mercaderias Repuestos'
            else
              rubro = '1.03.01.002'
              desc  = 'Mercaderias Maquinarias'
            end 


            DiarioDebe.create( :tabela_id        => cp.id.to_i,
                               :tabela_nome      => 'COMPRAS_PRODUTOS',
                               :diario_id        => diario.id,
                               :data             => c.data,
                               :persona_id       => cp.persona_id,
                               :persona_nome     => cp.persona_nome,
                               :produto_id       => cp.produto_id,
                               :produto_nome     => cp.produto_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => ( cp.quantidade.to_f * cp.custo_contabil_dolar.to_f ),
                               :valor_guarani    => ( cp.quantidade.to_f * cp.custo_contabil_guarani.to_f ) )      


                DiarioHaber.create( :tabela_id        => c.id.to_i,
                                   :tabela_nome      => 'COMPRAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => c.persona_id,
                                   :persona_nome     => c.persona_nome,
                                   :contabilidade    => '1.03.01.003',
                                   :descricao        => 'Importaciones en Curso',
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => ( cp.quantidade.to_f * cp.custo_contabil_dolar.to_f ),
                                   :valor_guarani    => ( cp.quantidade.to_f * cp.custo_contabil_guarani.to_f ) )      

          end
                DiarioDebe.create( :tabela_id        => c.id.to_i,
                                   :tabela_nome      => 'COMPRAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => c.persona_id,
                                   :persona_nome     => c.persona_nome,
                                   :contabilidade    => '1.03.01.003',
                                   :descricao        => 'Importaciones en Curso',
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => c.iva_despacho_dolar,
                                   :valor_guarani    => c.iva_despacho_guarani )      


          #CREDITO IMPORTACAO EM CURSO
                DiarioHaber.create( :tabela_id        => c.id.to_i,
                                   :tabela_nome      => 'COMPRAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => c.persona_id,
                                   :persona_nome     => c.persona_nome,
                                   :contabilidade    => '1.03.01.003',
                                   :descricao        => 'Importaciones en Curso',
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => c.iva_despacho_dolar,
                                   :valor_guarani    => c.iva_despacho_guarani )      


        compra_doc = ComprasDocumento.all( :conditions => ["compra_id = ?", c.id.to_i] )

        compra_doc.each do |cd|
          if cd.documento_id.to_i != 11
            DiarioHaber.create( :tabela_id        => cd.id.to_i,
                               :tabela_nome      => 'COMPRAS_DOCUMENTOS',
                               :diario_id        => diario.id,
                               :data             => cd.data,
                               :persona_id       => cd.persona_id,
                               :persona_nome     => cd.persona_nome,
                               :contabilidade    => '1.03.01.003',
                               :descricao        => 'Importaciones en Curso',
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => cd.total_dolar,
                               :valor_guarani    => cd.total_guarani )      

            if cd.tipo_compra == 0
              rubro = '1.03.01.001'
              desc  = 'Mercaderias Repuestos'
            else
              rubro = '1.03.01.002'
              desc  = 'Mercaderias Maquinarias'
            end 


            DiarioDebe.create( :tabela_id        => cd.id.to_i,
                               :tabela_nome      => 'COMPRAS_DOCUMENTOS',
                               :diario_id        => diario.id,
                               :data             => cd.data,
                               :persona_id       => cd.persona_id,
                               :persona_nome     => cd.persona_nome,
                               :contabilidade    => rubro,
                               :descricao        => desc,
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => cd.total_dolar,
                               :valor_guarani    => cd.total_guarani )      

        end

        end
      end






    #contra aciento contabil importacao
    compras_imp = Compra.all( :conditions => filtro + ' AND TIPO_COMPRA = 2' )
  
    compras_imp.each do |c|

      diario =  Diario.create( :tabela_id        => c.id.to_i,
                               :tabela_nome      => 'COMPRAS',
                               :data             => c.data,
                               :cotacao          => c.cotacao.to_f,
                               :descricao        => 'Compra de Importacion ' + ' Prov. ' + c.persona_nome + ' Doc. ' + c.documento_numero_01 + '-' + c.documento_numero_02 + '-' + c.documento_numero ,
                               :moeda            => c.moeda,
                               :documento_id     => c.documento_id,
                               :documento_nome   => c.documento_nome,
                               :documento_numero_01 => c.documento_numero_01,
                               :documento_numero_02 => c.documento_numero_02,
                               :documento_numero => c.documento_numero)


        #DEBITO PRODUTOS
        compra_pros = ComprasProduto.all( :conditions => ["compra_id = ?", c.id.to_i] )

          imp_us = 0
          imp_gs = 0
          compra_pros.each do |cp|
            if cp.tipo_compra == 0
              rubro = '1.03.01.001'
              desc  = 'Mercaderias Repuestos'
            else
              rubro = '1.03.01.002'
              desc  = 'Mercaderias Maquinarias'
            end 


                DiarioDebe.create( :tabela_id        => c.id.to_i,
                                   :tabela_nome      => 'COMPRAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => c.persona_id,
                                   :persona_nome     => c.persona_nome,
                                   :contabilidade    => '1.03.01.003',
                                   :descricao        => 'Importaciones en Curso',
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => ( cp.quantidade.to_f * cp.custo_contabil_dolar.to_f ),
                                   :valor_guarani    => ( cp.quantidade.to_f * cp.custo_contabil_guarani.to_f ) )      

          end


          #CREDITO IMPORTACAO EM CURSO
                DiarioDebe.create( :tabela_id        => c.id.to_i,
                                   :tabela_nome      => 'COMPRAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => c.persona_id,
                                   :persona_nome     => c.persona_nome,
                                   :contabilidade    => '1.03.01.003',
                                   :descricao        => 'Importaciones en Curso',
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => c.iva_despacho_dolar,
                                   :valor_guarani    => c.iva_despacho_guarani )      


        compra_doc = ComprasDocumento.all( :conditions => ["compra_id = ?", c.id.to_i] )

        compra_doc.each do |cd|
          if cd.documento_id.to_i != 11
            DiarioDebe.create( :tabela_id        => cd.id.to_i,
                               :tabela_nome      => 'COMPRAS_DOCUMENTOS',
                               :diario_id        => diario.id,
                               :data             => cd.data,
                               :persona_id       => cd.persona_id,
                               :persona_nome     => cd.persona_nome,
                               :contabilidade    => '1.03.01.003',
                               :descricao        => 'Importaciones en Curso',
                               :cotacao          => c.cotacao.to_f,
                               :valor_dolar      => cd.total_dolar,
                               :valor_guarani    => cd.total_guarani )      
          end
        end


          #CREDITO FINANZAS/CLIENTE
          compra_finacas = ComprasFinanca.all( :conditions => ["compra_id = ?", c.id.to_i] )

            compra_finacas.each do |cf|

              if cf.tipo == 0 
                conta   = Conta.find_by_id( cf.conta_id,:select => 'id,cod_contabil,rubro_nome' );

                DiarioHaber.create( :tabela_id        => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => conta.cod_contabil,
                                   :descricao        => conta.rubro_nome,
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              else

                if c.clase_produto == 0
                  cod = '2.01.01.001'
                  desc_cod = 'Proveedores repuestos'
                else
                  cod = '2.01.01.002'
                  desc_cod = 'Proveedores Máquinas'
                end

                DiarioHaber.create( :tabela_id       => cf.id.to_i,
                                   :tabela_nome      => 'COMPRAS FINANCAS',
                                   :diario_id        => diario.id,
                                   :data             => c.data,
                                   :persona_id       => cf.persona_id,
                                   :persona_nome     => cf.persona_nome,
                                   :contabilidade    => cod,
                                   :descricao        => desc_cod,
                                   :cotacao          => c.cotacao.to_f,
                                   :valor_dolar      => cf.valor_dolar,
                                   :valor_guarani    => cf.valor_guarani )      
              end   
          end


      end

  end
  
end

  
