class Relatorios < ActiveRecord::Base

  def self.fechamento_turno(params)                #

    filtro = " data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "

    FechamentoTurno.all(:conditions => filtro,:order => 'data,bomba_nome,turno_nome')
  end

  def self.historico_precos(params)                #

    TabelaPrecoProduto.all(:conditions => [" data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND tipo = #{params[:filtro]} "],:order => 'data')
  end

  def self.tabela_preco(params)                    #
    #CONDICOES
    #CLASE
    clase   = "produtos.clase_id = #{params[:busca]["clase"]}" unless params[:busca]["clase"].blank?
    #GRUPO
    grupo   = "AND produtos.grupo_id = #{params[:busca]["grupo"]}" unless params[:busca]["grupo"].blank?
    #PRODUTO
    produto = "AND produtos.id = #{params[:busca]["produto"]}"     unless params[:busca]["produto"].blank?

    cond    = "#{clase} #{grupo} #{produto}"

    Produto.all( :select     => ' produtos.id,
                                   produtos.clase_id,
                                   produtos.grupo_id,
                                   produtos.cod_velho,
                                   produtos.nome,
                                   produtos.preco_venda_dolar,
                                   produtos.preco_venda_guarani,
                                   produtos.preco_maiorista_dolar,
                                   produtos.preco_maiorista_guarani,
                                   produtos.preco_minorista_dolar,
                                   produtos.preco_minorista_guarani,
                                   produtos.desconto
                                   ',
    :conditions =>   cond,
    :joins => "inner join clases on produtos.clase_id = clases.id inner join grupos on produtos.grupo_id = grupos.id",
    :order      => 'clases.descricao,
                                   grupos.descricao,
                                   produtos.nome' )

  end

  def self.remicao(params)                         #
    #CONDICOES
    unidade = "AND destino_unidade_id  = #{params[:busca]["unidade"]}" unless params[:busca]["unidade"].blank?
    cond    = "data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{unidade}"

    NotaRemicao.all( :select     => ' id,
                                       data,
                                       origem_unidade_nome,
                                       destino_unidade_nome',
    :conditions =>   cond,
    :order      => 'data,id' )

  end

  def self.cheque_diferido(params)                 #
    #CONDICOES
    if params[:moeda].to_s == "0"
      moeda = " AND moeda = 0"
    else
      moeda = " AND moeda = 1"
    end

    if params[:cheque].to_s == "0"
      cheque = " AND estado = 0"
    elsif params[:cheque].to_s == "1"
      cheque = " AND estado = 1"
    else
      cheque = ""
    end

    if params[:tipodt].to_s == "0"
      data = "original BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "
      ord   = "original"
    elsif params[:tipodt].to_s == "1"
      data = "data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"
      ord   = "data"
    else
      data = "depositado BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"
      ord   = "depositado"
    end
    

    numero = "AND cheque = '#{params[:numero]}'" unless params[:numero].blank?

    cond = "#{data} #{cheque} #{moeda} #{numero} ",params[:cheque],params[:moeda]

    ChequeDiferido.all( :conditions =>   cond,
    :order      => "#{ord},cheque,id,entrada_guarani" )

  end

  def self.gastos(params)                          #

    empregado  = "AND persona_id = '#{params[:busca]["empregado"]}'" unless params[:busca]["empregado"].blank?
    rodado     = "AND rodado_id = '#{params[:busca]["rodados"]}'" unless params[:busca]["rodados"].blank?
    rubro      = "AND rubro_id = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
    rubro_ori  = "AND RUBRO_INICIO_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
    rubro_dest = "AND RUBRO_FINAL_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank? 
    tipo_gasto = "AND tipo_gasto = #{params[:tipo_gasto]}" unless params[:tipo_gasto].blank?

    obra       = "AND ob_ref = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?
    obra_ori   = "AND OBRA_ORIGEM = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?
    obra_dest  = "AND OBRA_DESTINO = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?
    prov       = "AND persona_id = '#{params[:busca]["prov"]}'" unless params[:busca]["prov"].blank?
    unid       = "AND unidade_id = '#{params[:busca]["unidade"]}'" unless params[:busca]["unidade"].blank?
    st         = "AND clase_produto in (#{params[:setores].join(',')})"  unless params[:setores].blank?

    if params[:status].to_s == "0"
        status = " AND TIPO = 0"      
    elsif params[:status].to_s == "1"
        status = "AND TIPO = 1"      
    else
        status = ""      
    end

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND MOEDA = 0"
           elsif params[:moeda] == "1"
              moeda = "AND MOEDA = 1"
            else
              moeda = "AND MOEDA = 2"
           end
        end


    if params[:moeda].to_s == "0"
      tt    = "TOTAL_DOLAR"
      vl    = "VALOR_DOLAR"
    elsif params[:moeda] == "1"
      tt    = "TOTAL_GUARANI"
      vl    = "VALOR_GUARANI"
    else
      tt    = "TOTAL_REAL"
      vl    = "VALOR_REAL"      
    end
    #DETALHADO
    if params[:tp] == "0" or params[:tp] == "2" 
      sql = "SELECT ID,
                    OB_REF,
                    TOTAL_REAL,
                    (SELECT S.SIGLA FROM SETORS S WHERE S.ID = CLASE_PRODUTO) AS SETOR,
                    UNIDADE_ID,
                    PERSONA_ID,
                    PERSONA_NOME,
                    DATA,
                    DOCUMENTO_NUMERO_01,
                    DOCUMENTO_NUMERO_02,
                    DOCUMENTO_NUMERO,
                    RUBRO_DESCRICAO,
                    TOTAL_DOLAR,
                    TOTAL_GUARANI,
                    RODADO_NOME,
                    CLASE_PRODUTO,
                    QTD
            FROM COMPRAS
            WHERE
                    TIPO_COMPRA = 1 
                    AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' 
                    #{moeda}
                    #{tipo_gasto}  
                    #{empregado} 
                    #{rodado} 
                    #{rubro} 
                    #{status} 
                    #{obra} 
                    #{prov} 
                    #{unid} 
                    #{st}
            ORDER BY 8,5,16"

      Compra.find_by_sql(sql)

    #RESUMIDO POR RUBRO
    elsif params[:tp].to_s == "1"#{unid}
      sql = "SELECT R.ID,
                    R.DESCRICAO,
                    ( SELECT SUM(#{tt}) FROM COMPRAS WHERE TIPO_COMPRA = 1 AND  RUBRO_ID = R.ID #{moeda} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{tipo_gasto}  #{empregado} #{rodado} #{rubro} #{status} #{obra} #{prov} #{unid} #{st}) AS TOTAL_COMPRA
                 FROM RUBROS R
                ORDER BY 3"
      Compra.find_by_sql(sql)
    #RESUMIDO POR OBRA  
    else
      sql ="SELECT OBRA,RUBRO_ID,RUBRO_DESC, SUM(TOT) AS TOTAL, SUM(DEB_US) AS DEB_US, SUM(DEB_GS) AS DEB_GS, SUM(CRED_US) AS CRED_US, SUM(CRED_GS) AS CRED_GS
                  FROM( 
                    SELECT 
                     OB_REF  AS OBRA,
                     RUBRO_ID AS RUBRO_ID,
                     RUBRO_DESCRICAO AS RUBRO_DESC,
                     SUM(#{tt}) AS TOT,
                     SUM(0) AS DEB_US,
                     SUM(0) AS DEB_GS,
                     SUM(0) AS CRED_US,
                     SUM(0) AS CRED_GS

                    FROM COMPRAS
                    WHERE TIPO_COMPRA = 1 #{moeda} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{obra} #{rubro} #{rodado}
                    GROUP BY 1, 2, 3

                    UNION ALL

                    SELECT 
                     OBRA_ORIGEM AS OBRA,
                     RUBRO_INICIO_ID AS RUBRO_ID,
                     RUBRO_INICIO_NOME AS RUBRO_DESC,
                     SUM(0) AS TOT,
                     SUM(VALOR_DOLAR) AS DEB_US,
                     SUM(VALOR_GUARANI) AS DEB_GS,
                     SUM(0) AS CRED_US,
                     SUM(0) AS CRED_GS
                     
                    FROM LIQUIDACAO_CUSTOS
                    WHERE DATA_FINAL BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{moeda} #{obra_ori} #{rubro_ori} #{rodado}
                    GROUP BY 1, 2, 3

                    UNION ALL

                    SELECT 
                     OBRA_DESTINO AS OBRA,
                     RUBRO_FINAL_ID AS RUBRO_ID,
                     RUBRO_FINAL_NOME AS RUBRO_DESC,
                     SUM(0) AS TOT,
                     SUM(0) AS DEB_US,
                     SUM(0) AS DEB_GS,
                     SUM(VALOR_DOLAR) AS CRED_US,
                     SUM(VALOR_GUARANI) AS CRED_GS
                     
                    FROM LIQUIDACAO_CUSTOS
                    WHERE DATA_FINAL BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{moeda} #{obra_dest} #{rubro_dest} #{rodado}
                    GROUP BY 1, 2, 3

                  ) as a
                  group by 1, 2, 3
                  order by 1, 2, 3"
      Compra.find_by_sql(sql)

    end
  end

  #agrupado por setor
  def self.agrupado_setor(params)                          #

    empregado  = "AND persona_id = '#{params[:busca]["empregado"]}'" unless params[:busca]["empregado"].blank?
    rodado     = "AND rodado_id = '#{params[:busca]["rodados"]}'" unless params[:busca]["rodados"].blank?
    rubro      = "AND rubro_id = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
    tipo_gasto = "AND tipo_gasto = #{params[:tipo_gasto]}" unless params[:tipo_gasto].blank?
    obra       = "AND ob_ref = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?
    prov       = "AND persona_id = '#{params[:busca]["prov"]}'" unless params[:busca]["prov"].blank?
    unid       = "AND unidade_id = '#{params[:busca]["unidade"]}'" unless params[:busca]["unidade"].blank?
    st         = "AND clase_produto in (#{params[:setores].join(',')})"

    if params[:status].to_s == "0"
        status = " AND TIPO = 0"      
    elsif params[:status].to_s == "1"
        status = "AND TIPO = 1"      
    else
        status = ""      
    end

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND MOEDA = 0"
           elsif params[:moeda] == "0"
              moeda = "AND MOEDA = 1"
            else
              moeda = "AND MOEDA = 2"
           end
        end


    if params[:moeda].to_s == "0"
      tt    = "TOTAL_DOLAR"
      vl    = "VALOR_DOLAR"
    elsif params[:moeda] == "0"
      tt    = "TOTAL_GUARANI"
      vl    = "VALOR_GUARANI"
    else
      tt    = "TOTAL_REAL"
      vl    = "VALOR_REAL"      
    end
    #AGRUPADO POR SETOR
      sql = "SELECT 

                    CLASE_PRODUTO,
                    (SELECT S.SIGLA FROM SETORS S WHERE S.ID = CLASE_PRODUTO) AS SETOR,
                    (SELECT S.NOME FROM SETORS S WHERE S.ID = CLASE_PRODUTO) AS SETOR_NOME,
                    COUNT(ID) AS TOT_ID,
                    SUM(TOTAL_DOLAR) AS TOT_US,
                    SUM(TOTAL_GUARANI) AS TOT_GS,
                    SUM(TOTAL_REAL)  AS TOT_RS
            FROM COMPRAS
            WHERE
                    TIPO_COMPRA = 1 
                    AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' 
                    #{moeda}
                    #{tipo_gasto}  
                    #{empregado} 
                    #{rodado} 
                    #{rubro} 
                    #{status} 
                    #{obra} 
                    #{prov} 
                    #{unid} 
                    #{st}            
            GROUP BY
                    1,2
"

      Compra.find_by_sql(sql)

  end


  def self.compras(params)                         #

    if params[:moeda].to_s == "0"
      moeda   = "0"
    elsif params[:moeda].to_s == "1"
      moeda = "1"
    else
      moeda = "2"
    end

    proveedor     = "AND persona_id = '#{params[:busca]["proveedor"]}'" unless params[:busca]["proveedor"].blank?
    produto       = "AND produto_id = '#{params[:busca]["produto"]}'" unless params[:busca]["produto"].blank?
    clase_produto = "AND clase_produto = '#{params[:clase_produto]}'" unless params[:clase_produto].blank?
    tipo_compra   = "AND tipo_compra = '#{params[:tipo_compra]}'" unless params[:tipo_compra].blank?

    Compra.all(:conditions => ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND moeda = #{moeda} #{proveedor}  #{clase_produto} #{tipo_compra} "])
  end

  def self.cobros(params)                          #
    if params[:moeda].to_s == "0"
      moeda = "0"
    elsif params[:moeda].to_s == "1"
      moeda = "1"
    else
      moeda = "2"

    end

    clase_produto = "AND CLASE_PRODUTO = #{params[:clase_produto]}" unless params[:clase_produto].blank?
    
    vend = "AND VENDEDOR_ID = #{params[:busca]["empregado"]}" unless params[:busca]["empregado"].blank?

    rec = "AND DOCUMENTO_NUMERO <> ''" unless params[:recibo].blank?
    if params[:adelanto].to_s == '0'
        ant = "AND ADELANTO = 0"
    elsif params[:adelanto].to_s == '1'
        ant = "AND ADELANTO = 1"
    else
        ant = ""
    end 

    Cobro.all( :conditions => ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND MOEDA = #{moeda} #{clase_produto} #{vend} #{rec} #{ant}"],
    :order      => 'data' )
  end

  def self.pagos(params)                          #
    
    if params[:moeda].to_s == "0"
      moeda = "0"
    elsif params[:moeda].to_s == "1"
      moeda = "1"
    else 
      moeda = "2"
    end
    
    clase_produto = "AND CLASE_PRODUTO = #{params[:clase_produto]}" unless params[:clase_produto].blank?

    Pago.all( :conditions => ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND MOEDA = #{moeda} #{clase_produto}"],
    :order      => 'data' )
  end



  def self.comissao(params)                          #
    
    Persona.all(:select => 'id,nome', :conditions => ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{clase_produto}"],
    :order      => 'data' )
  end

  def self.sueldo(params)                          #

    Persona.all(:select => 'id,nome', :conditions => ["tipo_funcionario = 1"], :order      => 'nome' )

  end
  
  def self.adelantos(params)

    persona = "AND persona_id = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
    status  = "AND tipo = '#{params[:status]}'" unless params[:status] == "3"

    if params[:lancamento].to_s != "1"

      if params[:moeda] == "0"
        moeda = "AND moeda = 0"
      elsif params[:moeda] == "1"
        moeda = "AND moeda = 1"
      else        
        moeda = "AND moeda = 2"
      end

    end

    sql = "SELECT 
                 ID,
                 DATA,
			     PERSONA_NOME,
			     CONTA_NOME,
			     STATUS,
		         CHEQUE,
			     VALOR_DOLAR,
			     VALOR_GUARANI,
           VALOR_REAL,
			     CONCEPTO
           FROM
                 ADELANTOS
           WHERE 
                 DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{persona} #{status} #{moeda}"
                 
    Adelanto.find_by_sql(sql)
  end


  def self.controle_func(params)

    persona = "AND persona_id = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
    ob  = "AND ob_ref = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?

    sql = "SELECT 
                  ENTRADA_SAIDA_FUNC_ID AS ID,
                  DATA,
                  RESPONSAVEL_NOME,
                  OB_REF,
                  PERSONA_NOME,
                  STATUS,
                  DESCRICAO
           FROM ENTRADA_SAIDA_FUNC_DETALHES
           WHERE 
                 DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{persona} #{ob}
                 ORDER BY 6,2,1 "
                 
    EntradaSaidaFunc.find_by_sql(sql)
  end


  def self.pedidos_vendas(params)

    persona = "AND P.PERSONA_ID = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
    vend    = "AND P.VENDEDOR_ID = '#{params[:busca]["vendedor"]}'" unless params[:busca]["vendedor"].blank?
    status  = "AND P.STATUS = '#{params[:status]}'" unless params[:status].blank?

    if params[:lancamento].to_s != "1"
      if params[:moeda] == "0"
        moeda = "AND P.MOEDA = 0"
      elsif params[:moeda] == "1"
        moeda = "AND P.MOEDA = 1"
      else
        moeda = "AND P.MOEDA = 2"
      end
    end

    sql = "SELECT 
                  P.ID,
                  P.DATA,
                  P.PRAZO_ENTREGA,
                  P.PERSONA_ID,
                  P.PERSONA_NOME,
                  P.VENDEDOR_ID,
                  P.VENDEDOR_NOME,
                  P.STATUS,
                  P.MOEDA,
                  P.DOCUMENTO_NUMERO,
                  (SELECT SUM(QUANTIDADE) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS QTD,
                  (SELECT SUM(TOTAL_DOLAR) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_US,
                  (SELECT SUM(TOTAL_GUARANI) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_GS,
                  (SELECT SUM(TOTAL_REAL) FROM PRESUPUESTO_PRODUTOS WHERE PRESUPUESTO_ID = P.ID ) AS TOT_RS
           FROM PRESUPUESTOS P
           WHERE 
                 DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{persona} #{vend} #{status}
                 ORDER BY 2,4,7"
                 
    Presupuesto.find_by_sql(sql)
  end


def self.egressos(params)

    rubro = "AND E.RUBRO_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
    conta = "AND E.CONTA_ID = '#{params[:busca]["contas"]}'" unless params[:busca]["contas"].blank?
    st    = "AND E.CLASE_PRODUTO in (#{params[:setores].join(',')})"  unless params[:setores].blank?

    
    if params[:lancamento].to_s != "1"
      if params[:moeda] == "0"
        moeda = "AND E.MOEDA = 0"
      elsif params[:moeda] == "1"
        moeda = "AND E.MOEDA = 1"
      else
        moeda = "AND E.MOEDA = 2"
      end
    end

    sql = "SELECT 
                  E.ID,
                  E.DATA,
                  E.CLASE_PRODUTO,
                  S.SIGLA,
                  E.MOEDA,
                  E.RUBRO_NOME,
                  E.CONTA_NOME,
                  E.VALOR_GUARANI,
                  E.VALOR_DOLAR,
                  E.VALOR_REAL,
                  E.CONCEPTO
           FROM EGRESSOS E 
           INNER JOIN SETORS S
           ON E.CLASE_PRODUTO = S.ID
           WHERE 
                 E.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{rubro} #{conta} #{moeda} #{st}
                 ORDER BY 2,1"
                 
    Egresso.find_by_sql(sql)
  end

def self.ingressos(params)

    rubro = "AND E.RUBRO_ID = '#{params[:busca]["rubro"]}'" unless params[:busca]["rubro"].blank?
    conta = "AND E.CONTA_ID = '#{params[:busca]["contas"]}'" unless params[:busca]["contas"].blank?
    st    = "AND E.CLASE_PRODUTO in (#{params[:setores].join(',')})"  unless params[:setores].blank?

    
    if params[:lancamento].to_s != "1"
      if params[:moeda] == "0"
        moeda = "AND E.MOEDA = 0"
      elsif params[:moeda] == "1"
        moeda = "AND E.MOEDA = 1"
      else
        moeda = "AND E.MOEDA = 2"
      end
    end

    sql = "SELECT 
                  E.ID,
                  E.DATA,
                  E.CLASE_PRODUTO,
                  S.SIGLA,
                  E.MOEDA,
                  E.RUBRO_NOME,
                  E.CONTA_NOME,
                  E.VALOR_GUARANI,
                  E.VALOR_DOLAR,
                  E.VALOR_REAL,
                  E.CONCEPTO
           FROM INGRESSOS E 
           INNER JOIN SETORS S
           ON E.CLASE_PRODUTO = S.ID
           WHERE 
                 E.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{rubro} #{conta} #{moeda} #{st}
                 ORDER BY 2,1"
                 
    Ingresso.find_by_sql(sql)
  end

end

  
