require "nokogiri"
require "sinatra"
require "bundler/setup"
require "diaspora_federation"
require "open-uri"

class DiasporaFederation::SinatraApp < Sinatra::Base
  def my_url
    DiasporaFederation.server_uri
  end

  #routes

  get "/.well-known/host-meta" do
    hostmeta = DiasporaFederation::Discovery::HostMeta.from_base_url(my_url)
    hostmeta.to_xml
  end

  get "/.well-known/webfinger.xml" do
    id = params[:resource].match(/acct:([^\&]+)/)[1]
    DiasporaFederation.callbacks.trigger(:fetch_person_for_webfinger, id).to_xml
  end

  get '/hcard/users/:guid' do |guid|
    DiasporaFederation.callbacks.trigger(:fetch_person_for_hcard, params[:guid]).to_html
  end

  post "/receive/users/:guid" do |guid|
    begin
      DiasporaFederation.callbacks.trigger(:queue_private_receive, guid, request.body.read, false)
      ""
    rescue DiasporaFederation::RecipientNotFound
      status 404
    end
  end

  post "/receive/public" do
    DiasporaFederation.callbacks.trigger(:queue_public_receive, request.body.read, false)
    ""
  end
end
