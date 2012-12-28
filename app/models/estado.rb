class Estado < ActiveRecord::Base

validates_presence_of :nome

  def before_save    
     @pais = Paise.find_by_id(self.paise_id);
      self.pais = @pais.nome.to_s;
  end

end
