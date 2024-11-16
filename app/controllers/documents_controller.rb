class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy download ]

  # GET /documents or /documents.json
  def index
    @documents = policy_scope(Document)
  end

  # GET /documents/1 or /documents/1.json
  def show
    authorize @document
  end

  # GET /documents/1/download
  def download
    send_data @document.best_file_available.download,
              filename: @document.download_filename,
              type: @document.best_file_available.content_type,
              disposition: 'attachment'
  end

  # GET /documents/new
  def new
    authorize Document
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  def create
    authorize Document
    @document = Document.new(document_params.merge(account: current_account))

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_path, status: :see_other, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = authorize Document.find(params[:id])
      if params[:page] && @document.pages.count >= params[:page].to_i
        @page = params[:page].to_i
      else
        @page = 1
      end
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:file)
    end
end
