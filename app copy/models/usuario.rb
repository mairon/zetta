class Usuario < ActiveRecord::Base
   
  validates_presence_of   :usuario_nome,:usuario_senha
  validates_uniqueness_of :usuario_nome

end
