
class TransferenciaContasController < ApplicationController
    before_filter :authenticate

    def busca_diferido             #
        @diferido = Financa.all(:conditions => ["DATA BETWEEN ? AND ? AND CONTA_ID = ? AND MOEDA = ? AND CHEQUE_STATUS = 1 AND ESTADO = 0",params[:inicio],params[:final],params[:conta_id],params[:moeda]])
        render :layout => 'consulta'
    end

    def resultado_busca_diferido   #
        @transferencia_conta = TransferenciaConta.find(params[:id])

        @diferido  = Financa.find(params[:diferido_ids])
        TransferenciaContasDetalhe.destroy_all("transferencia_conta_id =#{params[:id]} AND cheque_status = 1 " )
        @diferido.each do |df|
          if @transferencia_conta.deposito == 2
            if @transferencia_conta.destino_moeda == 0 && @transferencia_conta.ingreso_moeda == 1 

               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,  
                  :entrada_real            => 0,  
                  :saida_dolar             => df.entrada_guarani / @transferencia_conta.cotacao.to_f ,
                  :saida_guarani           => df.entrada_guarani.to_f,
                  :saida_real              => df.entrada_guarani.to_f / @transferencia_conta.cotacao_real.to_f ,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )
            elsif @transferencia_conta.destino_moeda == 1 && @transferencia_conta.ingreso_moeda == 0

               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,
                  :entrada_real            => 0,
                  :saida_dolar             => df.entrada_dolar.to_f,
                  :saida_guarani           => df.entrada_dolar * @transferencia_conta.cotacao.to_f,
                  :saida_real              => df.entrada_guarani / @transferencia_conta.cotacao_real.to_f,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )

            else

               TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                  :original                => df.data,
                  :diferido                => df.diferido,
                  :data                    => @transferencia_conta.data,
                  :moeda                   => df.moeda,
                  :status                  => 0,
                  :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                  :destino_moeda           => @transferencia_conta.destino_moeda,
                  :deposito                => @transferencia_conta.deposito,
                  :conta_origem_id         => @transferencia_conta.ingreso_id,
                  :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                  :conta_destino_id        => @transferencia_conta.destino_id,
                  :conta_destino_nome      => @transferencia_conta.destino_nome,
                  :persona_id              => df.persona_id,
                  :persona_nome            => df.persona_nome,
                  :cheque                  => df.cheque,
                  :banco                   => df.banco,
                  :titular                 => df.titular,
                  :concepto                => @transferencia_conta.concepto,
                  :cheque_status           => 1,
                  :entrada_dolar           => 0,
                  :entrada_guarani         => 0,
                  :entrada_real            => 0,
                  :saida_dolar             => df.entrada_dolar.to_f,
                  :saida_guarani           => df.entrada_guarani.to_f,
                  :saida_real              => df.entrada_real.to_f,
                  :tabela_id               => df.id,
                  :tabela                  => 'CHEQUES DIFERIDOS' )
            
            end
          else
            TransferenciaContasDetalhe.create( :transferencia_conta_id  => @transferencia_conta.id,
                :original                => df.data,
                :diferido                => df.diferido,
                :data                    => @transferencia_conta.data,
                :moeda                   => df.moeda,
                :status                  => 0,
                :ingreso_moeda           => @transferencia_conta.ingreso_moeda,
                :destino_moeda           => @transferencia_conta.destino_moeda,
                :deposito                => @transferencia_conta.deposito,
                :conta_origem_id         => @transferencia_conta.ingreso_id,
                :conta_origem_nome       => @transferencia_conta.ingreso_nome,
                :conta_destino_id        => @transferencia_conta.destino_id,
                :conta_destino_nome      => @transferencia_conta.destino_nome,
                :persona_id              => df.persona_id,
                :persona_nome            => df.persona_nome,
                :cheque                  => df.cheque,
                :banco                   => df.banco,
                :titular                 => df.titular,
                :concepto                => @transferencia_conta.concepto,
                :cheque_status           => 1,
                :entrada_dolar           => 0,
                :entrada_guarani         => 0,
                :entrada_real            => 0,
                :saida_dolar             => df.entrada_dolar,
                :saida_guarani           => df.entrada_guarani,
                :saida_real              => df.entrada_real,
                :tabela_id               => df.id,
                :tabela                  => 'CHEQUES DIFERIDOS' )
        end
       end 
        render :layout => 'consulta'
        
    end

    def get_moeda                  #
        @moeda =  Moeda.find(:first,:select => 'dolar_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('transferencia_conta_cotacao').value       = '#{@moeda.dolar_venda.to_i}';
                            </script>"
    end

    def get_moeda_real            #
        @moeda =  Moeda.find(:first,:select => 'real_venda', :conditions =>  [ "data = ?", params[:key]])
        return render :text => "<script type='text/javascript'>
                               document.getElementById('transferencia_conta_cotacao_real').value       = '#{@moeda.real_venda.to_i}';
                            </script>"
    end


    def index                      #

        respond_to do |format|
            format.html # index.html.erb
        end
    end

    def busca                      #
        @transferencia_contas = TransferenciaConta.filtro(params)
        respond_to do |format|
            format.html { render :layout => false}
        end
    end

    def show                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])

        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])

        respond_to do |format|
            format.html # show.html.erb
        end
    end

    def comprovante                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
         
        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])
        
        render :layout => false
    end

    def viatico                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
         
        @diferido            = TransferenciaContasDetalhe.all(:conditions => ["transferencia_conta_id = ?",@transferencia_conta.id])
        
        render :layout => false
    end


    def new                        #
        @transferencia_conta = TransferenciaConta.new        
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @transferencia_conta }
        end
    end

    def edit                       #
        @transferencia_conta = TransferenciaConta.find(params[:id])
    end

    def create                     #
        @transferencia_conta = TransferenciaConta.new(params[:transferencia_conta])
        @transferencia_conta.usuario_created = current_user.id
        @transferencia_conta.unidade_created = current_unidade.id

        respond_to do |format|
            if @transferencia_conta.save
                format.html { redirect_to(@transferencia_conta) }
            else
                format.html { render :action => "new" }
            end
        end
    end

    def update                     #
        @transferencia_conta = TransferenciaConta.find(params[:id])
        @transferencia_conta.usuario_updated = current_user.id
        @transferencia_conta.unidade_updated = current_unidade.id

        respond_to do |format|
            if @transferencia_conta.update_attributes(params[:transferencia_conta])
                format.html { redirect_to(@transferencia_conta) }
            else
                format.html { render :action => "edit" }
            end
        end
    end

    def destroy                    #
    
    @transferencia_conta = TransferenciaConta.find(params[:id])
    @transferencia_conta.destroy

      respond_to do |format|
                format.html { redirect_to(transferencia_contas_url) }
        format.xml  { head :ok }
      end
    end
end
