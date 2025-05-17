require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
end
test "should extract text from audio file" do
  audio_file = fixture_file_upload(Rails.root.join('test/fixtures/files/sample_audio.mp3'), 'audio/mpeg')

  AudioToTextService.any_instance.stubs(:convert_audio_to_text).returns("Extracted text from audio.")

  post api_v1_extract_text_from_audio_url, params: { audio_file: audio_file }

  assert_response :success
  json_response = JSON.parse(response.body)
  assert_equal "Extracted text from audio.", json_response["text"]
  assert_equal "Text extracted successfully.", json_response["message"]
end

test "should return error if audio file is missing" do
  post api_v1_extract_text_from_audio_url

  assert_response :unprocessable_entity
  json_response = JSON.parse(response.body)
  assert_equal "Audio file is required.", json_response["error"]
end

test "should return error if text extraction fails" do
  audio_file = fixture_file_upload(Rails.root.join('test/fixtures/files/sample_audio.mp3'), 'audio/mpeg')

  AudioToTextService.any_instance.stubs(:convert_audio_to_text).returns(nil)

  post api_v1_extract_text_from_audio_url, params: { audio_file: audio_file }

  assert_response :unprocessable_entity
  json_response = JSON.parse(response.body)
  assert_equal "Failed to extract text from audio.", json_response["error"]
end