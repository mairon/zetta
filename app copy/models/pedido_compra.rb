class PedidoCompra < ActiveRecord::Base
  has_many :pedido_compra_produtos
  
  validates_presence_of :cotacao,:persona_id
  
  def before_save

    per = Persona.find_by_id(self.persona_id,:select => 'id,nome')
    self.persona_nome = per.nome

    func = Persona.find_by_id(self.requerente_id,:select => 'id,nome')
    self.requerente_nome = func.nome

    doc = Documento.find_by_id(self.documento_id,:select => 'id,nome')
    self.documento_nome = doc.nome

    uni = Unidade.find_by_id(self.unidade_id,:select => 'id,unidade_nome')
    self.unidade_nome = uni.unidade_nome

  end   


  def self.filtro_busca_pedido(params)

    if params[:seta].to_s == "0"
      cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"] unless params[:inicio].blank?
    else
      if params[:tipo] == "CODIGO"
        tipo = "id"
        cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
      else
        tipo = "persona_nome"
        cond =  ["#{tipo} LIKE ?","%#{params[:busca]}%"] unless params[:busca].blank?
      end 
    end

    self.all(:select => "id,data,data_entrega,persona_nome,status",:conditions => cond ,:order => 'data desc,id')
  end

end

