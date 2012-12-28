class NotaCreditosController < ApplicationController
before_filter :authenticate

   def get_moeda                #
        @moeda =  Moeda.find(:first, :conditions =>  [ "data = ?", params[:key]])

           return render :text => "<script type='text/javascript'>
                                   document.getElementById('nota_credito_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                                   </script>"
    end

   def faturas_en_abertas                #
           @faturas = Cliente.all(:conditions => ["persona_id = ? and liquidacao = 0 and tabela = 'VENDAS_FINANCAS'",params[:persona_id]])
           render :layout => 'consulta' 
    end


    def index                    #
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @nota_creditos }
        end
    end

    def busca_nc                         #
        @nota_creditos = NotaCredito.filtro_nc(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def show                     #
        @nota_credito = NotaCredito.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota_credito }
        end
    end

    def documentos                     #
        @nota_credito = NotaCredito.find(params[:id])

        @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])

        @total_doc_dolar   = NotaCreditosDoc.sum(:valor_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_doc_guarani = NotaCreditosDoc.sum(:valor_guarani,   :conditions => ['nota_credito_id = ?',params[:id]])

        if @nota_credito.operacao == 0 
          documentos_id = NotaCreditosDetalhe.all(:conditions => ["nota_credito_id = ?",params[:id]]).collect{|d| "'"<<d.documento_numero.to_s<<"'"}.join(", ")        
          cond = "AND documento_numero IN (#{documentos_id})"
        end 
        @cliente  = Cliente.all( :select => ' id,
                                              persona_id,
                                              persona_nome,
                                              vendedor_id,
                                              vendedor_nome,
                                              pagare,
                                              liquidacao,
                                              tipo,
                                              data,
                                              vencimento,
                                              venda_id,
                                              documento_nome,
                                              documento_numero,
                                              numero_ordem,
                                              cota,
                                              clase_produto,
                                              original,
                                              divida_dolar,
                                              divida_guarani,
                                              cobro_dolar,
                                              cobro_guarani,
                                              diferido,
                                              documento_numero_01,
                                              documento_numero_02',

                                 :conditions => ["liquidacao = 0 AND divida_guarani > 0 AND persona_id = ? #{cond}",@nota_credito.persona_id],:order => 'data,venda_id,cota')

        respond_to do |format|
            format.html # show.html.erb
        end
    end


    def nota_credito_financas    #
        @nota_credito       = NotaCredito.find(params[:id])
        @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota_credito }
        end
        session[:pagina] = ''
    end

    def nota_credito_comprovante #
        @nota_credito       = NotaCredito.find(params[:id])
        @total_nota_dolar   = NotaCreditosDetalhe.sum(:total_dolar,   :conditions => ['nota_credito_id = ?',params[:id]])
        @total_nota_guarani = NotaCreditosDetalhe.sum(:total_guarani, :conditions => ['nota_credito_id = ?',params[:id]])
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @nota_credito }
        end
    end

    def new                      #
        @nota_credito = NotaCredito.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @nota_credito }
        end
    end

    def edit                     #
        @nota_credito = NotaCredito.find(params[:id])
        session[:pagina] = '1'
    end

    def create                   #
        @nota_credito = NotaCredito.new(params[:nota_credito])
        @nota_credito.usuario_created = current_user.usuario_nome
        @nota_credito.unidade_created = current_unidade.unidade_nome


        respond_to do |format|
            if @nota_credito.save
                flash[:notice] = 'Grabado con Sucesso!'
                if @nota_credito.operacao == 0
                  format.html { redirect_to(@nota_credito) }
                else
                    format.html { redirect_to "/nota_creditos/documentos/#{@nota_credito.id}" }
                end
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                   #
        @nota_credito = NotaCredito.find(params[:id])
        @nota_credito.usuario_updated = current_user.usuario_nome
        @nota_credito.unidade_updated = current_unidade.unidade_nome

        respond_to do |format|
            if @nota_credito.update_attributes(params[:nota_credito])
                flash[:notice] = 'Actualizado con Sucesso!'
                if session[:pagina] == ''
                    format.html { redirect_to "/nota_creditos/nota_credito_comprovante/#{@nota_credito.id}" }
                else
                  if @nota_credito.operacao == 0
                    format.html { redirect_to(@nota_credito) }
                   else
                    format.html { redirect_to "/nota_creditos/documentos/#{@nota_credito.id}" }
                 end

                end
                format.html { redirect_to(@nota_credito) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @nota_credito.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy                  #
        @nota_credito = NotaCredito.find(params[:id])
        @nota_credito.destroy

        respond_to do |format|
            format.html { redirect_to(nota_creditos_url) }
        end
    end
end
