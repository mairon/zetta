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
    tipo_gasto = "AND tipo_gasto = #{params[:tipo_gasto]}" unless params[:tipo_gasto].blank?
    obra       = "AND ob_ref = '#{params[:busca]["obra"]}'" unless params[:busca]["obra"].blank?
    prov       = "AND persona_id = '#{params[:busca]["prov"]}'" unless params[:busca]["prov"].blank?
    unid       = "AND unidade_id = '#{params[:busca]["unidade"]}'" unless params[:busca]["unidade"].blank?

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

    if params[:tp] == "0" or params[:tp] == "2" 
      Compra.all(:select => 'id, ob_ref,total_real,unidade_id,persona_id,persona_nome,data,documento_numero_01,documento_numero_02,documento_numero,rubro_descricao,total_dolar,total_guarani,rodado_nome',
                 :conditions => [" TIPO_COMPRA = 1 #{moeda} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{tipo_gasto}  #{empregado} #{rodado} #{rubro} #{status} #{obra} #{prov} #{unid}" ], :order => 'data,documento_numero')

    elsif params[:tp].to_s == "1"
      sql = "SELECT R.ID,
                    R.DESCRICAO,
                    ( SELECT SUM(#{tt}) FROM COMPRAS WHERE TIPO_COMPRA = 1 AND  RUBRO_ID = R.ID #{moeda} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{tipo_gasto}  #{empregado} #{rodado} #{rubro} #{status} #{obra} #{prov} #{unid}) AS TOTAL_COMPRA
                 FROM RUBROS R
                ORDER BY 3"
      Compra.find_by_sql(sql)
    else

      sql = "SELECT 
                  OB_REF,
                  RUBRO_ID,
                  RUBRO_DESCRICAO,
                  SUM(#{tt}) AS TOTAL
             FROM COMPRAS
            WHERE TIPO_COMPRA = 1 #{moeda} AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{tipo_gasto}  #{empregado} #{rodado} #{rubro} #{status} #{obra} #{prov} #{unid}
            GROUP BY 
                1,2,3                 
            ORDER BY 1,2"
      Compra.find_by_sql(sql)

    end
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


def self.controle_visitas(params)

    persona = "AND C.PERSONA_ID = '#{params[:busca]["persona"]}'" unless params[:busca]["persona"].blank?
    vend    = "AND C.CONSULTOR_ID = '#{params[:busca]["consultor"]}'" unless params[:busca]["consultor"].blank?
    direc   = "AND C.CIDADE_ID = '#{params[:busca]["cidade"]}'" unless params[:busca]["cidade"].blank?
    if params[:ordem] == '0'
      order = "C.DATA,C.CONSULTOR_ID"
    else
      order = "C.PERSONA_ID,C.CONSULTOR_ID"
    end

    sql = "SELECT  C.DATA,
                   C.CONSULTOR_NOME, 
                   C.PERSONA_NOME, 
                   C.SERVICO_NOME,
                   C.CIDADE_NOME,
                   C.NC,
                   S.PERIODO
            FROM CONTROLE_VISITA C 
            INNER JOIN SERVICOS S
            ON C.SERVICO_ID = S.ID
            WHERE 
            C.DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'
            AND C.NC BETWEEN '#{params[:nc_inicio]}' AND '#{params[:nc_final]}'
            #{persona} #{vend} #{direc}
            ORDER BY #{order}"
                 
    Presupuesto.find_by_sql(sql)
  end

end

  
