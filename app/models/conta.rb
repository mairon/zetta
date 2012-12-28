class Conta < ActiveRecord::Base

  validates_presence_of :nome
  validates_uniqueness_of :nome
  
  def before_save
     @cidade = Cidade.find_by_id(self.cidade_id);
      self.cidade = @cidade.nome.to_s;

     @rubro = Rubro.find_by_id(self.rubro_id);
      self.cod_contabil = @rubro.codigo.to_s;
      self.rubro_nome = @rubro.descricao ;

  end
end
