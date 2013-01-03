
$(document).ready(function() {
	//foco na primeira input de cada form
  $('input:text:first').focus();
  
	//letra maiuscula nas inputs
	$('input:text').keyup(function() {
		$(this).val($(this).val().toUpperCase());
	});
});

function bloqEnter(objEvent) {
    var iKeyCode;
    iKeyCode = objEvent.keyCode;
    if(iKeyCode == 13) return false;
    return true;
}

function EnterTab(event,id){
    if( event.keyCode == 13 ){
        var wow = document.getElementById(id);
        wow.focus();
    }
}

function Formatadata(Campo, teclapres)  //
{
    var tecla = teclapres.keyCode;
    var vr = new String(Campo.value);
    vr = vr.replace("/", "");
    vr = vr.replace("/", "");
    vr = vr.replace("/", "");
    tam = vr.length + 1;
    if (tecla != 8 && tecla != 8)
    {
        if (tam > 0 && tam < 2)
            Campo.value = vr.substr(0, 2) ;
        if (tam > 2 && tam < 4)
            Campo.value = vr.substr(0, 2) + '/' + vr.substr(2, 2);
        if (tam > 4 && tam < 7)
            Campo.value = vr.substr(0, 2) + '/' + vr.substr(2, 2) + '/' + vr.substr(4, 7);
    }
}


function DataCotacao(d,m,y){
    document.getElementById("key").value = document.getElementById(d).value+'/'+ document.getElementById(m).value+'/'+document.getElementById(y).value;
}

function number_format( number, decimals, dec_point, thousands_sep ) {
    var n = number, c = isNaN(decimals = Math.abs(decimals)) ? 2 : decimals;
    var d = dec_point == undefined ? "," : dec_point;
    var t = thousands_sep == undefined ? "." : thousands_sep, s = n < 0 ? "-" : "";
    var i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}


function UsToGsRs(ct,ctrs,us,gs,rs){
    var cambio = eval( parseFloat( document.getElementById(us).value.replace(/\./g, "").replace(",", ".") ) * Math.ceil( document.getElementById(ct).value ) ) ;
    document.getElementById(gs).value = ( number_format( cambio,0, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ctrs).value.replace(/\./g, "") ) )  ;
    document.getElementById(rs).value = ( number_format( cambiors,2, ',', '.') )

}

function GsToUsRs(ct,ctrs,gs,us,rs){
    var cambio = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ct).value.replace(/\./g, "") ) )  ;
    document.getElementById(us).value = ( number_format( cambio,2, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ctrs).value.replace(/\./g, "") ) )  ;
    document.getElementById(rs).value = ( number_format( cambiors,2, ',', '.') )
}


function RsToUsGs(ct,ctrs,gs,us,rs){
    var cambio = eval( parseFloat( document.getElementById(rs).value.replace(/\./g, "").replace(",", ".") ) * parseFloat( document.getElementById(ctrs).value.replace(/\./g, "") ) )  ;
    document.getElementById(gs).value = ( number_format( cambio,0, ',', '.') )

    var cambiors = eval( parseFloat( document.getElementById(gs).value.replace(/\./g, "") ) / parseFloat( document.getElementById(ct).value.replace(/\./g, "")) )  ;
    document.getElementById(us).value = ( number_format( cambiors,2, ',', '.') )
}
