require 'rubygems'
require 'sinatra/base'
require 'logging'
require 'openssl'
require 'base64'

class ApiBase < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :development do
    base_logger = Logging.logger(STDOUT)
  end

  # Signs a string using the credentials stored in memory.
  # @param [String] secret Usually an AWS secret access key.
  # @param [String] string_to_sign The string to sign.
  # @param [String] digest_method The digest method to use when
  #   computing the HMAC digest.
  # @return [String] Returns the computed signature.
  def sign secret, string_to_sign, digest_method = 'sha256'
    Base64.encode64(hmac(secret, string_to_sign, digest_method)).strip
  end
  #module_function :sign

  # Computes an HMAC digest of the passed string.
  # @param [String] key
  # @param [String] value
  # @param [String] digest ('sha256')
  # @return [String]
  def hmac key, value, digest = 'sha256'
    OpenSSL::HMAC.digest(OpenSSL::Digest.new(digest), key, value)
  end
  #module_function :hmac
  
  before { content_type 'application/json', :charset => 'utf-8' }

  before {
    if params[:harp_sig]
      harp_sig = params[:harp_sig]
      datetime = params[:datetime]
      script = request.body.read

      cnf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/settings.yaml'))
      access = cnf['default_creds']['access']
      secret = cnf['default_creds']['secret']
      
      string_to_sign = "HARP-HMAC-SHA256\n" +datetime+"\nPOST\n"+script
      signature = sign(secret, string_to_sign) 
      puts "signature #{signature}"
      
      if harp_sig != signature
        raise "INVALID_MESSAGE_SIGNATURE"
      end
    else
      raise "MESSAGE_SIGNATURE_NOT_FUND"
    end
    
    #Base64.encode64(hmac(secret, string_to_sign, digest_method)).strip
	  #puts "Got encoded " + Base64.encode64((HMAC::SHA256.new("Secret Passphrase") << 'Message').digest).strip
	  #puts "Got encoded " + Base64.encode64((HMAC::SHA256.new("Secret Passphrase") << 'Message').hexdigest).strip
	  #digest = OpenSSL::Digest::Digest.new('sha256')
    #puts "Got encoded2 " + Base64.encode64(OpenSSL::HMAC.digest(digest, "Secret Passphrase", 'Message')).strip
  }
end
