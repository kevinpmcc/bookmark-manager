ENV["RACK_ENV"] ||= "development"
require_relative 'models/link'
require 'sinatra/base'
require_relative 'data_mapper_setup'
require_relative 'models/password_encryption'
require 'sinatra/flash'

class Bookmarks < Sinatra::Base

use Rack::Session::Pool, :expire_after => 2592000
register Sinatra::Flash

  helpers do
    def encrypt(password)
      BCrypt::Password.create(password)
    end
  end

  get '/' do
    erb :home
  end

  post '/' do
    User.all ? user_count = User.all.count : user_count = 0
    session[:name] = params[:name]
    session[:email] = params[:email]
    user = User.create(
      :name => session[:name],
      :email => session[:email],
      :password => params[:password],
      :password_confirmation => params[:confirm_password]
    )
    if user.save
      redirect('/links')
    else
      flash[:message] = 'Password and confirmation password do not match'
      redirect('/')
    end
  end

  get '/links' do
    !!User.last ? @name = User.last.name : @name = 'Guest'
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
