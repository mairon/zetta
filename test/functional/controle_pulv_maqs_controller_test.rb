require 'test_helper'

class ControlePulvMaqsControllerTest < ActionController::TestCase
  setup do
    @controle_pulv_maq = controle_pulv_maqs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:controle_pulv_maqs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create controle_pulv_maq" do
    assert_difference('ControlePulvMaq.count') do
      post :create, controle_pulv_maq: { autonomia_01: @controle_pulv_maq.autonomia_01, autonomia_02: @controle_pulv_maq.autonomia_02, bico_01: @controle_pulv_maq.bico_01, bico_02: @controle_pulv_maq.bico_02, calibracao: @controle_pulv_maq.calibracao, condicao_maq: @controle_pulv_maq.condicao_maq, controle_pulv_id: @controle_pulv_maq.controle_pulv_id, data: @controle_pulv_maq.data, etiqueta: @controle_pulv_maq.etiqueta, hora_maq: @controle_pulv_maq.hora_maq, modelo: @controle_pulv_maq.modelo, regular: @controle_pulv_maq.regular, vazao_01: @controle_pulv_maq.vazao_01, vazao_02: @controle_pulv_maq.vazao_02, velocidade_01: @controle_pulv_maq.velocidade_01, velocidade_02: @controle_pulv_maq.velocidade_02 }
    end

    assert_redirected_to controle_pulv_maq_path(assigns(:controle_pulv_maq))
  end

  test "should show controle_pulv_maq" do
    get :show, id: @controle_pulv_maq
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @controle_pulv_maq
    assert_response :success
  end

  test "should update controle_pulv_maq" do
    put :update, id: @controle_pulv_maq, controle_pulv_maq: { autonomia_01: @controle_pulv_maq.autonomia_01, autonomia_02: @controle_pulv_maq.autonomia_02, bico_01: @controle_pulv_maq.bico_01, bico_02: @controle_pulv_maq.bico_02, calibracao: @controle_pulv_maq.calibracao, condicao_maq: @controle_pulv_maq.condicao_maq, controle_pulv_id: @controle_pulv_maq.controle_pulv_id, data: @controle_pulv_maq.data, etiqueta: @controle_pulv_maq.etiqueta, hora_maq: @controle_pulv_maq.hora_maq, modelo: @controle_pulv_maq.modelo, regular: @controle_pulv_maq.regular, vazao_01: @controle_pulv_maq.vazao_01, vazao_02: @controle_pulv_maq.vazao_02, velocidade_01: @controle_pulv_maq.velocidade_01, velocidade_02: @controle_pulv_maq.velocidade_02 }
    assert_redirected_to controle_pulv_maq_path(assigns(:controle_pulv_maq))
  end

  test "should destroy controle_pulv_maq" do
    assert_difference('ControlePulvMaq.count', -1) do
      delete :destroy, id: @controle_pulv_maq
    end

    assert_redirected_to controle_pulv_maqs_path
  end
end
