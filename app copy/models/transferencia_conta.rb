class TransferenciaConta < ActiveRecord::Base
    has_many :transferencia_contas_detalhes ,:dependent => :destroy
    validates_presence_of :cotacao,
    :valor_dolar,
    :valor_guarani

    def before_save           #
        @doc = Documento.find_by_id(self.documento_id);
        self.documento_nome = @doc.nome.to_s;

        @ingreso = Conta.find_by_id(self.ingreso_id);
        self.ingreso_nome = @ingreso.nome.to_s;

        @destino = Conta.find_by_id(self.destino_id);
        self.destino_nome = @destino.nome.to_s;

        per = Persona.find_by_id(self.persona_id);
        self.persona_nome = per.nome.to_s unless  self.persona_id.blank?;
        
        if self.deposito == 3
          if self.concepto == ''
            self.concepto = 'Viatico ' << self.persona_nome.to_s << ' N.: ' << self.id.to_s
          end 
        end 
    end

    def self.filtro(params)   #
        
        unless params[:inicio].blank?
            cond = ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' AND reg_status != 2 "]
        else
            cond = "reg_status != 2"
        end
        

        if params[:tipo] == "CODIGO"
            tipo = "id"
            cond =  ["#{tipo} = ?   AND reg_status != 2","#{params[:busca]}"] unless params[:busca].blank?
        elsif params[:tipo] == "CONTA ORIGEM"
            tipo = "ingreso_nome"
            cond =  ["#{tipo} LIKE ? AND reg_status != 2","%#{params[:busca]}%"] unless params[:busca].blank?
        else
            tipo = "destino_nome"
            cond =  ["#{tipo} LIKE ?  AND reg_status != 2","%#{params[:busca]}%"] unless params[:busca].blank?

        end
        


        self.all(:conditions => cond,:order => 'data,id')
    end

end
