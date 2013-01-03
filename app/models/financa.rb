class Financa < ActiveRecord::Base
  
    def self.relatorio_financas(params)

               
    if params[:filtro] == '1'
        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "entrada_dolar"
            saida   = "saida_dolar"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "entrada_guarani"
            saida   = "saida_guarani"
        else
            moeda   = " and moeda = 2"
            entrada = "entrada_real"
            saida   = "saida_real"
        end

        conta  = "AND conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?

        unless params[:cheque].blank?
            cond  = "cheque LIKE ? #{moeda} AND ESTADO = 0 #{conta}","%#{params[:cheque]}%"
        else
            cond  = "data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' #{moeda} AND ESTADO = 0 #{conta}"
        end
        self.all(:conditions => cond, :order => 'data,id')

    else

        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "SUM(ENTRADA_DOLAR) AS ENTRADA_DOLAR"
            saida   = "SUM(SAIDA_DOLAR) AS SAIDA_DOLAR"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "SUM(ENTRADA_GUARANI) AS ENTRADA_GUARANI"
            saida   = "SUM(SAIDA_GUARANI) AS SAIDA_GUARANI"
        else
            moeda   = " and moeda = 2"
            entrada = "entrada_real"
            saida   = "saida_real"
        end
      ch    =  "AND cheque LIKE ?","%#{params[:cheque]}%"  unless params[:cheque].blank?
      cond  = "#{moeda} AND ESTADO = 0 #{ch}"
      sql = "SELECT 
                    CONTA_ID,
                    CHEQUE,
                    MAX(PERSONA_NOME) AS PERSONA_NOME,
                    MAX(OB_REF) AS OB_REF,
                    MAX(DIFERIDO) AS DIFERIDO,
                    MAX(DATA) AS DATA,
                    MAX(TABELA) AS TABELA,
                    MAX(TABELA_ID) AS TABELA_ID,
                    MAX(CONCEPTO) AS CONCEPTO,                      
                    #{entrada},
                    #{saida}
              FROM 
                    FINANCAS 
              WHERE 
                    DATA BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND conta_id = #{params[:busca]["conta"]} #{cond}
              GROUP BY 
                    1,2
              ORDER BY 5 ,2,3"
      Financa.find_by_sql(sql)              
    end     
        
        
    end
  
    def self.relatorio_financas_saldo_anterior(params)

        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "entrada_dolar"
            saida   = "saida_dolar"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "entrada_guarani"
            saida   = "saida_guarani"
        else
            moeda   = " and moeda = 2"
            entrada = "entrada_real"
            saida   = "saida_real"
        end

        conta = "AND conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?

        unless params[:cheque].blank?
            cond  = "cheque LIKE ? #{moeda} AND  ESTADO = 0 AND #{entrada} + #{saida} > 0 #{conta}","%#{params[:cheque]}%"
        else
            cond  = "data < '#{params[:inicio]}' #{moeda} AND ESTADO = 0 AND #{entrada} + #{saida} != 0 #{conta}"
        end

        self.sum(" #{entrada} - #{saida}",:conditions => cond)
    end  



    def self.lanz_futuros_extr_bc(params)
           
        if params[:moeda].to_s == "0"
            moeda   = " and moeda = 0"
            entrada = "entrada_dolar"
            saida   = "saida_dolar"
        elsif params[:moeda].to_s == "1"
            moeda   = " and moeda = 1"
            entrada = "entrada_guarani"
            saida   = "saida_guarani"
        else
            moeda   = " and moeda = 2"
            entrada = "entrada_real"
            saida   = "saida_real"
        end

        conta = "AND conta_id = #{params[:busca]["conta"]}" unless params[:busca]["conta"].blank?
        cond  = "data > '#{params[:final]}' #{moeda} AND ESTADO = 0 #{conta}"
        self.all(:conditions => cond, :order => 'data,id')
    end
end
