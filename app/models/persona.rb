class Persona < ActiveRecord::Base
    #acts_as_active
    validates_presence_of :nome,:ruc
    validates_uniqueness_of :ruc

    belongs_to :meta_detalhes
    
    
    if $empresa != "E01"
        validates_attachment_size :picture, :less_than => 10.megabytes
        validates_attachment_content_type :picture, :content_type => ['image/jpeg','image/jpg', 'image/png']
        has_attached_file :picture
    end

    def before_save
        if self.tipo_cliente == 1
            self.cliente = 0
        elsif self.tipo_maiorista == 1
            self.cliente = 1
        elsif self.tipo_intermediario == 1
            self.cliente = 2
        else
            self.cliente = 0
        end
        
        @cidade = Cidade.find_by_id(self.cidade_id);
        self.cidade = @cidade.nome.to_s unless self.cidade_id.blank?

        @estado = Estado.find_by_id(self.estado_id);
        self.estado_nome = @estado.nome.to_s unless self.estado_id.blank?

        @pais = Paise.find_by_id(self.pais_id);
        self.pais_nome = @pais.nome.to_s unless  self.pais_id.blank?

        vend = Persona.find_by_id(self.vend_responsavel_id);
        self.vend_responsavel_nome = vend.nome.to_s unless self.vend_responsavel_id.blank?


    end


end
