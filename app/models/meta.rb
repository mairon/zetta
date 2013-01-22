class Meta < ActiveRecord::Base
  attr_accessible :descricao, :moeda, :periodo_final, :periodo_inicio, :status, :valor_max_gs, :valor_max_rs, :valor_max_us, :valor_min_gs, :valor_min_rs, :valor_min_us

  has_many :meta_detalhes

  def finds

  	#busca empleado
	  per = Persona.find_by_id(self.persona_id);
	  self.persona_nome = per.nome.to_s unless self.persona_id.blank?

	  #busca setor
	  set = Setors.find_by_id(self.persona_id);
	  self.persona_nome = set.nome.to_s unless self.persona_id.blank?
  end

  
end
