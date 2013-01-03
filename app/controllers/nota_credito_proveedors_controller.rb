class NotaCreditoProveedorsController < ApplicationController
before_filter :authenticate

   def get_moeda                #
        @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:key]])

        if !@moeda.nil?
           return render :text => "<script type='text/javascript'>
                                   document.getElementById('nota_credito_proveedor_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                   </script>"
        else
        return render :text => "<script type='text/javascript'>
                                  alert('Cotizacion no Cadastrada!')
                                </script>"
        end                    
    end

  def filtro_busca_faturas
    @faturas = Compra.all(:select => 'id,persona_id,persona_nome,documento_numero_01,documento_numero_02,documento_numero,data',:conditions => ["persona_id = ? AND documento_numero LIKE ?",params[:busca],"%#{params[:filtro]}%"],
                          :order  => 'data DESC,documento_numero DESC')

    render :layout => false
  end
   

  def busca_produtos

    render :layout => false
  end


  def nc_proveedor_produtos
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    documentos_id = NcProveedorFatura.all(:conditions => ["nota_credito_proveedor_id = ?",params[:id]]).collect{|d| d.compra_id}.join(', ')

    @produtos = ComprasProduto.all(:conditions => "compra_id IN (#{documentos_id})")

  end

  def nc_proveedor_aplic
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    documentos_id = NcProveedorFatura.all(:conditions => ["nota_credito_proveedor_id = ?",params[:id]]).collect{|d| d.documento_numero}.join(', ')

    if @nota_credito_proveedor.operacao == 0
      @dividas      = Proveedore.all(:conditions => "liquidacao = 0 and documento_numero IN ('#{documentos_id.to_s}')")
    else 
      @dividas      = Proveedore.all(:conditions => ["persona_id = ? and liquidacao = 0",@nota_credito_proveedor.persona_id])
    end


    @valor_total_us = NotaCreditoProveedorProduto.sum('total_dolar',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    @valor_total_gs = NotaCreditoProveedorProduto.sum('total_guarani',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

  end

   
  def nc_proveedor_financa
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    
    @valor_total_us = NcProveedorFatura.sum('valor_dolar',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    @valor_total_gs = NcProveedorFatura.sum('valor_guarani',:conditions => ["nota_credito_proveedor_id = ? ",@nota_credito_proveedor.id])

    session[:pagina] = ''
  end

  def index
    @nota_credito_proveedors = NotaCreditoProveedor.all
  end

  def show
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota_credito_proveedor }
    end
  end

  def new
    @nota_credito_proveedor = NotaCreditoProveedor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota_credito_proveedor }
    end
  end

  def edit
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    session[:pagina] = '1'
  end

  def create
    @nota_credito_proveedor = NotaCreditoProveedor.new(params[:nota_credito_proveedor])

    respond_to do |format|
      if @nota_credito_proveedor.save
        if @nota_credito_proveedor.operacao == 0
          format.html { redirect_to(@nota_credito_proveedor) }
        else
          format.html { redirect_to "/nota_credito_proveedors/nc_proveedor_aplic/#{@nota_credito_proveedor.id}" }
        end         
      else
        format.html { render :action => "new" }        
      end
    end
  end

  def update
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])

    respond_to do |format|
      if @nota_credito_proveedor.update_attributes(params[:nota_credito_proveedor])

        if @nota_credito_proveedor.operacao == 0
          format.html { redirect_to(@nota_credito_proveedor) }
        else
          format.html { redirect_to "/nota_credito_proveedors/nc_proveedor_aplic/#{@nota_credito_proveedor.id}" }
        end      

      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nota_credito_proveedor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @nota_credito_proveedor = NotaCreditoProveedor.find(params[:id])
    @nota_credito_proveedor.destroy

    respond_to do |format|
      format.html { redirect_to(nota_credito_proveedors_url) }
      format.xml  { head :ok }
    end
  end
end
