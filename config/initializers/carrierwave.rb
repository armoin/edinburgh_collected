CarrierWave.configure do |config|
  if Rails.env.test?
    config.enable_processing = false
  else
    config.storage = :fog

    # config.fog_credentials = {
    #   :provider               => 'AWS',
    #   :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    #   :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    #   :region                 => 'eu-west-1'
    # }
    # config.fog_directory      = ENV['S3_BUCKET_NAME']
    #

    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'nestaproject',
      :rackspace_api_key  => '53e214a49cfc444a827212b6b0b7e9db',
      :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
      :rackspace_region   => :lon
    }
    config.fog_directory = 'Nesta Project'
    config.fog_public    = true
    config.asset_host    = "http://4019eac0904bfa4d1cb5-9a025cf9f86362160bae9a5684264911.r89.cf3.rackcdn.com/"

    # To let CarrierWave work on heroku
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end
end

