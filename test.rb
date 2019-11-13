require 'dotenv/load'
require 'colissimo_aio'

# CONFIGURATION DE LA GEM
ColissimoAIO.configure do |config|
  config.account = ENV['ACCOUNT']
  config.password = ENV['PASSWORD']
  config.company_name = ENV['COMPANY_NAME']
  config.address = ENV['ADDRESS']
  config.country_code = ENV['COUNTRY_CODE']
  config.city = ENV['CITY']
  config.zip_code = ENV['ZIP_CODE']
  config.phone = ENV['PHONE']
  config.email = ENV['EMAIL']
  config.format = 'PDF'
  config.weight = '5'
  config.signed = false
  config.international = false
  config.raw_format = false
  config.local_path = File.join('public', 'colissimo_file') # Rails.root.join('public', 'colissimo_file')
end


# GENERATE DEPOSIT
array = %w[6C14365610897 8R41974798470 6C14363208744 8R41972000544]
deposit = ColissimoAIO::DepositClass.new
deposit.generate_deposit(array)


## INFO D'UN RELAY POINT
relay = ColissimoAIO::RelayPointClass.new
p relay.find_relay_point_informations('011430')


## TRACKING INFORMATIONS
tracking = ColissimoAIO::TrackingClass.new
p tracking.track('6C14365610897')


# ETIQUETTE ALLER
shipping = ColissimoAIO::LabelClass.new
p shipping.shipping_label(first_name: 'Axel',
                          last_name: 'XELA',
                          street: '12 Rue de la Roquette',
                          country: 'FR',
                          city: 'Paris',
                          zip: '75001',
                          phone: '0660066006',
                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
returnLabel = ColissimoAIO::LabelClass.new
p returnLabel.return_label(first_name: 'Axel',
                           last_name: 'XELA',
                           street: '12 Rue de la Roquette',
                           country: 'FR',
                           city: 'Paris',
                           zip: '75001',
                           phone: '0660066006',
                           email: 'test@gmail.com')

# ETIQUETTE ALLER RELAY POINT
relay = ColissimoAIO::LabelClass.new
relay.relay_point_label(first_name: 'Axel',
                        last_name: 'XELA',
                        street: '12 Rue de la Roquette',
                        country: 'FR',
                        city: 'Paris',
                        zip: '75001',
                        phone: '0660066006',
                        email: 'test@gmail.com',
                        relay_id: '011430')