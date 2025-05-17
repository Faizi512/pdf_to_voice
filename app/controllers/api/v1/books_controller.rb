module Api
  module V1
    class BooksController < ApplicationController
      skip_before_action :verify_authenticity_token

      def upload_pdf
        if params[:pdf_file].present?
          pdf_text = extract_text_from_pdf(params[:pdf_file].tempfile)

          # Save the extracted text and audio data
          book = FileModel.create!(name: params[:pdf_file].original_filename)
          play_ht_service = PlayHtService.new
          audio_data = play_ht_service.convert_text_to_audio(pdf_text)

          # Save audio file
          audio_path = Rails.root.join('storage', "audio_#{book.id}.mp3")
          File.open(audio_path, 'wb') { |file| file.write(audio_data) }

          render json: { id: book.id, message: 'PDF uploaded and processed successfully.' }, status: :ok
        else
          render json: { error: 'PDF file is required.' }, status: :unprocessable_entity
        end
      end

      def retrieve_text
        book = FileModel.find_by(id: params[:id])
        if book
          render json: { id: book.id, name: book.name, text: 'Text extraction is not stored in this implementation.' }, status: :ok
        else
          render json: { error: 'Book not found.' }, status: :not_found
        end
      end

      def download_audio
        book = FileModel.find_by(id: params[:id])
        if book
          audio_path = Rails.root.join('storage', "audio_#{book.id}.mp3")
          if File.exist?(audio_path)
            send_file audio_path, filename: "audio_#{book.id}.mp3", type: 'audio/mp3'
          else
            render json: { error: 'Audio file not found.' }, status: :not_found
          end
        else
          render json: { error: 'Book not found.' }, status: :not_found
        end
      end

      def extract_text_from_audio
        if params[:audio_file].present?
          audio_file = params[:audio_file].tempfile.path
          speech_to_text_service = AudioToTextService.new
          extracted_text = speech_to_text_service.convert_audio_to_text(audio_file)

          if extracted_text.present?
            render json: { text: extracted_text, message: 'Text extracted successfully.' }, status: :ok
          else
            render json: { error: 'Failed to extract text from audio.' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Audio file is required.' }, status: :unprocessable_entity
        end
      end

      private

      def extract_text_from_pdf(pdf_file)
        pdf_text = ""
        images = PDFToImage.open(pdf_file.path)
        images.each_with_index do |image, index|
          break if index > 5 # Limit to first 5 pages
          image.resize('100%').save("tmp/page-#{index + 1}.png")
          page_text = RTesseract.new("tmp/page-#{index + 1}.png").to_s
          pdf_text += page_text
          File.delete("tmp/page-#{index + 1}.png")
        end
        pdf_text
      end
    end
  end
end