class Localizacao < ActiveRecord::Base
  attr_accessible :ocupacao, :sigla

    validates :ocupacao, :sigla, :presence => true
end
