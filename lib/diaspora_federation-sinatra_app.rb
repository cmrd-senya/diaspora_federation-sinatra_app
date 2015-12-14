require "nokogiri"
require "sinatra"
require "bundler/setup"
require "diaspora_federation"
require "open-uri"

class DiasporaFederation::SinatraApp < Sinatra::Base
  def self.federation_module
    DiasporaFederation
  end

  def my_url
    self.class.federation_module.server_uri
  end

  #routes

  get "/.well-known/host-meta" do
    hostmeta = DiasporaFederation::Discovery::HostMeta.from_base_url(my_url)
    hostmeta.to_xml
  end

  get "/webfinger" do
    id = params[:q].match(/acct:([^\&]+)/)[1]
    self.class.federation_module.callbacks.trigger(:fetch_person_for_webfinger, id).to_xml
  end

  get '/hcard/users/:guid' do |guid|
    self.class.federation_module.callbacks.trigger(:fetch_person_for_hcard, params[:guid]).to_html
  end

  post "/receive/users/:guid" do |guid|
    begin
      DiasporaFederation::Receiver::Private.new(params[:guid], CGI.unescape(params[:xml])).receive!
      ""
    rescue DiasporaFederation::RecipientNotFound
      status 404
    end
  end

  post "/receive/public" do
    DiasporaFederation::Receiver::Public.new(CGI.unescape(params[:xml])).receive!
    ""
  end
end
