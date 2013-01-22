class Meta < ActiveRecord::Base
  attr_accessible :descricao, :moeda, :periodo_final, :periodo_inicio, :status, :valor_max_gs, :valor_max_rs, :valor_max_us, :valor_min_gs, :valor_min_rs, :valor_min_us

  validates :moeda, :periodo_final, :periodo_inicio, :status, :presence => true

  
  has_many :meta_detalhes

end
