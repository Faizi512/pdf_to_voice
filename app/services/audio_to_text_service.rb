require 'google/cloud/speech'

class AudioToTextService
  def initialize
    @speech_client = Google::Cloud::Speech.speech
  end

  def convert_audio_to_text(audio_file_path)
    audio = { uri: audio_file_path }
    config = {
      encoding: :MP3,
      sample_rate_hertz: 44100,
      language_code: 'en-US'
    }

    response = @speech_client.recognize(config: config, audio: audio)
    response.results.map(&:alternatives).flatten.map(&:transcript).join(' ')
  rescue StandardError => e
    Rails.logger.error("Speech-to-Text Error: #{e.message}")
    nil
  end
end