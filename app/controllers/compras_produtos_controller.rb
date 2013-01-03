class ComprasProdutosController < ApplicationController
    before_filter :authenticate

    def get_produto          #
      
        @produto =  Produto.find(:first,:select => 'id,codigo,clase_id,grupo_id,sub_grupo_id,fabricante_cod,nome,taxa', :conditions =>  [ "fabricante_cod = ?", params[:key]]) 
        @grupo   =  Grupo.find(:first, :conditions =>  [ "id = ?", @produto.grupo_id]) unless @produto.nil?
                       
        if @produto.nil?
           return render :text => "<script type='text/javascript'>
                                     alert('Producto no Encontrada, Pulse F2 Para Busca o Cadatre un Nuevo')
                                   </script>"
                            
        else
           return render :text => "<script type='text/javascript'>
                                     document.getElementById('compras_produto_produto_nome').value       = '#{@produto.nome.to_s}';
                                     document.getElementById('compras_produto_iva_taxa').value           = '#{@produto.taxa.to_i}';
                                     document.getElementById('compras_produto_produto_id').value         = '#{@produto.id.to_i}';
                                     document.getElementById('compras_produto_codigo').value             = '#{@produto.codigo.to_s}';
                                     document.getElementById('compras_produto_clase_id').value           = '#{@produto.clase_id.to_i}';
                                     document.getElementById('compras_produto_grupo_id').value           = '#{@produto.grupo_id.to_i}';
                                     document.getElementById('compras_produto_sub_grupo_id').value       = '#{@produto.sub_grupo_id.to_i}';
                                     document.getElementById('compras_produto_fabricante_cod').value     = '#{@produto.fabricante_cod.to_s}';
                                     document.getElementById('compras_produto_porcen_balcao').value      = '#{@grupo.porcen_balcao.to_i}';
                                     document.getElementById('compras_produto_porcen_maiorista').value   = '#{@grupo.porcen_mayo.to_i}';
                                     document.getElementById('compras_produto_porcen_minorista').value   = '#{@grupo.porcen_mino.to_i}';                                
                                 </script>"
          
          end                    
    end

    def index                  #
        @compras_produtos = ComprasProduto.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @compras_produtos }
        end
    end

    def show                   #
        @compras_produto = ComprasProduto.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @compras_produto }
        end
    end

    def new                    #
        @compras_produto = ComprasProduto.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @compras_produto }
        end
    end
    
    def edit                   #
        @compras_produto = ComprasProduto.find(params[:id])
        @compra  = Compra.find(@compras_produto.compra_id)

    end

    def create                 #
        @compras_produto = ComprasProduto.new(params[:compras_produto])
        
        respond_to do |format|
            if @compras_produto.save
                flash[:notice] = 'Producto Adicionado'
                format.html { redirect_to "/compras/#{@compras_produto.compra_id}" }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @compras_produto.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update                 #
        @compras_produto = ComprasProduto.find(params[:id])
        @compras_produto.usuario_updated = current_user.id
        @compras_produto.unidade_updated = current_unidade.id

        respond_to do |format|
            if @compras_produto.update_attributes(params[:compras_produto])
                flash[:notice] = 'Producto Editado'
                format.html { redirect_to "/compras/#{@compras_produto.compra_id}" }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @compras_produto.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                #
        @compras_produto = ComprasProduto.find(params[:id])
        @compras_produto.destroy

        redirect_to "/compras/#{@compras_produto.compra_id}" 
    end

end
