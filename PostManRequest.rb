require 'rubygems'
require 'json'

class PostManRequest
	attr_accessor :name, :url, :method, :headers, :data, :data_mode
            
	def initialize(request)
		@name = request['name']
		@url = request['url']
		@method = request['method']
		@headers = request['headers']
		@data = request['data']
		@data_mode = request['dataMode']
	end

	def to_curl
		puts "# #{@name}"
		puts "curl" << headers << method << data << url
	end        

	def headers
		curlHeaders = ""
		if !@headers.empty?
			requestHeaders = @headers.split("\n")
			requestHeaders.each {|requestHeader| curlHeaders << " -H #{requestHeader.sub(" ", "")}"}		
		end
		return "#{curlHeaders}"	
	end

	def data
		if !@data.empty?
			return " #{@data.gsub("\n", "")}"
		end
		return ""
	end

	def method
		return " -X #{@method}"
	end	

	def url
		return " #{@url}"
	end

end

def main
	file = File.open("<FILE_TO_READ>", "r")
	contents = file.read
	parsedContent = JSON.parse contents

	postManRequest = []
	
	parsedContent["requests"].each { |request| postManRequest.push(PostManRequest.new(request)) }

	postManRequest.each {|request| request.to_curl }	
end

main