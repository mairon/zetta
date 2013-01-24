require 'test_helper'

class MetasControllerTest < ActionController::TestCase
  setup do
    @meta = metas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meta" do
    assert_difference('Meta.count') do
      post :create, meta: { descricao: @meta.descricao, moeda: @meta.moeda, periodo_final: @meta.periodo_final, periodo_inicio: @meta.periodo_inicio, status: @meta.status, valor_max_gs: @meta.valor_max_gs, valor_max_rs: @meta.valor_max_rs, valor_max_us: @meta.valor_max_us, valor_min_gs: @meta.valor_min_gs, valor_min_rs: @meta.valor_min_rs, valor_min_us: @meta.valor_min_us }
    end

    assert_redirected_to meta_path(assigns(:meta))
  end

  test "should show meta" do
    get :show, id: @meta
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meta
    assert_response :success
  end

  test "should update meta" do
    put :update, id: @meta, meta: { descricao: @meta.descricao, moeda: @meta.moeda, periodo_final: @meta.periodo_final, periodo_inicio: @meta.periodo_inicio, status: @meta.status, valor_max_gs: @meta.valor_max_gs, valor_max_rs: @meta.valor_max_rs, valor_max_us: @meta.valor_max_us, valor_min_gs: @meta.valor_min_gs, valor_min_rs: @meta.valor_min_rs, valor_min_us: @meta.valor_min_us }
    assert_redirected_to meta_path(assigns(:meta))
  end

  test "should destroy meta" do
    assert_difference('Meta.count', -1) do
      delete :destroy, id: @meta
    end

    assert_redirected_to metas_path
  end
end
