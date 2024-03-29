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

require 'rtesseract'
require 'pdf-reader'
require 'pdftoimage'

require 'mini_magick'

# require 'RMagick'

class PdfToTextService
  API_URL = 'https://api.pdfrest.com/extracted-text'.freeze
  

  def initialize()
    @api_key = "24d4d1a6-98e1-423c-874e-1c993463666b"#"4066e183-1786-4811-b9f0-0ef5c98ce31f"#"24d4d1a6-98e1-423c-874e-1c993463666b"
  end

  # def convert_pdf_to_text(file_path)
  #   debugger
  #   url = URI(API_URL)
  #   http = Net::HTTP.new(url.host, url.port)
  #   http.use_ssl = true
  #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #   request = Net::HTTP::Post.new(url)
  #   request["Api-Key"] = @api_key

  #   file_data = File.read(file_path)

  #   form_data = {
  #     'file' => file_data
  #   }

  #   request.set_form(form_data, 'multipart/form-data')

  #   response = http.request(request)
  #   debugger
  #   debugger
  #   json_response = JSON.parse(response.body)
  #   debugger
  #   if response.code == '200'
  #     json_response['text']
  #   else
  #     raise "Error converting PDF to text: #{json_response['error']}"
  #   end
  # end


  def convert_pdf_to_text(pdf_path)
    text = ''
    debugger
    # RTesseract.new(image_path.to_s).to_s

    File.open(pdf_path, 'rb') do |file|
      RTesseract.new(file).to_s
    end
    # pdf_path = "app/services/images"

    # Create a new temporary file with the specified directory and file extension
    # tmp_file = Tempfile.new(['temp_file', '.png'], pdf_path)

    # Create an ImageList object from the PDF
    # pdf = Magick::ImageList.new()
    # pdf = Rails.root.join('app', 'services', 'pdf','TheBookofEnoch_10152066.pdf')
    # Magick::ImageList.new(pdf)
    # im=MiniMagick::Image.open(pdf)
    # im.format("png", 0)
    # im.write("some_thumbnail.png")

    # Iterate over each page in the PDF and save it as an image
    # pdf.each_with_index do |page, index|
      # Save the page as an image, e.g., as a PNG file
      # page.write("output_image_#{index}.png")
    # end
    # images = Magick::ImageList.new(pdf_path)
    
    # images = PDFToImage.open("/home/ads-user-12/Documents/TheBookofEnoch_10152066.pdf")
    # debugger
    # images.each_with_index do |img, index|
    #   debugger
    #   pdf_page_image = img
    #   # Create a Tempfile for the PNG image
    #   png_image_tempfile = Tempfile.new(['pdf_page', '.png'])

    #   # Convert the PDF page image to a PNG image using MiniMagick
    #   MiniMagick::Tool::Convert.new do |convert|
    #     convert << pdf_page_image.pdf_name + (index + 1).to_s # Select the first page
    #     convert << png_image_tempfile.path
    #   end

    #   # Close the PDF page image
    #   # pdf_page_image.close

    #   page_text = RTesseract.new(pdf_page_image).to_s
    #   text << page_text
      # debugger
      # page_text = RTesseract.new(img.path).to_s
      # debugger
      # text << page_text
    # end
    # reader.pages.each do |page|
    #   # Convert PDF page to image
    #   image_name = "image_#{page.number}.png"
    #   image_path = Rails.root.join('app', 'services', 'images', image_name)
    #   system("convert -density 300 #{pdf_path}[#{page.number - 1}] #{image_path}")  # Using ImageMagick's convert command
    #   # Perform OCR on the image
    #   page_text = RTesseract.new(image_path.to_s).to_s
  
    #   # Append extracted text to result
    #   debugger
    #   text << page_text
    # end
    text
  end
end
