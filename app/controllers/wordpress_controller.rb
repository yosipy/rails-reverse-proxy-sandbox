class WordpressController < ApplicationController
  include ReverseProxy::Controller
  require 'net/http'

  def index
    path = "/#{params[:path]}"

    reverse_proxy 'http://wordpress:80', path: path, reset_accept_encoding: true, headers: { 'host' => 'localhost:8000' } do |config|
      config.on_response do |code, response|
        response.body = rewrite_links(response.body)
      end

      # remove cookies from wp: wordpress_logged_in_, wordpress_*_cookie, wp-settings-time-*, wp-settings-*
      cookie_keys = cookies.to_h.keys
      wordpress_cookie_keys = cookie_keys.grep(/^wordpress_|^wp-settings-/)
      wordpress_cookie_keys.each do |wordpress_cookie_key|
        cookies.delete(wordpress_cookie_key)
      end
    end
  end

  def rewrite_links(html)
    # parsed_html = html.gsub("localhost:8000", "localhost:3000/blog")
    #                   .gsub("localhost:3000/blog/wp-includes", "localhost:8000/wp-includes")
    #                   .gsub("localhost:3000/blog/wp-content", "localhost:8000/wp-content")

    parsed_html = html.gsub("localhost:8000/posts", "localhost:3000/blog/posts")

    # parsed_html.html_safe
  end
end
