require 'test_helper'

class SafrasControllerTest < ActionController::TestCase
  setup do
    @safra = safras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:safras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create safra" do
    assert_difference('Safra.count') do
      post :create, safra: { descricao: @safra.descricao, final: @safra.final, inicio: @safra.inicio }
    end

    assert_redirected_to safra_path(assigns(:safra))
  end

  test "should show safra" do
    get :show, id: @safra
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @safra
    assert_response :success
  end

  test "should update safra" do
    put :update, id: @safra, safra: { descricao: @safra.descricao, final: @safra.final, inicio: @safra.inicio }
    assert_redirected_to safra_path(assigns(:safra))
  end

  test "should destroy safra" do
    assert_difference('Safra.count', -1) do
      delete :destroy, id: @safra
    end

    assert_redirected_to safras_path
  end
end
