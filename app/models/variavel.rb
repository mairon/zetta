class Variavel < ActiveRecord::Base

  validates :nome, :sigla, :valor, :presence => true

  belongs_to :unidade_metricas

  before_save :finds

  def finds
  	#busca unidade_metrica
	  uni_met = UnidadeMetrica.find_by_id(self.unidade_metrica_id);
	  self.unidade_metrica_nome = uni_met.nome.to_s unless self.unidade_metrica_id.blank?
  end 

end
