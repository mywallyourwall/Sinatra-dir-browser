require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'coffee-script'

class MyServer < Sinatra::Base

    Thread.main[:scss_watcher] = Thread.new do  
      %x[scss --watch public_folder/]  
    end 

    Thread.main[:coffee_watcher] = Thread.new do  
      %x[coffee --watch --compile public_folder/]  
    end 

	root = File.dirname(__FILE__)

	set :static, true
	set :public_folder, '/'
	set :public, root + '/'
	set :haml, :format => :html5
	#set :dump_errors, false

	get '/styles.css' do
	  scss :styles
	end

	get '/scripts.js' do
	  coffee :scripts
	end

	get '/*?' do
		

		files = Array.new

		Dir.foreach(root + request.path_info) do |item|
			slash = '/'
			url = request.path
			fileext = File.extname(item)
			ajaxurl = ''
			isdir = File.directory?(item)
			
			if item.include? ' ' then
				item = item.gsub(' ', '\ ')
			end

			next if item == '.'
			next if item == '..' and url == slash
			next if item == '..' and request.xhr? == true

			if url[url.length-1] == slash then
				url[url.length-1,1] = ''
			end	

			if url == slash then
				slash = ''
			end	

			path = url  + slash + item 

			if isdir === true and item != '..' then
				ajaxurl = path
			end	

			if /jpg|gif|png|bmp/i.match(fileext) then
				files.push('<a href="' + path + '"><img src="' + path + '" alt="' + item + '"></a>')
			else
				files.push('<a href="' + path + '" data-preview="'+ajaxurl+'">' + item + '</a>')
			end	

		end

       	@filelist = files
		@title = root
		scss :styles
		if request.xhr? == true then
			haml :snippet
		else
			haml :index
		end	
		
		
	end




end