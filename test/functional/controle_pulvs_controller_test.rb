require 'test_helper'

class ControlePulvsControllerTest < ActionController::TestCase
  setup do
    @controle_pulv = controle_pulvs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:controle_pulvs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create controle_pulv" do
    assert_difference('ControlePulv.count') do
      post :create, controle_pulv: { area: @controle_pulv.area, data: @controle_pulv.data, direcao: @controle_pulv.direcao, persona_id: @controle_pulv.persona_id, persona_name: @controle_pulv.persona_name }
    end

    assert_redirected_to controle_pulv_path(assigns(:controle_pulv))
  end

  test "should show controle_pulv" do
    get :show, id: @controle_pulv
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @controle_pulv
    assert_response :success
  end

  test "should update controle_pulv" do
    put :update, id: @controle_pulv, controle_pulv: { area: @controle_pulv.area, data: @controle_pulv.data, direcao: @controle_pulv.direcao, persona_id: @controle_pulv.persona_id, persona_name: @controle_pulv.persona_name }
    assert_redirected_to controle_pulv_path(assigns(:controle_pulv))
  end

  test "should destroy controle_pulv" do
    assert_difference('ControlePulv.count', -1) do
      delete :destroy, id: @controle_pulv
    end

    assert_redirected_to controle_pulvs_path
  end
end
