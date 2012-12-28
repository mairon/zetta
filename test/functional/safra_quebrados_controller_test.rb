require 'test_helper'

class SafraQuebradosControllerTest < ActionController::TestCase
  setup do
    @safra_quebrado = safra_quebrados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safra_quebrados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra_quebrado" do
    assert_difference('SafraQuebrado.count') do
      post :create, safra_quebrado: { desconto: @safra_quebrado.desconto, informado: @safra_quebrado.informado, produto_id: @safra_quebrado.produto_id, safra_id: @safra_quebrado.safra_id, safra_produto_id: @safra_quebrado.safra_produto_id }
    end

    assert_redirected_to safra_quebrado_path(assigns(:safra_quebrado))
  end

  test "should show safra_quebrado" do
    get :show, id: @safra_quebrado
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra_quebrado
    assert_response :success
  end

  test "should update safra_quebrado" do
    put :update, id: @safra_quebrado, safra_quebrado: { desconto: @safra_quebrado.desconto, informado: @safra_quebrado.informado, produto_id: @safra_quebrado.produto_id, safra_id: @safra_quebrado.safra_id, safra_produto_id: @safra_quebrado.safra_produto_id }
    assert_redirected_to safra_quebrado_path(assigns(:safra_quebrado))
  end

  test "should destroy safra_quebrado" do
    assert_difference('SafraQuebrado.count', -1) do
      delete :destroy, id: @safra_quebrado
    end

    assert_redirected_to safra_quebrados_path
  end
end
