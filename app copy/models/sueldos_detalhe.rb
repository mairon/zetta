class SueldosDetalhe < ActiveRecord::Base
  belongs_to :sueldo

  def before_save   #

    @rubro = Rubro.find_by_id(self.rubro_id);
    self.rubro_nome = @rubro.descricao.to_s unless self.rubro_id.blank?
  end

end
