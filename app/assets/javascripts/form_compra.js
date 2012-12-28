//exibe div valores
function ExibeDivCompraDetalheFatura(){
      if ( $('#moeda').val() == '0' ){
          $('#MOEDA_FATURA_DOLAR').css("display", "inline");
          $('#MOEDA_FATURA_GUARANI').css("display", "none");
          $('#MOEDA_FATURA_REAL').css("display", "none");
      }
      else if ( $('#moeda').val() == '1' ){
          $('#MOEDA_FATURA_DOLAR').css("display", "none");
          $('#MOEDA_FATURA_GUARANI').css("display", "inline");
          $('#MOEDA_FATURA_REAL').css("display", "none");

      }
     else if ( $('#moeda').val() == '2' ){
          $('#MOEDA_FATURA_DOLAR').css("display", "none");
          $('#MOEDA_FATURA_GUARANI').css("display", "none");
          $('#MOEDA_FATURA_REAL').css("display", "none");    
     }
  }
   
  function MoedaCompra(d){
      $('#moeda').val(d);
  }

  function TipoCompra(d){
      $('#tipo').val(d)
  }


  function CompraTipoDocumento(){

    if ( $('#tipo').val() == '0' ){
      $('#compra_documento_id').find('option[value="2"]').attr('selected',true).change();
    }
    else {
      $('#compra_documento_id').find('option[value="3"]').attr('selected',true).change();
    }
  } 

//calculos
//Dolar/Real
function CompraGravada05Dolar(grv,imp){
  var vartotal = eval( parseFloat( document.getElementById( grv ).value.replace(/\./g, "").replace(",", ".") ) / 1.05 );
  document.getElementById( imp ).value = ( number_format(vartotal * 0.05,2, ',', '.') );
}

function CompraGravada10Dolar(grv10,grv05,ext,imp,tot){
  var vartotal = eval( parseFloat( document.getElementById( grv10 ).value.replace(/\./g, "").replace(",", ".") ) / 1.1 );
  document.getElementById( imp ).value = ( number_format(vartotal * 0.10,2, ',', '.') );

  var imposto10Dolar = parseFloat( document.getElementById(grv10).value.replace(/\./g, "").replace(",", ".") )
  var imposto05Dolar = parseFloat( document.getElementById(grv05).value.replace(/\./g, "").replace(",", ".") )
  var exentas        = parseFloat( document.getElementById(ext).value.replace(/\./g, "").replace(",", ".") )
  var total          = eval( imposto10Dolar + imposto05Dolar + exentas )
  document.getElementById( tot ).value =  ( number_format(total,2, ',', '.') )
}

//Guaranies
function CompraGravada05Gs(){
  var vartotal = eval( parseFloat( document.getElementById( 'compra_gravadas_05_guarani' ).value.replace(/\./g, "").replace(",", ".") ) / 1.05 );
  document.getElementById( 'compra_imposto_05_guarani' ).value = ( number_format(vartotal * 0.05,0, ',', '.') );
}

function CompraGravada10Gs(){
  var vartotal = eval( parseFloat( document.getElementById( 'compra_gravadas_10_guarani' ).value.replace(/\./g, "").replace(",", ".") ) / 1.1 );
  document.getElementById( 'compra_imposto_10_guarani' ).value = ( number_format(vartotal * 0.10,0, ',', '.') );

  var imposto10Gs = parseFloat( document.getElementById('compra_gravadas_10_guarani').value.replace(/\./g, "").replace(",", ".") )
  var imposto05Gs = parseFloat( document.getElementById('compra_gravadas_05_guarani').value.replace(/\./g, "").replace(",", ".") )
  var exentas     = parseFloat( document.getElementById('compra_exentas_guarani').value.replace(/\./g, "").replace(",", ".") )
  var total       = eval( imposto10Gs + imposto05Gs + exentas )
  document.getElementById( 'compra_total_guarani' ).value = ( number_format(total,0, ',', '.') )
}

document.onkeydown=function(e){
if(e.which == 113)
   window.open('/personas/persona_compra', 'Pagina', ' SCROLLBARS=YES, TOP=10, LEFT=10, WIDTH=1000, HEIGHT=400');
}
