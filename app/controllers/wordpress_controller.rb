class WordpressController < ApplicationController
  include ReverseProxy::Controller
  require 'net/http'

  def index
    path = "/#{params[:path]}"

    reverse_proxy 'http://wordpress:80', path: path, headers: { 'host' => 'localhost:8000' }
  end
end
