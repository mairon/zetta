class FechamentoCaixa < ActiveRecord::Base
  
  def before_save
    @persona = Persona.find_by_id(self.usuario_id);
    self.usuario_nome = @persona.nome.to_s unless self.usuario_id.blank?

    @conta = Conta.find_by_id(self.conta_id);
    self.conta_nome = @conta.nome.to_s unless self.conta_id.blank?
  end


end
