class BuscasController < ApplicationController

  def get_unidade                     #
    unidade =  Unidade.find_by_id(params[:unidade], :select => 'id')
    return render :text => unidade.id
  end  

  def get_usuario                     #
    usuario =  Usuario.find_by_id(params[:usuario], :select => 'id')
    return render :text => usuario.id
  end  

  def cotz_us_compra
    moeda =  Moeda.find_by_data( params[:data], :select => 'dolar_compra')
    return render :text => moeda.dolar_compra.to_i
  end

  def cotz_us_venda
    moeda =  Moeda.find_by_data( params[:data], :select => 'dolar_venda')
    return render :text => moeda.dolar_venda.to_i
  end

  def cotz_rs_compra
    moeda =  Moeda.find_by_data( params[:data], :select => 'real_compra')
    return render :text => moeda.real_compra.to_i
  end

  def cotz_rs_venda
    moeda =  Moeda.find_by_data( params[:data], :select => 'real_venda')
    return render :text => moeda.real_venda.to_i
  end

  def busca_produto
    @venda = Venda.find(params[:id])
    prod   = Produto.find_by_id(params[:cod])    if params[:tipo_cod] == "CODIGO"
    prod   = Produto.find_by_barra(params[:cod]) if params[:tipo_cod] == "BARRA"

    stock  = Stock.sum('entrada - saida', :conditions => ["produto_id = ? and deposito_id = ? and data <= ?",params[:id], params[:deposito_id], @venda.data] )

    return render :json => {:produto => prod, :sum_stock => stock}
  end

end
