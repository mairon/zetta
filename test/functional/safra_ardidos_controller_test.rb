require 'test_helper'

class SafraArdidosControllerTest < ActionController::TestCase
  setup do
    @safra_ardido = safra_ardidos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_ardidos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_ardido" do
    assert_difference('SafraArdido.count') do
      post :create, safra_ardido: { desconto: @safra_ardido.desconto, informado: @safra_ardido.informado, produto_id: @safra_ardido.produto_id, safra_id: @safra_ardido.safra_id, safra_produto_id: @safra_ardido.safra_produto_id }
    end

    assert_redirected_to safra_ardido_path(assigns(:safra_ardido))
  end

  test "should show safra_ardido" do
    get :show, id: @safra_ardido
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_ardido
    assert_response :success
  end

  test "should update safra_ardido" do
    put :update, id: @safra_ardido, safra_ardido: { desconto: @safra_ardido.desconto, informado: @safra_ardido.informado, produto_id: @safra_ardido.produto_id, safra_id: @safra_ardido.safra_id, safra_produto_id: @safra_ardido.safra_produto_id }
    assert_redirected_to safra_ardido_path(assigns(:safra_ardido))
  end

  test "should destroy safra_ardido" do
    assert_difference('SafraArdido.count', -1) do
      delete :destroy, id: @safra_ardido
    end

    assert_redirected_to safra_ardidos_path
  end
end
