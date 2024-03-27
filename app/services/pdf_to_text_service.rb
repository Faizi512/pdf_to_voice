# # app/services/pdf_to_text_service.rb
# require 'uri'
# require 'net/http'

# class PdfToTextService
#   API_URL = 'https://pdf-to-text-converter.p.rapidapi.com/api/pdf-to-text/convert'.freeze

#   def initialize()
#     @api_key = "ed42a01007msh3d9aa0afad8c09ap16d923jsnacfae1e5efd1"
#   end

#   def convert_pdf_to_text(pdf_file)
#     debugger
#     url = URI(API_URL)
#     http = Net::HTTP.new(url.host, url.port)
#     http.use_ssl = true
#     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#     request = Net::HTTP::Post.new(url)
#     request["X-RapidAPI-Key"] = @api_key
#     request["X-RapidAPI-Host"] = 'pdf-to-text-converter.p.rapidapi.com'
#     request.set_form [['file', pdf_file], ['page', '1']], 'multipart/form-data'

#     response = http.request(request)
#     response.body
#     debugger
#   end
# end



require 'uri'
require 'net/http'
require 'json'

class PdfToTextService
  API_URL = 'https://api.pdfrest.com/extracted-text'.freeze

  def initialize()
    @api_key = "24d4d1a6-98e1-423c-874e-1c993463666b"
  end

  def convert_pdf_to_text(file_path)
    # debugger
    url = URI(API_URL)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Api-Key"] = @api_key

    form_data = {
      file: File.new(file_path)
    }

    request.set_form(form_data, 'multipart/form-data')

    response = http.request(request)
    json_response = JSON.parse(response.body)

    if response.code == '200'
      json_response['text']
    else
      raise "Error converting PDF to text: #{json_response['error']}"
    end
  end
end
