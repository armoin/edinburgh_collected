Geocoder.configure(:lookup => :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => -3.1196158,
      'longitude'    => 55.9578751,
      'address'      => 'Kings Road',
      'country'      => 'United Kingdom',
      'country_code' => 'UK'
    }
  ]
)
