class Pago < ActiveRecord::Base
  has_many :pagos_detalhes,   :order => 1
  has_many :pagos_financas,   :order => 1
  belongs_to :persona

  validates_presence_of :cotacao,
                        :persona_nome,
                        :persona_id


  def self.filtro(params)

    cond = ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?

    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    else
      tipo = "persona_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    end

    Pago.paginate( :select     => 'id,
                                 data,
                                 moeda,
                                 persona_nome',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')

  end
  before_update :finds
  before_save :calcs

  def finds       #
      @conta = Conta.find_by_id(self.conta_id);
      self.conta_nome = @conta.nome.to_s unless self.conta_id.blank?

      @documento = Documento.find_by_id(self.documento_id);
      self.documento_nome = @documento.nome.to_s unless self.documento_id.blank?
  end

  def calcs       #

    if self.adelanto == 1 and self.adelanto_id != 0 
      pv = Proveedore.count(:id, :conditions => ["tabela = 'PAGOS' AND tabela_id = ?", self.adelanto_id])
      if pv == 0
        ad = Adelanto.first(:conditions => ["id = ?", self.adelanto_id])

        Proveedore.create( :tabela_id           => ad.id.to_i,
                          :tabela              => 'PAGOS',
                          :vencimento          => ad.data,
                          :persona_id          => ad.persona_id,
                          :persona_nome        => ad.persona_nome,
                          :documento_nome      => ad.documento_nome,
                          :documento_numero    => ad.id,
                          :cota                => 0,
                          :data                => self.data,
                          :divida_dolar        => ad.valor_dolar.to_f,
                          :divida_guarani      => ad.valor_guarani.to_f,
                          :liquidacao          => 1,
                          :tipo                => '1',
                          :documento_numero_01 => '000',
                          :documento_numero_02 => '000' )
      end
    end
  end


end
