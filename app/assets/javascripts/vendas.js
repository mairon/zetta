
$(document).ready(function (){
	  $('#cod_busca').focus();

     $('#new_vendas_produto').submit(function (){
       $.post($(this).attr('action'), $(this).serialize(), null, "script");
       return false;
     });
   });


//VENDAS_PRODUTOS==============================================================//
function VendasProdutoFocoCod()                                         //
{
    document.getElementById("codigo").focus();
}

function VendasProdutoUnitGs()                                          //
{
    var total = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) * document.getElementById('vendas_produto_cotacao').value  )  ;
    document.getElementById('vendas_produto_unitario_guarani').value = ( number_format(total,0, ',', '.') )

    document.getElementById('vendas_produto_preco_guarani').value    = ( number_format(total,0, ',', '.') )
    document.getElementById('vendas_produto_preco_dolar').value      = document.getElementById('vendas_produto_unitario_dolar').value 
    
}

function VendasProdutoUnitDolar()                                       //
{
    var total = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) / document.getElementById('vendas_produto_cotacao').value  )  ;
    document.getElementById('vendas_produto_unitario_dolar').value = ( number_format(total,2, ',', '.') )

    document.getElementById('vendas_produto_preco_dolar').value    = ( number_format(total,2, ',', '.') )
    document.getElementById('vendas_produto_preco_guarani').value  = document.getElementById('vendas_produto_unitario_guarani').value

}



function VendasProdutoTotalDolar()                                      //
{
    var total = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById('vendas_produto_total_dolar').value = ( number_format(total,2, ',', '.') );
}

function VendasProdutoTotalReal()                                      //
{
    var total = eval( parseFloat( document.getElementById('vendas_produto_unitario_real').value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById('vendas_produto_total_real').value = ( number_format(total,2, ',', '.') );
}


function VendasProdutoTotalGs()                                         //
{
    var total = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ) )  ;
    document.getElementById('vendas_produto_total_guarani').value = ( number_format(total,0, ',', '.') );

}

function VendasProdutoIvaDolar()                                        //
{
	if ( document.getElementById('vendas_produto_taxa').value == '80' ){

	    var taxa_exenta  = ( ( parseFloat( document.getElementById('vendas_produto_total_dolar').value.replace(/\./g, "").replace(",", ".") ) / 1.02 ) * 0.80 )
		var taxa_10 = ( parseFloat( document.getElementById('vendas_produto_total_dolar').value.replace(/\./g, "").replace(",", ".") ) - taxa_exenta )
		var tot =  ( taxa_10 /  parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ))
	    iva     = eval( ( taxa_10 / 11 ) );
	    document.getElementById('vendas_produto_iva_dolar').value = ( number_format(iva,6, ',', '.') );
	
	}
	else {

    taxa = ( ( parseFloat( document.getElementById('vendas_produto_taxa').value ) / 100 ) + 1.00 );

    vartotal = eval( parseFloat( document.getElementById('vendas_produto_total_dolar').value.replace(/\./g, "").replace(",", ".") ) / taxa );
    vartotal = eval( ( ( vartotal * parseFloat( document.getElementById('vendas_produto_taxa').value.replace(/\./g, "").replace(",", ".") ) ) / 100 ) / parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ) );
    document.getElementById('vendas_produto_iva_dolar').value = ( number_format(vartotal ,6, ',', '.') );
	}
}

function VendasProdutoIvaGs()                                           //
{
	if ( document.getElementById('vendas_produto_taxa').value == '80' ){

	    var taxa_exenta  = ( ( parseFloat( document.getElementById('vendas_produto_total_guarani').value.replace(/\./g, "").replace(",", ".") ) / 1.02 ) * 0.80 )
		var taxa_10 = ( parseFloat( document.getElementById('vendas_produto_total_guarani').value.replace(/\./g, "").replace(",", ".") ) - taxa_exenta )
		var tot =  ( taxa_10 /  parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ))
	    iva     = eval( ( taxa_10 / 11 ) );
	    document.getElementById('vendas_produto_iva_guarani').value = ( number_format(iva,6, ',', '.') );
	
	}
	else {
    taxa = ( ( parseFloat( document.getElementById('vendas_produto_taxa').value ) / 100 ) + 1.00 );

    vartotal = eval( parseFloat( document.getElementById('vendas_produto_total_guarani').value.replace(/\./g, "").replace(",", ".") ) / taxa );
    vartotal = eval( ( ( vartotal * parseFloat( document.getElementById('vendas_produto_taxa').value.replace(/\./g, "").replace(",", ".") ) ) / 100 ) / parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".") ) );
    document.getElementById('vendas_produto_iva_guarani').value = ( number_format(vartotal ,6, ',', '.') );

	}
}

function VendasProdutoInteres()                                         //
{
    vardesconto      = ( parseFloat( document.getElementById('vendas_produto_interes').value ) / 100 )

    vartotaldescontous   = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
    vartotaldolar        = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) + vartotaldescontous )  ;
    var totaldolarresultus  = eval(  vartotaldolar * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

    document.getElementById('vendas_produto_unitario_dolar').value = ( number_format(vartotaldolar ,2, ',', '.') );
    document.getElementById('vendas_produto_total_dolar').value = ( number_format(totaldolarresultus ,2, ',', '.') );


    vartotaldescontogs = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
    vartotalgs         = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) + vartotaldescontogs )  ;
    var totaldolarresultgs  = eval(  vartotalgs * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

    document.getElementById('vendas_produto_unitario_guarani').value = ( number_format(vartotalgs ,0, ',', '.') );
    document.getElementById('vendas_produto_total_guarani').value = ( number_format(totaldolarresultgs ,0, ',', '.') );
}

function VendasProdutoTotalDesconto()                                   //
{
    if( eval( parseFloat( document.getElementById('vendas_produto_total_desconto').value.replace(/\./g, "").replace(",", "."))) < eval( parseFloat( document.getElementById('vendas_produto_desconto').value.replace(/\./g, "").replace(",", "."))) ){

        var vardesconto       = ( parseFloat( document.getElementById('vendas_produto_total_desconto').value ) / 100 )
        vartotaldescontous    = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
        vartotaldolar         = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".")) - vartotaldescontous )  ;
        var totaldolarresultus  = eval(  vartotaldolar * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

        document.getElementById('vendas_produto_unitario_dolar').value = ( number_format(vartotaldolar ,2, ',', '.') );
        document.getElementById('vendas_produto_total_dolar').value =  (number_format(totaldolarresultus,2, ',', '.') );

        vartotaldescontogs = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
        vartotalgs         = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) - vartotaldescontogs )  ;
        var totaldolarresultgs  = eval(  vartotalgs * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

        document.getElementById('vendas_produto_unitario_guarani').value = ( number_format(vartotalgs ,0, ',', '.') );
        document.getElementById('vendas_produto_total_guarani').value = ( number_format(totaldolarresultgs ,0, ',', '.') );
    }
    else{
        alert('Descuento no Permitido!')

        var vardesconto       = ( parseFloat( document.getElementById('vendas_produto_total_desconto').value ) / 100 )
        vartotaldescontous    = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
        vartotaldolar         = eval( parseFloat( document.getElementById('vendas_produto_unitario_dolar').value.replace(/\./g, "").replace(",", ".")) - vartotaldescontous )  ;
        var totaldolarresultus  = eval(  vartotaldolar * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

        document.getElementById('vendas_produto_unitario_dolar').value = ( number_format(vartotaldolar ,2, ',', '.') );
        document.getElementById('vendas_produto_total_dolar').value =  (number_format(totaldolarresultus,2, ',', '.') );

        vartotaldescontogs = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) * vardesconto )  ;
        vartotalgs         = eval( parseFloat( document.getElementById('vendas_produto_unitario_guarani').value.replace(/\./g, "").replace(",", ".") ) - vartotaldescontogs )  ;
        var totaldolarresultgs  = eval(  vartotalgs * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )  ;

        document.getElementById('vendas_produto_unitario_guarani').value = ( number_format(vartotalgs ,0, ',', '.') );
        document.getElementById('vendas_produto_total_guarani').value = ( number_format(totaldolarresultgs ,0, ',', '.') );


    }

}

function VendasProdutoPorcentagemInversa()                              //
{
    if(document.getElementById('moeda').value == 1)
    {
        var valorgs       = eval( document.getElementById('vendas_produto_preco_fixo_guarani').value.replace(/\./g, "").replace(",", ".") * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")))

        var margemgs   = eval( ( ( parseFloat( document.getElementById('vendas_produto_total_guarani').value.replace(/\./g, "").replace(",", ".") - valorgs ) ) * 100 )  / valorgs ) * -1;
        if( margemgs.toFixed(6) > 0  ){
            document.getElementById('vendas_produto_total_desconto').value   = number_format(margemgs ,6, ',', '.');
            document.getElementById('vendas_produto_interes').value          = 0;
        }
        else
        {
            document.getElementById('vendas_produto_interes').value          = number_format((margemgs * -1),6, ',', '.');
            document.getElementById('vendas_produto_total_desconto').value   = 0;
        }
    }
    else if(document.getElementById('moeda').value == 0 )
    {
        var valorus  = eval( document.getElementById('vendas_produto_preco_fixo_dolar').value.replace(/\./g, "").replace(",", ".") * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )

        var margemus   = eval( ( ( parseFloat( document.getElementById('vendas_produto_total_dolar').value.replace(/\./g, "").replace(",", ".") - valorus ) ) * 100 )  / valorus ) * -1 ;
        if( margemus.toFixed(6) > 0  ){
            document.getElementById('vendas_produto_total_desconto').value   = number_format(margemus ,6, ',', '.');
            document.getElementById('vendas_produto_interes').value          = 0;
        }
        else
        {
            document.getElementById('vendas_produto_interes').value          = number_format((margemus * -1.000),6, ',', '.');
            document.getElementById('vendas_produto_total_desconto').value   = 0;
        }

    }

    else
    {
        var valorus  = eval( document.getElementById('vendas_produto_preco_fixo_real').value.replace(/\./g, "").replace(",", ".") * parseFloat( document.getElementById('vendas_produto_quantidade').value.replace(/\./g, "").replace(",", ".")) )

        var margemus   = eval( ( ( parseFloat( document.getElementById('vendas_produto_total_real').value.replace(/\./g, "").replace(",", ".") - valorus ) ) * 100 )  / valorus ) * -1 ;
        if( margemus.toFixed(6) > 0  ){
            document.getElementById('vendas_produto_total_desconto').value   = number_format(margemus ,6, ',', '.');
            document.getElementById('vendas_produto_interes').value          = 0;
        }
        else
        {
            document.getElementById('vendas_produto_interes').value          = number_format((margemus * -1.000),6, ',', '.');
            document.getElementById('vendas_produto_total_desconto').value   = 0;
        }

    }

}
