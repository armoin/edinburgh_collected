CarrierWave.configure do |config|
  if Rails.env.test?
    config.enable_processing = false
  else
    if ENV['PROVIDER'] == 'Rackspace'
      
      config.storage    = :fog
      config.fog_public = true

      config.fog_credentials = {
        :provider           => 'Rackspace',

        :rackspace_username => ENV['RACKSPACE_USERNAME'],
        :rackspace_api_key  => ENV['RACKSPACE_API_KEY'],
        :rackspace_auth_url => Fog::Rackspace::UK_AUTH_ENDPOINT,
        :rackspace_region   => :lon
      }

      config.fog_directory = ENV['STORE_DIR']
      config.asset_host    = ENV['ASSET_HOST']

    elsif ENV['PROVIDER'] == 'AWS'
      
      config.storage    = :fog
      config.fog_public = true

      config.fog_credentials = {
        :provider               => 'AWS',

        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
        :region                 => 'eu-west-1',
      }
    
      config.fog_directory = ENV['STORE_DIR']

    else

      config.storage = :file
      
    end

    config.cache_dir = "#{Rails.root}/#{ENV['CACHE_DIR']}/uploads"
  end
end

