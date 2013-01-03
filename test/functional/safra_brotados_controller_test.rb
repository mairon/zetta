require 'test_helper'

class SafraBrotadosControllerTest < ActionController::TestCase
  setup do
    @safra_brotado = safra_brotados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_brotados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_brotado" do
    assert_difference('SafraBrotado.count') do
      post :create, safra_brotado: { desconto: @safra_brotado.desconto, informado: @safra_brotado.informado, produto_id: @safra_brotado.produto_id, safra_id: @safra_brotado.safra_id, safra_produto_id: @safra_brotado.safra_produto_id }
    end

    assert_redirected_to safra_brotado_path(assigns(:safra_brotado))
  end

  test "should show safra_brotado" do
    get :show, id: @safra_brotado
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_brotado
    assert_response :success
  end

  test "should update safra_brotado" do
    put :update, id: @safra_brotado, safra_brotado: { desconto: @safra_brotado.desconto, informado: @safra_brotado.informado, produto_id: @safra_brotado.produto_id, safra_id: @safra_brotado.safra_id, safra_produto_id: @safra_brotado.safra_produto_id }
    assert_redirected_to safra_brotado_path(assigns(:safra_brotado))
  end

  test "should destroy safra_brotado" do
    assert_difference('SafraBrotado.count', -1) do
      delete :destroy, id: @safra_brotado
    end

    assert_redirected_to safra_brotados_path
  end
end
