require 'test_helper'

class VendasFinancasControllerTest < ActionController::TestCase
  setup do
    @vendas_financa = vendas_financas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vendas_financas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vendas_financa" do
    assert_difference('VendasFinanca.count') do
      post :create, vendas_financa: {  }
    end

    assert_redirected_to vendas_financa_path(assigns(:vendas_financa))
  end

  test "should show vendas_financa" do
    get :show, id: @vendas_financa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vendas_financa
    assert_response :success
  end

  test "should update vendas_financa" do
    put :update, id: @vendas_financa, vendas_financa: {  }
    assert_redirected_to vendas_financa_path(assigns(:vendas_financa))
  end

  test "should destroy vendas_financa" do
    assert_difference('VendasFinanca.count', -1) do
      delete :destroy, id: @vendas_financa
    end

    assert_redirected_to vendas_financas_path
  end
end
