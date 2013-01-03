class Cidade < ActiveRecord::Base

  validates_presence_of :nome

  def before_save
     @estado = Estado.find_by_id(self.estado_id);
      self.estado = @estado.nome.to_s;
  end

end
