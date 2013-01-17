require 'test_helper'

class MetaControllerTest < ActionController::TestCase
  setup do
    @metum = meta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metum" do
    assert_difference('Metum.count') do
      post :create, metum: { data: @metum.data, moeda: @metum.moeda, periodo_final: @metum.periodo_final, periodo_inicio: @metum.periodo_inicio, persona_id: @metum.persona_id, persona_nome: @metum.persona_nome, valor_dolar: @metum.valor_dolar, valor_guarani: @metum.valor_guarani, valor_real: @metum.valor_real }
    end

    assert_redirected_to metum_path(assigns(:metum))
  end

  test "should show metum" do
    get :show, id: @metum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @metum
    assert_response :success
  end

  test "should update metum" do
    put :update, id: @metum, metum: { data: @metum.data, moeda: @metum.moeda, periodo_final: @metum.periodo_final, periodo_inicio: @metum.periodo_inicio, persona_id: @metum.persona_id, persona_nome: @metum.persona_nome, valor_dolar: @metum.valor_dolar, valor_guarani: @metum.valor_guarani, valor_real: @metum.valor_real }
    assert_redirected_to metum_path(assigns(:metum))
  end

  test "should destroy metum" do
    assert_difference('Metum.count', -1) do
      delete :destroy, id: @metum
    end

    assert_redirected_to meta_path
  end
end
