class Proveedore < ActiveRecord::Base
    before_create :calc
    before_save :finds
    def calc
        if self.documento_numero == ''
            self.documento_numero_01 = '000'
            self.documento_numero_02 = '000'
            self.documento_numero = '999'<< Cliente.count(:id).to_s
        end
    end 
    def finds
        @persona = Persona.find_by_id(self.persona_id);
        self.persona_nome = @persona.nome.to_s unless self.persona_id.blank?    

    end


	def self.contas_pagar_resumido(params) #LISTADO DE PROVEEDOR RESUMIDO POR PROVEEDOR
	
		#FILTRO ESTADO DO LANCAMENTO
        pers      = "AND PV.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        liq_open  = "AND PV.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND PV.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"

		#FILTRO MOEDA
        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND PV.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND PV.moeda = 1"
          else
            moeda = "AND PV.moeda = 2"
           end
        end

		#FILTRO CLASE DE PROVEEDOR           
        if params[:clase] == "0"
            clase     = "AND PV.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND PV.clase_produto = 1"
        else
            clase     = ""
        end

		#FILTRO PROVEEDOR LOCAL OU EXTERIOR
        if params[:tipo_prov] =="0"
			tipo_prov = " AND P.PER_INTER_EXTER = 0"
		elsif params[:tipo_prov] == "1"
			tipo_prov = "AND P.PER_INTER_EXTER = 1"
		else
			tipo_prov = ""
		end 

        #FITRO POR DATA FATURACAO
        if !params[:inicio_faturacao].blank?

            cond = "PV.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO

            cond = "PV.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase}"
        end

		sql="SELECT 
                              PV.PERSONA_ID,
                              PV.PERSONA_NOME,
						      SUM( PV.DIVIDA_DOLAR - PV.PAGO_DOLAR ) AS SALDO_US,
						      SUM( PV.DIVIDA_GUARANI - PV.PAGO_GUARANI ) AS SALDO_GS,
                              SUM( PV.DIVIDA_REAL - PV.PAGO_REAL ) AS SALDO_RS,
							  MAX(PV.VENCIMENTO) AS VENCI
				 FROM  
							PROVEEDORES PV
				 INNER JOIN 
							PERSONAS P
				 ON PV.PERSONA_ID = P.ID
				 WHERE #{cond} #{tipo_prov}
				 GROUP BY 1,2
				 ORDER BY 2"
		Proveedore.find_by_sql(sql)
	end


    def self.relatorio_contas_pagar(params) #LISTADO DETALHADO POR FATURA

        pers      = "AND PV.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        liq_open  = "AND  PV.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND  PV.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND  PV.moeda = 0"
           elsif params[:moeda] == "0"
              moeda = "AND  PV.moeda = 1"
          else
              moeda = "AND  PV.moeda = 2"
           end
        end
           
        if params[:clase] == "0"
            clase     = "AND  PV.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND  PV.clase_produto = 1"
        else
            clase     = ""
        end

		#FILTRO PROVEEDOR LOCAL OU EXTERIOR
        if params[:tipo_prov] =="0"
			tipo_prov = " AND P.PER_INTER_EXTER = 0"
		elsif params[:tipo_prov] == "1"
			tipo_prov = "AND P.PER_INTER_EXTER = 1"
		else
			tipo_prov = ""
		end 

        #FITRO POR DATA FATURACAO
        if !params[:inicio_faturacao].blank?

            cond = " PV.data  BETWEEN  '#{params[:inicio_faturacao]}' AND '#{params[:final_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{tipo_prov}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO

            cond = " PV.vencimento  BETWEEN  '#{params[:inicio_vencimento]}' AND '#{params[:final_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{tipo_prov}"
        end

        sql =  "SELECT 
								 PV.ID,
                                 PV.DATA,
                                 PV.MOEDA,
                                 PV.COMPRA_ID,
                                 PV.PERSONA_ID,
                                 PV.PERSONA_NOME,
                                 PV.DOCUMENTO_NUMERO_01,
                                 PV.DOCUMENTO_NUMERO_02,
                                 PV.DOCUMENTO_NUMERO,
                                 PV.DOCUMENTO_NOME,
                                 PV.CLASE_PRODUTO,
                                 PV.COTA,
                                 PV.VENCIMENTO,
                                 PV.DIVIDA_GUARANI,
                                 PV.DIVIDA_DOLAR,
                                 PV.DIVIDA_REAL,
                                 PV.PAGO_GUARANI,
                                 PV.PAGO_DOLAR,
                                 PV.PAGO_REAL

				FROM
							PROVEEDORES PV
				INNER JOIN
							PERSONAS P
				ON PV.PERSONA_ID = P.ID
				WHERE #{cond}
				ORDER BY 6,2,12,1"
		Proveedore.find_by_sql(sql)
    end

    def self.relatorio_contas_pagar_saldo_anterior(params)
        
        pers      = "AND PROVEEDORES.PERSONA_ID = #{params[:busca]["persona"]} " unless params[:busca]["persona"].blank?
        liq_open  = "AND PROVEEDORES.liquidacao = 0 #{pers}"                     if params[:filtro] == "0"
        liq_close = "AND PROVEEDORES.liquidacao = 1 #{pers}"                     if params[:filtro] == "1"
        liq_all   = "#{pers}"                                        if params[:filtro] == "2"

        if params[:lancamento].to_s != "1"
           if params[:moeda] == "0"
              moeda = "AND PROVEEDORES.moeda = 0"
           elsif params[:moeda] == "1"
              moeda = "AND PROVEEDORES.moeda = 1"
          else
            moeda = "AND PROVEEDORES.moeda = 1"
           end
        end

        if params[:moeda] == "0"
            valor = "PROVEEDORES.divida_dolar - PROVEEDORES.pago_dolar"
        elsif params[:moeda] == "1"
            valor = "PROVEEDORES.divida_guarani - PROVEEDORES.pago_guarani"
        else
            valor = "PROVEEDORES.divida_real - PROVEEDORES.pago_real"
        end
        if params[:clase] == "0"
            clase     = "AND PROVEEDORES.clase_produto = 0"
        elsif params[:clase] == "1"
            clase     = "AND PROVEEDORES.clase_produto = 1"
        else
            clase     = ""
        end

		#FILTRO PROVEEDOR LOCAL OU EXTERIOR
        if params[:tipo_prov] =="0"
			tipo_prov = " AND P.PER_INTER_EXTER = 0"
		elsif params[:tipo_prov] == "1"
			tipo_prov = "AND P.PER_INTER_EXTER = 1"
		else
			tipo_prov = ""
		end 


        if !params[:inicio_faturacao].blank?
            #FITRO POR DATA FATURACAO
            cond = "PROVEEDORES.data < '#{params[:inicio_faturacao]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{tipo_prov}"
        else
            #FITRO POR DATA FATURACAO VENCIMENTO
            cond = "PROVEEDORES.vencimento < '#{params[:inicio_vencimento]}' #{liq_open} #{liq_close} #{liq_all} #{moeda} #{clase} #{tipo_prov}"
        end

        Proveedore.sum(valor,:conditions => cond,:joins => "INNER JOIN PERSONAS P ON PROVEEDORES.PERSONA_ID = P.ID" )
    end

end
