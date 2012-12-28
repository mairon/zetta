class ConsumicaoInterna < ActiveRecord::Base
  has_many :consumicao_interna_produtos
  
  validates_presence_of :cotacao

  def before_save
     @vendedor = Persona.find_by_id(self.vendedor_id);
     self.vendedor_nome    = @vendedor.nome.to_s;
  end
  
end
