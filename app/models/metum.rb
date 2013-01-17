class Metum < ActiveRecord::Base
  attr_accessible :data, :moeda, :periodo_final, :periodo_inicio, :persona_id, :persona_nome, :valor_dolar, :valor_guarani, :valor_real
end
