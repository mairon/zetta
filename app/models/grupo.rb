class Grupo < ActiveRecord::Base
  #validacoes
  validates_presence_of :descricao
  validates_uniqueness_of :descricao

end
