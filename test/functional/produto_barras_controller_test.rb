require 'test_helper'

class ProdutoBarrasControllerTest < ActionController::TestCase
  setup do
    @produto_barra = produto_barras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:produto_barras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create produto_barra" do
    assert_difference('ProdutoBarra.count') do
      post :create, produto_barra: { barra: @produto_barra.barra, produto_id: @produto_barra.produto_id, produto_nome: @produto_barra.produto_nome }
    end

    assert_redirected_to produto_barra_path(assigns(:produto_barra))
  end

  test "should show produto_barra" do
    get :show, id: @produto_barra
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @produto_barra
    assert_response :success
  end

  test "should update produto_barra" do
    put :update, id: @produto_barra, produto_barra: { barra: @produto_barra.barra, produto_id: @produto_barra.produto_id, produto_nome: @produto_barra.produto_nome }
    assert_redirected_to produto_barra_path(assigns(:produto_barra))
  end

  test "should destroy produto_barra" do
    assert_difference('ProdutoBarra.count', -1) do
      delete :destroy, id: @produto_barra
    end

    assert_redirected_to produto_barras_path
  end
end
