require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-more'
require 'fileutils'
require 'invite'

use Rack::Session::Cookie
 
helpers do
  def flash
    @_flash ||= {}
  end
  
  def redirect(uri, *args)
    session[:_flash] = flash unless flash.empty?
    status 302
    response['Location'] = uri
    halt(*args)
  end
end
 
before do
  @_flash, session[:_flash] = session[:_flash], nil if session[:_flash]
end

get '/' do
  haml :index, :format => :html5
end

post '/' do
  @interview = Invite.new(
    :email => params[:email],
    :created_at => Time.now 
  )
  
  if @interview.save
    flash[:notice] = "Invite added successfully. Well done! &#xF8FF;"
  else
    flash[:error] = @interview.errors.values.join(', ')
  end
  
  redirect '/'
end

# SASS stylesheet
get '/stylesheets/invites.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :invites
end