class MetodosController < ApplicationController
  # GET /metodos
  # GET /metodos.json
  def index
    @metodos = Metodo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @metodos }
    end
  end

  # GET /metodos/1
  # GET /metodos/1.json
  def show
    @metodo = Metodo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @metodo }
    end
  end

  # GET /metodos/new
  # GET /metodos/new.json
  def new
    @metodo = Metodo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @metodo }
    end
  end

  # GET /metodos/1/edit
  def edit
    @metodo = Metodo.find(params[:id])
  end

  # POST /metodos
  # POST /metodos.json
  def create
    @metodo = Metodo.new(params[:metodo])

    respond_to do |format|
      if @metodo.save
        format.html { redirect_to metodos_url }
        format.json { render json: @metodo, status: :created, location: @metodo }
      else
        format.html { render action: "new" }
        format.json { render json: @metodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /metodos/1
  # PUT /metodos/1.json
  def update
    @metodo = Metodo.find(params[:id])

    respond_to do |format|
      if @metodo.update_attributes(params[:metodo])
        format.html { redirect_to metodos_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @metodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metodos/1
  # DELETE /metodos/1.json
  def destroy
    @metodo = Metodo.find(params[:id])
    @metodo.destroy

    respond_to do |format|
      format.html { redirect_to metodos_url }
      format.json { head :no_content }
    end
  end
end
