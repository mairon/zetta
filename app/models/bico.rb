class Bico < ActiveRecord::Base
  attr_accessible :codigo_tec, :nome, :vazao

  validates_presence_of :nome, :vazao
end
