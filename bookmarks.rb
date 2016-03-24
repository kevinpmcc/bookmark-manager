ENV["RACK_ENV"] ||= "development"
require_relative 'models/link'
require 'sinatra/base'
require_relative 'data_mapper_setup'
require_relative 'models/password_encryption'

class Bookmarks < Sinatra::Base

enable :sessions

# get '/' do
#   redirect '/links/index'
# end
get '/' do
  erb :home
end

post '/' do
  my_password = BCrypt::Password.create(params[:password])

  user = User.create(
    :name => params[:name],
    :email => params[:email],
    :password => my_password
  )
  user.save
  p user
  redirect '/links'
end

get '/links' do
  !!User.last ? @name = User.first.name : @name = 'Guest'
  @links = Link.all
  erb :'links/index'
end

get '/links/new' do
  erb :'links/new'
end

post '/links/newlink' do
  link = Link.create(
  :title => params[:title],
  :url => params[:url]
  )
  params[:tags].split(",").each do |tag|
    tag = Tag.create(name: tag)
    link.tags << tag
  end
  link.save
  redirect('/links')
end

get '/tags/:name' do
  tag = Tag.first(name: params[:name])
  @links = tag ? tag.links : []
  erb :'links/index'
  end

run! if app_file ==$0
end
