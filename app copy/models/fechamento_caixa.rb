class FechamentoCaixa < ActiveRecord::Base
  
  def before_save
    @persona = Persona.find_by_id(self.usuario_id);
    self.usuario_nome = @persona.nome.to_s unless self.usuario_id.blank?

    @conta = Conta.find_by_id(self.conta_id);
    self.conta_nome = @conta.nome.to_s unless self.conta_id.blank?
  end

 before_save      :enviar_email

  protected

  def hashear_senha
    return true if self.senha.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s(:db)}--#{self.email}--#{self.nome}") if self.new_record?
    self.senha_em_hash = Usuario.hashear(self.senha, self.salt)
  end

  def enviar_email
    FechamentoCaixasMailer.deliver_registro( self )
  end

end
