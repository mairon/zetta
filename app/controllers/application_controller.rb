class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :current_unidade
  helper ApplicationHelper
  
  def current_user          #
    @current_user ||= Usuario.find(session[:logged],:select => 'id,usuario_nome,tipo')
  end

  def current_unidade       #
    @current_unidade ||= Unidade.find(session[:unidade],:select => 'id,unidade_nome')
  end
    
  def authenticate          #
    if session[:logged]
      true

    else
      redirect_to new_login_path
    end

  end  
end
