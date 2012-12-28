class ComprasFinanca < ActiveRecord::Base
    belongs_to :compra

    validates_presence_of :valor_dolar,:valor_guarani,:valor_real
  
    validates_numericality_of :valor_guarani, :greater_than => 0    

    before_save :finds
    
    def finds        #
        documento          = Documento.find_by_id(self.documento_id);
        self.documento_nome = documento.nome.to_s unless self.documento_id.blank? 

        conta          = Conta.find_by_id(self.conta_id);
        self.conta_nome = conta.nome.to_s  unless self.conta_id.blank?;

        persona          = Persona.find_by_id(self.persona_id);
        self.persona_nome = persona.nome.to_s  unless self.persona_id.blank?;
        self.persona_ruc  = persona.ruc.to_s  unless self.persona_id.blank?;

        if compra.tipo_compra == 1
            if compra.descricao == ''
                self.descricao = "GASTO #{compra.rubro_nome} Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"
            end 
        elsif compra.tipo_compra == 0
                self.descricao = "COMPRA DE MERCADORIA Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"                       

        elsif compra.tipo_compra == 2
                self.descricao = "COMPRA DE MERCADORIA IMPORTACION Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"                       
        elsif compra.tipo_compra == 3
                self.descricao = "COMPRA DE BIENES Prov. #{self.persona_nome} DOC NR. #{self.documento_numero_01}-#{self.documento_numero_02}-#{self.documento_numero}"                       
        end       

    end
end
