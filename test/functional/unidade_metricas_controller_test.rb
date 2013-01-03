require 'test_helper'

class UnidadeMetricasControllerTest < ActionController::TestCase
  setup do
    @unidade_metrica = unidade_metricas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unidade_metricas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unidade_metrica" do
    assert_difference('UnidadeMetrica.count') do
      post :create, unidade_metrica: { nome: @unidade_metrica.nome, sigla: @unidade_metrica.sigla }
    end

    assert_redirected_to unidade_metrica_path(assigns(:unidade_metrica))
  end

  test "should show unidade_metrica" do
    get :show, id: @unidade_metrica
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unidade_metrica
    assert_response :success
  end

  test "should update unidade_metrica" do
    put :update, id: @unidade_metrica, unidade_metrica: { nome: @unidade_metrica.nome, sigla: @unidade_metrica.sigla }
    assert_redirected_to unidade_metrica_path(assigns(:unidade_metrica))
  end

  test "should destroy unidade_metrica" do
    assert_difference('UnidadeMetrica.count', -1) do
      delete :destroy, id: @unidade_metrica
    end

    assert_redirected_to unidade_metricas_path
  end
end
