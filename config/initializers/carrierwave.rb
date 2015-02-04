CarrierWave.configure do |config|
  if Rails.env.test?
    config.enable_processing = false
  elsif Rails.env.production? && ENV['HOST'] == 'http://edinburgh-collected.herokuapp.com'
    config.storage    = :fog
    config.fog_public = true

    config.fog_credentials = {
      :provider           => 'Rackspace',

      :rackspace_username => ENV['RACKSPACE_USERNAME'],
      :rackspace_api_key  => ENV['RACKSPACE_API_KEY'],
      :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
      :rackspace_region   => :lon
    }
    config.fog_directory = ENV['BUCKET_NAME']
    config.asset_host    = ENV['ASSET_HOST']

    # To let CarrierWave work on heroku
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  else
    config.storage    = :fog
    config.fog_public = true

    config.fog_credentials = {
      :provider           => 'AWS',

      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                 => 'eu-west-1',
    }
    config.fog_directory = ENV['S3_BUCKET_NAME']

    # To let CarrierWave work on heroku
    config.cache_dir = "#{Rails.root}/public/uploads"
  end
end

