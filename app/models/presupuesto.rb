class Presupuesto < ActiveRecord::Base
	has_many :presupuesto_produtos, :dependent => :delete_all
	validates_presence_of :cotacao,:persona_id,:persona_nome
end
