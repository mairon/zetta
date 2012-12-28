class Adelanto < ActiveRecord::Base

    validates_presence_of :cotacao,:valor_dolar,:valor_guarani,:status
    before_save :finds

    def finds
        @persona = Persona.find_by_id(self.persona_id);
        self.persona_nome = @persona.nome.to_s unless self.persona_id.blank?

        @vend = Persona.find_by_id(self.vendedor_id);
        self.vendedor_nome = @vend.nome.to_s unless self.vendedor_id.blank?

        @conta = Conta.find_by_id(self.conta_id);
        self.conta_nome = @conta.nome.to_s;

        @documento = Documento.find_by_id(self.documento_id);
        self.documento_nome = @documento.nome.to_s;
    end

    def self.filtro_busca(params)

        cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?

        if params[:tipo] == "CODIGO"
            tipo = "id"
            cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
        elsif params[:tipo] == "NOMBRE"
            tipo = "persona_nome"
            cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

        else
            tipo = "conta_nome"
            cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

        end

        self.all(:conditions => cond,:order => "#{tipo},id")
    end
end
