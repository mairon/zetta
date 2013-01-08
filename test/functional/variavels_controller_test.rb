require 'test_helper'

class VariavelsControllerTest < ActionController::TestCase
  setup do
    @variavel = variavels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variavels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variavel" do
    assert_difference('Variavel.count') do
      post :create, variavel: { nome: @variavel.nome, sigla: @variavel.sigla, unidade_metrica_id: @variavel.unidade_metrica_id, unidade_metrica_nome: @variavel.unidade_metrica_nome, valor: @variavel.valor }
    end

    assert_redirected_to variavel_path(assigns(:variavel))
  end

  test "should show variavel" do
    get :show, id: @variavel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variavel
    assert_response :success
  end

  test "should update variavel" do
    put :update, id: @variavel, variavel: { nome: @variavel.nome, sigla: @variavel.sigla, unidade_metrica_id: @variavel.unidade_metrica_id, unidade_metrica_nome: @variavel.unidade_metrica_nome, valor: @variavel.valor }
    assert_redirected_to variavel_path(assigns(:variavel))
  end

  test "should destroy variavel" do
    assert_difference('Variavel.count', -1) do
      delete :destroy, id: @variavel
    end

    assert_redirected_to variavels_path
  end
end
