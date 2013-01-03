require 'test_helper'

class SafraImpurezasControllerTest < ActionController::TestCase
  setup do
    @safra_impureza = safra_impurezas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_impurezas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_impureza" do
    assert_difference('SafraImpureza.count') do
      post :create, safra_impureza: { desconto: @safra_impureza.desconto, informado: @safra_impureza.informado, produto_id: @safra_impureza.produto_id, safra_id: @safra_impureza.safra_id, safra_produto_id: @safra_impureza.safra_produto_id }
    end

    assert_redirected_to safra_impureza_path(assigns(:safra_impureza))
  end

  test "should show safra_impureza" do
    get :show, id: @safra_impureza
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_impureza
    assert_response :success
  end

  test "should update safra_impureza" do
    put :update, id: @safra_impureza, safra_impureza: { desconto: @safra_impureza.desconto, informado: @safra_impureza.informado, produto_id: @safra_impureza.produto_id, safra_id: @safra_impureza.safra_id, safra_produto_id: @safra_impureza.safra_produto_id }
    assert_redirected_to safra_impureza_path(assigns(:safra_impureza))
  end

  test "should destroy safra_impureza" do
    assert_difference('SafraImpureza.count', -1) do
      delete :destroy, id: @safra_impureza
    end

    assert_redirected_to safra_impurezas_path
  end
end
