class Produto < ActiveRecord::Base

  has_many :compras_produtos
  has_many :vendas_produtos
  has_many :produtos_roteiros, :order => 1
  has_many :produto_composicao, :order => 1
  has_many :produto_barras, :order => 1
  belongs_to :safra_umidades
  belongs_to :safra_produtos
  before_save :finds, :gera_cod_barra
  

  validates_presence_of :nome,:taxa,:preco_venda_guarani,:preco_maiorista_guarani,:preco_minorista_guarani
  validates :barra, :fabricante_cod, :uniqueness => true, :allow_blank => true

  validates_attachment_size :picture, :less_than => 10.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/jpeg','image/jpg', 'image/png']
  validates_uniqueness_of :fabricante_cod, :nome, :message => " ja cadastrado.",:allow_blank => true
  has_attached_file :picture
  
  def self.busca_produto(params)

    tipo = "nome"            if params[:tipo] == "DESCRIPCION"
    tipo = "id"              if params[:tipo] == "CODIGO"
    tipo = "fabricante_cod"  if params[:tipo] == "FABRICANTE"

    if tipo == "id"
      cond  = " #{tipo} = #{params[:busca]} "
    else
      cond  = " #{tipo} LIKE '%#{params[:busca]}%' "
    end
    #clase
    cond = cond + " AND clase_id    = #{params[:filtro01]["clase"]} "    unless params[:filtro01]["clase"].blank?
    #GRUPO
    cond = cond + " AND grupo_id    = #{params[:filtro02]["grupo"]} "    unless params[:filtro02]["grupo"].blank?



    Produto.paginate( :select => 'id,clase_id,fabricante_cod,cod_velho,grupo_id,nome,barra,stock_minimo,stock_maximo',:conditions =>  cond ,:order => 'clase_id,grupo_id,nome', :page => params[:page],
                    :per_page   => 25
)

  end

    def finds
        gp = Grupo.find_by_id(self.grupo_id)
        self.porcen_balcao = gp.porcen_balcao unless self.grupo_id.blank?
        self.porcen_mayo   = gp.porcen_mayo unless self.grupo_id.blank?
        self.porcen_mino   = gp.porcen_mino unless self.grupo_id.blank?

   end 

    def gera_cod_barra
      if self.barra == ''
         max = Produto.maximum(:id)
        self.barra = self.clase_id.to_s.rjust(2,'0') << self.grupo_id.to_s.rjust(4,'0') << ( max + 1 ).to_s.rjust(6,'0')
      end 
    end
end
