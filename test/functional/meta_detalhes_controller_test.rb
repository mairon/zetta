require 'test_helper'

class MetaDetalhesControllerTest < ActionController::TestCase
  setup do
    @meta_detalhe = meta_detalhes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meta_detalhes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meta_detalhe" do
    assert_difference('MetaDetalhe.count') do
      post :create, meta_detalhe: { comicao_max: @meta_detalhe.comicao_max, comicao_min: @meta_detalhe.comicao_min, descricao: @meta_detalhe.descricao, meta_id: @meta_detalhe.meta_id, persona_id: @meta_detalhe.persona_id, persona_nome: @meta_detalhe.persona_nome, setor_id: @meta_detalhe.setor_id, setor_nome: @meta_detalhe.setor_nome, valor_max_gs: @meta_detalhe.valor_max_gs, valor_max_rs: @meta_detalhe.valor_max_rs, valor_max_us: @meta_detalhe.valor_max_us, valor_min_gs: @meta_detalhe.valor_min_gs, valor_min_rs: @meta_detalhe.valor_min_rs, valor_min_us: @meta_detalhe.valor_min_us }
    end

    assert_redirected_to meta_detalhe_path(assigns(:meta_detalhe))
  end

  test "should show meta_detalhe" do
    get :show, id: @meta_detalhe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meta_detalhe
    assert_response :success
  end

  test "should update meta_detalhe" do
    put :update, id: @meta_detalhe, meta_detalhe: { comicao_max: @meta_detalhe.comicao_max, comicao_min: @meta_detalhe.comicao_min, descricao: @meta_detalhe.descricao, meta_id: @meta_detalhe.meta_id, persona_id: @meta_detalhe.persona_id, persona_nome: @meta_detalhe.persona_nome, setor_id: @meta_detalhe.setor_id, setor_nome: @meta_detalhe.setor_nome, valor_max_gs: @meta_detalhe.valor_max_gs, valor_max_rs: @meta_detalhe.valor_max_rs, valor_max_us: @meta_detalhe.valor_max_us, valor_min_gs: @meta_detalhe.valor_min_gs, valor_min_rs: @meta_detalhe.valor_min_rs, valor_min_us: @meta_detalhe.valor_min_us }
    assert_redirected_to meta_detalhe_path(assigns(:meta_detalhe))
  end

  test "should destroy meta_detalhe" do
    assert_difference('MetaDetalhe.count', -1) do
      delete :destroy, id: @meta_detalhe
    end

    assert_redirected_to meta_detalhes_path
  end
end
