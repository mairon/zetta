class ConsumicaoInternasController < ApplicationController
  before_filter :authenticate
  
  def get_codigo_barra_produto  #
    @produto =  Produto.find(:first, :conditions =>  [ "fabricante_cod = ?", params[:codigo]])

    stock = Stock.sum( 'entrada - saida',:conditions => ['produto_id = ?',@produto.id] )

    return render :text => "<script type='text/javascript'>
                                  document.getElementById('consumicao_interna_produto_produto_id').value             = '#{@produto.id.to_i}';
                                  document.getElementById('consumicao_interna_produto_produto_nome').value           = '#{@produto.nome.to_s}';
                                  document.getElementById('consumicao_interna_produto_taxa').value                   = '#{@produto.taxa.to_s}';                                  
                                  document.getElementById('consumicao_interna_produto_clase_id').value               = '#{@produto.clase_id.to_i}';
                                  document.getElementById('consumicao_interna_produto_grupo_id').value               = '#{@produto.grupo_id.to_i}';
                                  document.getElementById('consumicao_interna_produto_sub_grupo_id').value           = '#{@produto.sub_grupo_id.to_i}';
                                  document.getElementById('consumicao_interna_produto_unitario_dolar').value         =  number_format( #{@produto.preco_venda_dolar},2, ',', '.')
                                  document.getElementById('consumicao_interna_produto_unitario_guarani').value       = number_format( #{@produto.preco_venda_guarani},0, ',', '.');

                                   if ( '#{stock}' <= 0 )
                                     {
                                      document.getElementById('red').innerHTML                             =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('green').innerHTML                           =  '' ;
                                     }
                                   else
                                     {
                                      document.getElementById('green').innerHTML                           =  '<span>'+'#{stock}'+'</span>' ;
                                      document.getElementById('red').innerHTML                             =  '' ;
                                     }

                                </script>"
  end

  def get_moeda                 #
    @moeda =  Moeda.find(:first,  :select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
    return render :text => "<script type='text/javascript'>
                                  document.getElementById('consumicao_interna_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                </script>"
  end

  def index
    @consumicao_internas = ConsumicaoInterna.all(:order => 'data')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consumicao_internas }
    end
  end

  def show
    @consumicao_interna = ConsumicaoInterna.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consumicao_interna }
    end
  end

  def new

    @consumicao_interna = ConsumicaoInterna.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consumicao_interna }
    end
  end

  def edit
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
  end

  def create
    @consumicao_interna = ConsumicaoInterna.new(params[:consumicao_interna])

    respond_to do |format|
      if @consumicao_interna.save
        format.html { redirect_to(@consumicao_interna) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @consumicao_interna = ConsumicaoInterna.find(params[:id])

    respond_to do |format|
      if @consumicao_interna.update_attributes(params[:consumicao_interna])
        format.html { redirect_to(@consumicao_interna) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @consumicao_interna = ConsumicaoInterna.find(params[:id])
    @consumicao_interna.destroy

    respond_to do |format|
      format.html { redirect_to(consumicao_internas_url) }
    end
  end
end
