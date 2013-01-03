require 'test_helper'

class SafraUmidadesControllerTest < ActionController::TestCase
  setup do
    @safra_umidade = safra_umidades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_umidades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_umidade" do
    assert_difference('SafraUmidade.count') do
      post :create, safra_umidade: { desconto: @safra_umidade.desconto, informado: @safra_umidade.informado, produto_id: @safra_umidade.produto_id, safra_id: @safra_umidade.safra_id }
    end

    assert_redirected_to safra_umidade_path(assigns(:safra_umidade))
  end

  test "should show safra_umidade" do
    get :show, id: @safra_umidade
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_umidade
    assert_response :success
  end

  test "should update safra_umidade" do
    put :update, id: @safra_umidade, safra_umidade: { desconto: @safra_umidade.desconto, informado: @safra_umidade.informado, produto_id: @safra_umidade.produto_id, safra_id: @safra_umidade.safra_id }
    assert_redirected_to safra_umidade_path(assigns(:safra_umidade))
  end

  test "should destroy safra_umidade" do
    assert_difference('SafraUmidade.count', -1) do
      delete :destroy, id: @safra_umidade
    end

    assert_redirected_to safra_umidades_path
  end
end
