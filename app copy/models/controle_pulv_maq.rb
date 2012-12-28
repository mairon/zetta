class ControlePulvMaq < ActiveRecord::Base
  attr_accessible :autonomia_01, :autonomia_02, :rodado_id, :rodado_capacidade, :bico_01_id, :bico_02_id, :calibracao, :condicao_maq, 
                  :controle_pulv_id, :data, :etiqueta, :hora_maq, :modelo, :regular, :vazao_01, :vazao_02, :velocidade_01, :velocidade_02

  belongs_to :controle_pulvs

  before_save :finds

  def finds

	  model = Rodado.find_by_id(self.rodado_id);
	  self.rodado_nome = model.modelo.to_s unless self.rodado_id.blank?

    bi = Bico.find_by_id(self.bico_01_id);
	  self.bico_01_nome = bi.nome.to_s unless self.bico_01_id.blank?

  end

end
