require 'test_helper'

class SafraAveriadosControllerTest < ActionController::TestCase
  setup do
    @safra_averiado = safra_averiados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_averiados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_averiado" do
    assert_difference('SafraAveriado.count') do
      post :create, safra_averiado: { desconto: @safra_averiado.desconto, informado: @safra_averiado.informado, produto_id: @safra_averiado.produto_id, safra_id: @safra_averiado.safra_id, safra_produto_id: @safra_averiado.safra_produto_id }
    end

    assert_redirected_to safra_averiado_path(assigns(:safra_averiado))
  end

  test "should show safra_averiado" do
    get :show, id: @safra_averiado
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_averiado
    assert_response :success
  end

  test "should update safra_averiado" do
    put :update, id: @safra_averiado, safra_averiado: { desconto: @safra_averiado.desconto, informado: @safra_averiado.informado, produto_id: @safra_averiado.produto_id, safra_id: @safra_averiado.safra_id, safra_produto_id: @safra_averiado.safra_produto_id }
    assert_redirected_to safra_averiado_path(assigns(:safra_averiado))
  end

  test "should destroy safra_averiado" do
    assert_difference('SafraAveriado.count', -1) do
      delete :destroy, id: @safra_averiado
    end

    assert_redirected_to safra_averiados_path
  end
end
