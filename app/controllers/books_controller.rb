require 'pdf/reader'

class BooksController < ApplicationController
  def index
    # Your index action code here
    # FileModel.last&.destroy
  end

  def upload
    # Your file upload action code here
    pdf_text = ""
    # debugger

    # Open the PDF file for streaming processing
    PDF::Reader.open(params[:pdf_file].tempfile) do |reader|
      # Iterate over each page in the PDF
      reader.pages.each_with_index do |page, index|
        # Extract text from the current page and append it to the text string
        if index > 10
          next
        else
          pdf_text << page.text
        end
      end
    end

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
    FileModel.create!(name: @file)

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

  def download_audio
    # Specify the path to the audio file
    file_path = Rails.root.join('app', 'services', 'audio', 'audio.mp3')
  
    # Send the file as a response
    send_file(file_path, filename: 'audio.mp3', type: 'audio/mp3')
  end

  private

  def extract_text_from_pdf(pdf_file)
    # You'll need to implement PDF text extraction logic here
    # For simplicity, let's assume you're using a gem like pdf-reader
    reader = PDF::Reader.new(pdf_file)
    pdf_text = ''
    reader.pages.each do |page|
      pdf_text << page.text
    end
    debugger
    pdf_text
  end
end
