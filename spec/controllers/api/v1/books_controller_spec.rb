require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'POST #upload_pdf' do
    let(:pdf_file) { fixture_file_upload(Rails.root.join('spec/fixtures/sample.pdf'), 'application/pdf') }

    context 'when a valid PDF file is uploaded' do
      it 'returns a successful response and processes the file' do
        allow_any_instance_of(PlayHtService).to receive(:convert_text_to_audio).and_return('audio_data')
        post :upload_pdf, params: { pdf_file: pdf_file }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('PDF uploaded and processed successfully.')
        expect(json_response['id']).to be_present
      end
    end

    context 'when no PDF file is uploaded' do
      it 'returns an error response' do
        post :upload_pdf

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('PDF file is required.')
      end
    end
  end

  describe 'GET #retrieve_text' do
    let(:book) { FileModel.create!(name: 'Sample PDF') }

    context 'when the book exists' do
      it 'returns the book details' do
        get :retrieve_text, params: { id: book.id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(book.id)
        expect(json_response['name']).to eq(book.name)
        expect(json_response['text']).to eq('Text extraction is not stored in this implementation.')
      end
    end

    context 'when the book does not exist' do
      it 'returns an error response' do
        get :retrieve_text, params: { id: 999 }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Book not found.')
      end
    end
  end

  describe 'GET #download_audio' do
    let(:book) { FileModel.create!(name: 'Sample PDF') }
    let(:audio_path) { Rails.root.join('storage', "audio_#{book.id}.mp3") }

    before do
      File.open(audio_path, 'wb') { |file| file.write('audio_data') }
    end

    after do
      File.delete(audio_path) if File.exist?(audio_path)
    end

    context 'when the audio file exists' do
      it 'sends the audio file' do
        get :download_audio, params: { id: book.id }

        expect(response).to have_http_status(:ok)
        expect(response.header['Content-Type']).to eq('audio/mp3')
      end
    end

    context 'when the audio file does not exist' do
      it 'returns an error response' do
        File.delete(audio_path) if File.exist?(audio_path)
        get :download_audio, params: { id: book.id }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Audio file not found.')
      end
    end

    context 'when the book does not exist' do
      it 'returns an error response' do
        get :download_audio, params: { id: 999 }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Book not found.')
      end
    end
  end

  describe 'POST #extract_text_from_audio' do
    let(:audio_file) { fixture_file_upload(Rails.root.join('spec/fixtures/sample_audio.mp3'), 'audio/mpeg') }

    context 'when a valid audio file is uploaded' do
      it 'returns the extracted text' do
        allow_any_instance_of(AudioToTextService).to receive(:convert_audio_to_text).and_return('Extracted text from audio.')

        post :extract_text_from_audio, params: { audio_file: audio_file }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['text']).to eq('Extracted text from audio.')
        expect(json_response['message']).to eq('Text extracted successfully.')
      end
    end

    context 'when no audio file is uploaded' do
      it 'returns an error response' do
        post :extract_text_from_audio

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Audio file is required.')
      end
    end

    context 'when text extraction fails' do
      it 'returns an error response' do
        allow_any_instance_of(AudioToTextService).to receive(:convert_audio_to_text).and_return(nil)

        post :extract_text_from_audio, params: { audio_file: audio_file }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Failed to extract text from audio.')
      end
    end
  end
end