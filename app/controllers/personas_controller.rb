class PersonasController < ApplicationController
    before_filter :authenticate

    def get_estado                  #
        @cidade =  Cidade.find(:first, :conditions =>  [ "id = ?", params[:persona_cidade_id]])
        return render :text => "<script type='text/javascript'>
                              document.getElementById('persona_estado_nome').value       = '#{@cidade.nome.to_s}';
                            </script>"
    end

    def persona_compra              #
        render :layout => 'consulta'
    end

    def busca_persona_compra        #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false
    end


    def busca_cliente        #

        tipo = "nome" if params[:tipo] == "DESCRIPCION"
        tipo = "ruc"  if params[:tipo] == "RUC"
        persona = "AND tipo_fornecedor = 1"    if params[:per] == "PROVEEDOR"
        persona = "AND tipo_cliente = 1"       if params[:per] == "CLIENTE"
        persona = "AND tipo_fabricante = 1"    if params[:per] == "FABRICANTE"
        persona = "AND tipo_intermediario = 1" if params[:per] == "CORPORATIVO"  
        persona = "AND tipo_laboratorio = 1"   if params[:per] == "LABORATORIO"
        persona = "AND tipo_vendedor = 1"      if params[:per] == "VENDEDOR"
        persona = "AND tipo_funcionario = 1"   if params[:per] == "EMPLEADO"
        persona = "AND tipo_maiorista = 1"     if params[:per] == "MAYORISTA"
        persona = "AND tipo_despachante = 1"   if params[:per] == "DESPACHANTE"
        persona = ""   if params[:persona] == ""

        @personas = Persona.all(:select => 'id,cod_velho,nome,classificacao,ruc,tipo,estado,telefone,cidade,direcao',
            :conditions => ["#{tipo} LIKE ? #{persona}", "%#{params[:busca]}%"],
            :order => "nome")
        respond_to do |format|
            format.html {render :layout => false}

            format.js { render :layout => false }
        end
    end


    def persona_venda               #
        render :layout => 'consulta'
    end

    def busca_persona_venda         #

        @personas = Persona.paginate( :select     => ' id,
                                                     nome,
                                                     cod_velho,
                                                     limite_credito,
                                                     classificacao,
                                                     ruc,
                                                     cliente,
                                                     tipo_maiorista,
                                                     direcao,
                                                     cidade_id,
                                                     cidade,
                                                     bairro
            ',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page       => params[:page],
            :per_page   => 100,
            :order      => "nome"
        )

        render :layout => false

    end

    def persona_presupuesto         #
        render :layout => 'consulta'
    end

    def busca_persona_presupuesto   #

        @personas = Persona.paginate( :select     => ' id,
                                                     nome,
                                                     classificacao,
                                                     ruc,
                                                     cliente,
                                                     direcao,
                                                     cidade_id,
                                                     cidade,
                                                     bairro
            ',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page       => params[:page],
            :per_page   => 100,
            :order      => "nome"
        )

        render :layout => false

    end

    def persona_nota_credito        #
        render :layout => 'consulta'
    end

    def busca_persona_nota_credito  #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cidade,cidade_id,direcao',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def persona_nota_credito_proveedor        #
        render :layout => 'consulta'
    end

    def busca_persona_nota_credito_proveedor  #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cidade,cidade_id,direcao',
            :conditions => ['nome LIKE ? AND tipo_fornecedor = 100', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def persona_venda_financa       #
        render :layout => 'consulta'
    end

    def busca_persona_venda_financa #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,bairro,ruc,tipo,estado,cidade,cidade_id,direcao',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def persona_ordem               #
        render :layout => 'consulta'
    end

    def busca_persona_ordem         #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def persona_cobro               #
        render :layout => 'consulta'
    end

    def busca_persona_cobro         #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado,cod_velho',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def persona_pago                #
        render :layout => 'consulta'
    end

    def busca_persona_pago          #

        @personas = Persona.paginate(:select => 'id,nome,classificacao,telefone,ruc,tipo,estado',
            :conditions => ['nome LIKE ?', "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 100,
            :order => "nome"
        )

        render :layout => false

    end

    def busca                       #
        tipo = "nome" if params[:tipo] == "DESCRIPCION"
        tipo = "ruc"  if params[:tipo] == "RUC"
        persona = "AND tipo_fornecedor = 1"    if params[:per] == "PROVEEDOR"
        persona = "AND tipo_cliente = 1"       if params[:per] == "CLIENTE"
        persona = "AND tipo_fabricante = 1"    if params[:per] == "FABRICANTE"
        persona = "AND tipo_intermediario = 1" if params[:per] == "CORPORATIVO"  
        persona = "AND tipo_laboratorio = 1"   if params[:per] == "LABORATORIO"
        persona = "AND tipo_vendedor = 1"      if params[:per] == "VENDEDOR"
        persona = "AND tipo_funcionario = 1"   if params[:per] == "EMPLEADO"
        persona = "AND tipo_maiorista = 1"     if params[:per] == "MAYORISTA"
        persona = "AND tipo_despachante = 1"   if params[:per] == "DESPACHANTE"
        persona = ""   if params[:persona] == ""

        @personas = Persona.paginate(:select => 'id,cod_velho,nome,classificacao,ruc,tipo,estado',
            :conditions => ["#{tipo} LIKE ? #{persona}", "%#{params[:busca]}%"],
            :page     => params[:page],
            :per_page => 50,
            :order => "nome"
        )
        respond_to do |format|
            format.html {render :layout => false}
            format.js { render :layout => false }
        end

      

    end

    #METHOD BASE--------------------------------------------------------------------

    def tarjeta          #

        @persona = Persona.find(params[:id])
        render :layout => false

    end


    def index         #

    end

    def show          #

        @persona = Persona.find(params[:id])

    end

    def new           #
        @persona = Persona.new
    
        find_cod_cliente = Persona.first( :order => "cod_velho DESC", :select => "cod_velho",:conditions => ["cod_velho < 9997"] )
        @cod_cliente      = find_cod_cliente.cod_velho + 1 if $empresa == 'E01'

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @persona }
        end
    end

    def edit          #
        @persona = Persona.find(params[:id])
        @cliente_saldo = Cliente.sum('divida_dolar - cobro_dolar',:conditions => ["persona_id = ?",@persona.id])
    end

    def create        #
        @persona = Persona.new(params[:persona])



        respond_to do |format|
            if @persona.save
                flash[:notice] = 'Grabado con Sucesso !'
                format.html { redirect_to(personas_url) }
                format.xml  { render :xml => @persona, :status => :created, :location => @persona }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @persona.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update        #
        @persona = Persona.find(params[:id])
        @persona.usuario_updated = current_user.usuario_nome
        @persona.unidade_updated = current_unidade.unidade_nome

        respond_to do |format|
            if @persona.update_attributes(params[:persona])
                flash[:notice] = 'Actualizado con Sucesso'
                format.html { redirect_to(personas_url) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @persona.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy       #
        @persona = Persona.find(params[:id])
        @persona.destroy

        respond_to do |format|
            format.html { redirect_to(personas_url) }
            format.xml  { head :ok }
        end
    end
end
