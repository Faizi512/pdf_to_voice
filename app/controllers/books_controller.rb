require 'pdf/reader'

require 'rtesseract'
require 'pdf-reader'
require 'pdftoimage'

require 'mini_magick'

class BooksController < ApplicationController
  def index
  end

  def upload
    pdf_text = extract_text_from_pdf(params[:pdf_file].tempfile)
    puts "I'm here"
    # Convert text to audio using play.ht service object
    play_ht_service = PlayHtService.new
    @audio_data = play_ht_service.convert_text_to_audio(pdf_text)
    # Save the audio data to a temporary file
    directory = "app/services/audio"

    # Create a new temporary file with the specified directory and file extension
    tmp_file = Tempfile.new(['audio', '.mp3'], directory)
    tmp_file.binmode
    tmp_file.write @audio_data
    tmp_file.rewind
    @file =  tmp_file.path
    # tmp_file.close
    # tmp_file.unlink
    # FileModel.create!(name: @file)

    file_name = 'audio.mp3'

    # Construct the full file path
    file_path = File.join(directory, file_name)

    # Write audio data to the file
    File.open(file_path, 'wb') do |file|
      file.write(@audio_data)
    end
    # debugger
    # js_code = "localStorage.setItem('savedText', #{@file.to_json});"
    
    # respond_to do |format|
    #   format.js { render js: js_code }
    # end
    render :index
    # tmp_file
    # @audio_data = "Test"
    # respond_to do |format|
    #   format.js { render json: @audio_data }
    # end
    # Send the file as a downloadable response
    # send_file tmp_file, filename: 'converted_audio.mp3', type: 'audio/mpeg'

    # Close and delete the temporary file
    # tmp_file.close
    # tmp_file.unlink
  end

  def upload_to_api
    debugger
    text_ser = PdfToTextService.new
    text = text_ser.convert_pdf_to_text(params[:pdf_file].tempfile)
    debugger
    puts text
    # render :index
  end

  def download_audio
    # Specify the path to the audio file
    file_path = Rails.root.join('app', 'services', 'audio', 'audio.mp3')
  
    # Send the file as a response
    send_file(file_path, filename: 'audio.mp3', type: 'audio/mp3')
  end

  def audio
    send_file Rails.root.join('app', 'services', 'audio', 'audio.mp3'), type: 'audio/mp3', disposition: 'inline'
  end

  def player_partial
    # Render the _player.html.erb partial
    render partial: 'player', layout: false
  end

  private
  
  def extract_text_from_pdf(pdf_file)
    pdf_text = ""
    # debugger

    # Open the PDF file for streaming processing
    # PDF::Reader.open(pdf_file) do |reader|
    #   # Iterate over each page in the PDF
    #   reader.pages.each_with_index do |page, index|
    #     puts "=================#{pdf_text.size}"
    #     # Extract text from the current page and append it to the text string
    #     if index > 10
    #       break
    #     end
    #     puts index
    #     #   next
    #     # else
    #     pdf_text << page.text
    #     # end
    #   end
    # end
    images = PDFToImage.open(pdf_file.path)
    images.each_with_index do |image, index|
      if index <= 5
      
        image.resize('100%').save("app/services/images/page-#{(index+1)}.png")
        page_text = RTesseract.new("app/services/images/page-#{index+1}.png").to_s
        pdf_text += page_text
        puts page_text
        puts pdf_text.size
        File.delete("app/services/images/page-#{index+1}.png")
      else
        puts index
        next
      end
    end
    # image = Rails.root.join('app', 'services', 'images', "image.png")
    # page_text = RTesseract.new(image.to_s).to_s
    # pdf_text = page_text
    pdf_text
  end
end
