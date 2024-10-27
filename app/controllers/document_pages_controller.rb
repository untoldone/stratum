class DocumentPagesController < ApplicationController
  before_action :set_document_page, only: %i[ show edit update destroy ]

  # GET /document_pages or /document_pages.json
  def index
    @document_pages = DocumentPage.all
  end

  # GET /document_pages/1 or /document_pages/1.json
  def show
  end

  # GET /document_pages/new
  def new
    @document_page = DocumentPage.new
  end

  # GET /document_pages/1/edit
  def edit
  end

  # POST /document_pages or /document_pages.json
  def create
    @document_page = DocumentPage.new(document_page_params)

    respond_to do |format|
      if @document_page.save
        format.html { redirect_to @document_page, notice: "Document page was successfully created." }
        format.json { render :show, status: :created, location: @document_page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_pages/1 or /document_pages/1.json
  def update
    respond_to do |format|
      if @document_page.update(document_page_params)
        format.html { redirect_to @document_page, notice: "Document page was successfully updated." }
        format.json { render :show, status: :ok, location: @document_page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_pages/1 or /document_pages/1.json
  def destroy
    @document_page.destroy!

    respond_to do |format|
      format.html { redirect_to document_pages_path, status: :see_other, notice: "Document page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_page
      @document_page = DocumentPage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_page_params
      params.require(:document_page).permit(:index, :document_id)
    end
end
