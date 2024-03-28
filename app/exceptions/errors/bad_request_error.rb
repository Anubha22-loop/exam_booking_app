class Errors::BadRequestError < StandardError
  def initialize(message = 'Request Failed')
    super(message)
  end
end
