Gem::Specification.new do |spec|
  spec.name = "diaspora_federation-sinatra_app"
  spec.version = "0.1.0"

  spec.files = ["lib/**/*"]

  spec.summary = "This gem adds Diaspora federation features to your Sinatra based application"
  spec.author = "cmrd Senya"
  spec.email = "senya@riseup.net"
  spec.homepage = "https://github.com/cmrd-senya/diaspora_federation-sinatra_app"

  spec.add_dependency("sinatra")
  spec.add_dependency("diaspora_federation")
end
