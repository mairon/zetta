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

  def vendas_produto
    @venda = Venda.find(params[:id])
    prod =  Produto.find_by_barra( params[:cod])

    return render :json => prod    
  end

end
