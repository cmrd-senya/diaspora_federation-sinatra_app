source "https://rubygems.org"

gem "diaspora_federation", :git => "https://github.com/cmrd-senya/diaspora_federation.git", :branch => "hydra-wrapper"
gem "sinatra"

#development
gem "shotgun"

group :development, :test do
  gem "rspec", "< 4.0"
  gem "uuid"
end

group :test do
  gem "rack-test"
  gem "fuubar", "2.0.0", require: false
  gem "factory_girl"
end
