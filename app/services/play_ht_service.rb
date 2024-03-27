# app/services/play_ht_service.rb

require 'net/http'
require 'json'

class PlayHtService
  def initialize
    @api_key = "43595e6b77e64b7196b7b7f93a7945ea"
    @user_id = "D638CoWW5FQzONxPqd8dvdCdUS62"
  end

  def convert_text_to_audio(text)
    url = URI("https://api.play.ht/api/v2/tts/stream")
  
    options = {
      method: "POST",
      headers: {
        "accept": "audio/mpeg",
        "content-type": "application/json",
        "AUTHORIZATION": @api_key,
        "X-USER-ID": @user_id
      },
      body: {
        voice_engine: 'PlayHT2.0-turbo',
        #"text[0..1000] new 2",
        text: text[0..1000],# " The Book of Enoch new.,     MSS., I was obliged to follow their authority in three hundred additional instances against Dillmann's text. However, as I could introduce only a limited number of these new readings into the Critical Notes already in type, the reader will not unfrequently have to consult Ap- pendix C for the text followed in the Translation in the earlier chapters. In addition to the new readings incor- porated in the Translation, a number of others are proposed in Appendices C, D, and E. These are preceded by the readings they are intended to displace, and are always printed in italics. I might add that the Gizeh fragment, which, through the kindness of the Delegates of the Press, is added on pp. 326-370, will be found to be free from the serious blemishes of M. Bouriant's edition.",#text[0..200],
        voice: "s3://voice-cloning-zero-shot/d9ff78ba-d016-47f6-b0ef-dd630f59414e/female-cs/manifest.json",
        output_format: "mp3",
        sample_rate: "44100",
        speed: 1
      }.to_json
    }
  
    # Create an HTTPS connection
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
  
    # Disable SSL certificate verification
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    # Make the request
    response = https.request_post(url, options[:body], options[:headers])
    handle_response(response)
  end
  

  private

  def handle_response(response)
    if response.code == "200"
      # Save the audio file
      audio_data = response.body
      # You can save the audio file or handle it as needed
      return audio_data
    else
      raise "Error: #{response.code} - #{response.message}"
    end
  end
end
