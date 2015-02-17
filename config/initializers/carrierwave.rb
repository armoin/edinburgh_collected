CarrierWave.configure do |config|
  if Rails.env.test?
    config.enable_processing = false
  else
    config.storage    = :fog
    config.fog_public = true

    if ENV['PROVIDER'] == 'Rackspace'

      config.fog_credentials = {
        :provider           => 'Rackspace',

        :rackspace_username => ENV['RACKSPACE_USERNAME'],
        :rackspace_api_key  => ENV['RACKSPACE_API_KEY'],
        :rackspace_auth_url => Fog::Rackspace::UK_AUTH_ENDPOINT,
        :rackspace_region   => :lon
      }
      config.asset_host    = ENV['ASSET_HOST']

    elsif ENV['PROVIDER'] == 'AWS'

      config.fog_credentials = {
        :provider               => 'AWS',

        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
        :region                 => 'eu-west-1',
      }
      
    end

    config.fog_directory = ENV['STORE_DIR']

    config.cache_dir = "#{Rails.root}/#{ENV['CACHE_DIR']}/uploads"
  end
end

