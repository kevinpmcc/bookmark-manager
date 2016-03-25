ENV["RACK_ENV"] ||= "development"
require_relative 'models/link'
require 'sinatra/base'
require_relative 'data_mapper_setup'
require_relative 'models/password_encryption'
require 'sinatra/flash'

class Bookmarks < Sinatra::Base

register Sinatra::Flash

enable :sessions
set :session_secret, 'super secret'
  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end

    def encrypt(password)
      BCrypt::Password.create(password)
    end
  end

  get '/' do
    erb :home
  end

  post '/' do
    @user = User.create(
      :name => params[:name],
      :email => params[:email],
      :password => params[:password],
      :password_confirmation => params[:confirm_password]
    )
    if @user.save
      session[:user_id] = @user.id
      redirect('/links')
    else 
      flash.now[:errors] = @user.errors.full_messages 
      erb(:home)
    end
  end

  post '/login' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect '/links'
    else
     flash.now[:errors] = ['The email or password is incorrect']
    redirect '/' 
    end
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end


  post '/links' do
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

  get '/links/new' do
    erb :'links/new'
  end
 
  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  run! if app_file ==$0
end
