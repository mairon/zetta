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
      post :create, metum: { descricao: @metum.descricao, moeda: @metum.moeda, periodo_final: @metum.periodo_final, periodo_inicio: @metum.periodo_inicio, status: @metum.status, valor_max_gs: @metum.valor_max_gs, valor_max_rs: @metum.valor_max_rs, valor_max_us: @metum.valor_max_us, valor_min_gs: @metum.valor_min_gs, valor_min_rs: @metum.valor_min_rs, valor_min_us: @metum.valor_min_us }
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
    put :update, id: @metum, metum: { descricao: @metum.descricao, moeda: @metum.moeda, periodo_final: @metum.periodo_final, periodo_inicio: @metum.periodo_inicio, status: @metum.status, valor_max_gs: @metum.valor_max_gs, valor_max_rs: @metum.valor_max_rs, valor_max_us: @metum.valor_max_us, valor_min_gs: @metum.valor_min_gs, valor_min_rs: @metum.valor_min_rs, valor_min_us: @metum.valor_min_us }
    assert_redirected_to metum_path(assigns(:metum))
  end

  test "should destroy metum" do
    assert_difference('Metum.count', -1) do
      delete :destroy, id: @metum
    end

    assert_redirected_to meta_path
  end
end
