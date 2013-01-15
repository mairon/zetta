class NotaCredito < ActiveRecord::Base
  has_many :nota_creditos_detalhes,   :order => 1, :dependent => :destroy
  has_many :nota_creditos_docs,   :order => 1, :dependent => :destroy


  def self.filtro_nc(params)                                         #
    
    cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?
    
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "documento_numero "
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "persona_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

    end



    NotaCredito.paginate( :select => 'id,data,persona_nome,operacao,documento_numero,documento_numero_01,documento_numero_02',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')
  end


    def before_save       #
        if self.taxa.to_i == 0
          self.exenta_dolar = self.total_dolar
          self.exenta_guarani = self.total_guarani
        elsif self.taxa.to_i == 5
          self.gravada_05_dolar = self.total_dolar
          self.gravada_05_guarani = self.total_guarani
        else
          self.gravada_10_dolar = self.total_dolar
          self.gravada_10_guarani = self.total_guarani

        end
        if self.tipo == 0
            @conta = Conta.find_by_id(self.conta_id);
            self.conta_nome = @conta.nome.to_s unless self.conta_id.blank? 

        end
    end

end
