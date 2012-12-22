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
		puts
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
			 modifiedData = @data.gsub("\n", "")
			 return " -d '#{modifiedData.gsub(/  +/, " ")}'"
		end
		return ""
	end

	def method
		return " -X #{@method}"
	end	

	def url
		return " \"#{@url}\""
	end

end

def help
	puts 'Invalid argument'
	puts 'Usage:'
	puts '$ ruby PostManRequest.rb fileToParse'
	puts
end

def main
	if ARGV.length != 1
		help
		exit 1
	end

	file = File.open(ARGV[0], "r")
	contents = file.read
	parsedContent = JSON.parse contents

	postManRequest = []
	
	parsedContent["requests"].each { |request| postManRequest.push(PostManRequest.new(request)) }

	postManRequest.each {|request| request.to_curl }	
end

main
