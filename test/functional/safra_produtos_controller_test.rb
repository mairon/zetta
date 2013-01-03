require 'test_helper'

class SafraProdutosControllerTest < ActionController::TestCase
  setup do
    @safra_produto = safra_produtos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_produtos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_produto" do
    assert_difference('SafraProduto.count') do
      post :create, safra_produto: { produto_id: @safra_produto.produto_id, produto_nome: @safra_produto.produto_nome, safra_id: @safra_produto.safra_id }
    end

    assert_redirected_to safra_produto_path(assigns(:safra_produto))
  end

  test "should show safra_produto" do
    get :show, id: @safra_produto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_produto
    assert_response :success
  end

  test "should update safra_produto" do
    put :update, id: @safra_produto, safra_produto: { produto_id: @safra_produto.produto_id, produto_nome: @safra_produto.produto_nome, safra_id: @safra_produto.safra_id }
    assert_redirected_to safra_produto_path(assigns(:safra_produto))
  end

  test "should destroy safra_produto" do
    assert_difference('SafraProduto.count', -1) do
      delete :destroy, id: @safra_produto
    end

    assert_redirected_to safra_produtos_path
  end
end
