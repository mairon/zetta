class MetaDetalhe < ActiveRecord::Base
  attr_accessible :comicao_max, :comicao_min, :descricao, :meta_id, :persona_id, :persona_nome, :setor_id, :setor_nome, :valor_max_gs, :valor_max_rs, :valor_max_us, :valor_min_gs, :valor_min_rs, :valor_min_us

  validates :comicao_max, :comicao_min , :numericality =>  { :greater_than => 0 }
  validates :comicao_max, :comicao_min, :persona_id, :persona_nome, :setor_id, :setor_nome, :presence => true

  belongs_to :metas
  has_many :setors
  has_many :personas

  def finds

  	#busca empleado
	  per = Persona.find_by_id(self.persona_id);
	  self.persona_nome = per.nome.to_s unless self.persona_id.blank?

	  #busca setor
	  set = Setors.find_by_id(self.persona_id);
	  self.persona_nome = set.nome.to_s unless self.persona_id.blank?
  end
  
end
