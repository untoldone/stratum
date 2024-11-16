class DeviceApiController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_device!
  skip_before_action :verify_authenticity_token

  # POST /api/v1/documents or /api/v1/documents.json
  # e.g. curl -H "Accept: application/json" -H "Authorization: Bearer xxxxxxxxxxxxxx" -F 'document[file]=@/path/to/file1.txt' -XPOST http://localhost:3000/api/v1/documents
  # Device token can be found at http://localhost:3000/devices
  def create_document
    @document = Document.new(document_params.merge(account: current_account))

    respond_to do |format|
      if @document.save
        format.json { render json: { status: "ok" }, status: :created, location: @document }
      else
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end

  def authenticate_device!
    token = request.headers['Authorization']&.split(' ')&.last

    if token.present?
      current_device_token = DeviceToken.includes(:device).find_by(token: token)
      @current_device = current_device_token.device
    end

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_device
  end

  def current_device
    @current_device
  end

  def current_account
    # TODO: Support multiple accounts
    current_device.account
  end
end
