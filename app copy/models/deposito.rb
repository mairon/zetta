class Deposito < ActiveRecord::Base

  def before_save
     @cidade = Cidade.find_by_id(self.cidade_id);
      self.cidade = @cidade.nome.to_s;
  end
  #USUARIO
  def before_create
    self.usuario_created = $log_usuario_id
  end
  def before_update
    self.usuario_updated = $log_usuario_id
  end

end
