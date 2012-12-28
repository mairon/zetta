require 'test_helper'

class BicosControllerTest < ActionController::TestCase
  setup do
    @bico = bicos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bicos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bico" do
    assert_difference('Bico.count') do
      post :create, bico: { codigo_tec: @bico.codigo_tec, nome: @bico.nome, vazao: @bico.vazao }
    end

    assert_redirected_to bico_path(assigns(:bico))
  end

  test "should show bico" do
    get :show, id: @bico
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bico
    assert_response :success
  end

  test "should update bico" do
    put :update, id: @bico, bico: { codigo_tec: @bico.codigo_tec, nome: @bico.nome, vazao: @bico.vazao }
    assert_redirected_to bico_path(assigns(:bico))
  end

  test "should destroy bico" do
    assert_difference('Bico.count', -1) do
      delete :destroy, id: @bico
    end

    assert_redirected_to bicos_path
  end
end
