require 'test_helper'

class SafraVerdososControllerTest < ActionController::TestCase
  setup do
    @safra_verdoso = safra_verdosos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_verdosos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_verdoso" do
    assert_difference('SafraVerdoso.count') do
      post :create, safra_verdoso: { desconto: @safra_verdoso.desconto, informado: @safra_verdoso.informado, produto_id: @safra_verdoso.produto_id, safra_id: @safra_verdoso.safra_id, safra_produto_id: @safra_verdoso.safra_produto_id }
    end

    assert_redirected_to safra_verdoso_path(assigns(:safra_verdoso))
  end

  test "should show safra_verdoso" do
    get :show, id: @safra_verdoso
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_verdoso
    assert_response :success
  end

  test "should update safra_verdoso" do
    put :update, id: @safra_verdoso, safra_verdoso: { desconto: @safra_verdoso.desconto, informado: @safra_verdoso.informado, produto_id: @safra_verdoso.produto_id, safra_id: @safra_verdoso.safra_id, safra_produto_id: @safra_verdoso.safra_produto_id }
    assert_redirected_to safra_verdoso_path(assigns(:safra_verdoso))
  end

  test "should destroy safra_verdoso" do
    assert_difference('SafraVerdoso.count', -1) do
      delete :destroy, id: @safra_verdoso
    end

    assert_redirected_to safra_verdosos_path
  end
end
