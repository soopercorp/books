require 'rubygems'
require 'oauth'
require 'hpricot'

GR_DIR = "#{ENV['HOME']}/.gr"
AUTH_FILE = GR_DIR+"/auth"
OAUTH_FILE = GR_DIR+"/oauth"
USER_FILE = GR_DIR+"/user"

GOODREADS_URL = 'http://www.goodreads.com'

def load_auth()
	if !File.exist?(AUTH_FILE)
		puts "Looks like you need to setup your Goodreads credentials. "
		puts "Enter your Goodreads Key:"
		gr_key = gets
		puts "Enter your Goodreads Secret"
		gr_secret = gets
		config_file = File.new(AUTH_FILE, "w")
		config_file.puts(gr_key)
		config_file.puts(gr_secret)
		config_file.close()
		return [gr_key.strip!,gr_secret.strip!]
	else
		return File.read(AUTH_FILE).split("\n")
	end
end

def load_oauth_token(consumer)
	if !File.exist?(OAUTH_FILE)
		request_token = consumer.get_request_token
		puts "Please visit this URL and authorize yourself. After that, come back and press Enter(return)"
		puts request_token.authorize_url

		gets

		access_token = request_token.get_access_token
		puts access_token.inspect
		
		File.open(OAUTH_FILE,'w') do |file|
			Marshal.dump(access_token, file)
		end

		return access_token
	else
		return File.open(OAUTH_FILE) do |file|
			Marshal.load(file)
		end
	end
end

def load_user(doc)
	if !File.exist?(USER_FILE)
		user_file = File.new(USER_FILE, "w")
		id, name = [doc.at(:user).attributes['id'],doc.at(:name).inner_html]
		user_file.puts(id)
		user_file.puts(name)
		user_file.close()
		return [id,name]
	else
		return File.read(USER_FILE).split("\n")
	end
end

Dir::mkdir(GR_DIR) if !File.directory?(GR_DIR)

gr_key,gr_secret = load_auth

consumer = OAuth::Consumer.new(gr_key, 
                               gr_secret, 
                               :site => GOODREADS_URL )

access_token = load_oauth_token(consumer)

response = access_token.get('/api/auth_user')

doc = Hpricot.XML(response.body)

id, name = load_user(doc)
puts id,name