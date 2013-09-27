require 'rubygems'
require 'sinatra/base'
require 'logging'
require 'openssl'

class ApiBase < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :development do
    base_logger = Logging.logger(STDOUT)
  end

  before { content_type 'application/json', :charset => 'utf-8' }

  before {
  	if params[:harp_sig]
  		puts "Got harp_sig #{params[:harp_sig]}"
  	end
	  #puts "Got encoded " + Base64.encode64((HMAC::SHA256.new("Secret Passphrase") << 'Message').digest).strip
	  #puts "Got encoded " + Base64.encode64((HMAC::SHA256.new("Secret Passphrase") << 'Message').hexdigest).strip
	  DIGEST  = OpenSSL::Digest::Digest.new('sha256')
    puts "Got encoded2 " + Base64.encode64(OpenSSL::HMAC.digest(DIGEST, "Secret Passphrase", 'Message')).strip
  }

end
