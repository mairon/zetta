class Diario < ActiveRecord::Base
    has_many :diario_debes
    has_many :diario_habers


    def self.busca_acientos(params)

      if params[:seta].to_s == '0'
        if params[:tipo] == "COMPRA"
            processo =  "AND TABELA_NOME = 'COMPRA'"
        elsif params[:tipo] == "GASTOS"
            processo =  "AND TABELA_NOME = 'COMPRA'"
        elsif params[:tipo] == "VENTAS"
            processo =  "AND TABELA_NOME = 'VENTAS'"
        elsif params[:tipo] == "COBROS"
            processo =  "AND TABELA_NOME = 'COBROS'"
        elsif params[:tipo] == "PAGOS"
            processo =  "AND TABELA_NOME = 'PAGOS'"
        elsif params[:tipo] == "NOTA-REMICION"
            processo =  "AND TABELA_NOME = 'NOTA-REMICAO'"
        elsif params[:tipo] == "INGRESOS"
            processo =  "AND TABELA_NOME = 'INGRESSOS'"
        elsif params[:tipo] == "EGRESOS"
            processo =  "AND TABELA_NOME = 'EGRESSOS'"
        elsif params[:tipo] == "TRANF.CONTAS"
            processo =  "AND TABELA_NOME = 'TRANSFERENCIA CONTAS'"
        elsif params[:tipo] == "SUELDO Y JORNALES"
            processo =  "AND TABELA_NOME = 'SUELDOS'"
        elsif params[:tipo] == "ADELANTOS"
            processo =  ""
        end

        cond = ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'#{processo} "] unless params[:inicio].blank?
    else
        cond = ["id = #{params[:busca]}"] unless params[:busca].blank?
    end

        subquery_deb =  DiarioDebe.send( :construct_finder_sql,
                                        :select => 'sum(valor_dolar)',
                                        :conditions => ["diario_id = diarios.id"])


        subquery_hab =  DiarioHaber.send( :construct_finder_sql,
                                        :select => 'sum(valor_dolar)',
                                        :conditions => ["diario_id = diarios.id"])

        self.paginate( :select => "id,
                                   data,
                                   tabela_id,
                                   documento_numero_01,
                                   documento_numero_02,
                                   documento_numero,
                                   (#{subquery_deb}) as deb_us,
                                   (#{subquery_hab}) as hab_us,
                                   descricao",
                       :conditions => cond, 
                       :page       => params[:page],
                       :per_page   => 25,
                       :order      => 'data desc,id desc')


    end

end
