require 'jsonapi_parser'
require 'rails/version'

require 'jsonapi_parser/rails/to_active_record_hash'

module JsonApiParser
  module_function

  def document_to_active_record_hash(document, options = {})
    Rails.to_active_record_hash(document, options)
  end
end
