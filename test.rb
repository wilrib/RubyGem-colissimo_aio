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


# GENERATE DEPOSIT BY PARCEL NULMBER
array = %w[6C14365610897 8R41974798470 6C14363208744 8R41972000544]
deposit = ColissimoAIO::DepositClass.new
deposit.generate_deposit_by_parcel(array)


# GENERATE DEPOSIT BY ID
deposit = ColissimoAIO::DepositClass.new
deposit.generate_deposit_by_id('290')


## INFO D'UN RELAY POINT
#relay = ColissimoAIO::RelayPointClass.new
#p relay.find_relay_point_informations('011430')


## TRACKING INFORMATIONS
#tracking = ColissimoAIO::TrackingClass.new
#p tracking.track('6C14365610897')


# ETIQUETTE ALLER
#shipping = ColissimoAIO::LabelClass.new
#p shipping.shipping_label(first_name: 'Axel',
#                          last_name: 'XELA',
#                          street: '20 rue des Sables',
#                          country: 'BE',
#                          city: 'Bruxelles',
#                          zip: '1000',
#                          phone: '+32475871902',
#                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
#returnLabel = ColissimoAIO::LabelClass.new
#p returnLabel.return_label(first_name: 'Axel',
#                           last_name: 'XELA',
#                           street: '20 rue des Sables',
#                           country: 'BE',
#                           city: 'Bruxelles',
#                           zip: '1000',
#                           phone: '+32475871902',
#                           email: 'test@gmail.com')

# ETIQUETTE ALLER RELAY POINT
#relay = ColissimoAIO::LabelClass.new
#relay.relay_point_label(first_name: 'Axel',
#                        last_name: 'XELA',
#                        street: '12 Rue de la Roquette',
#                        country: 'FR',
#                        city: 'Paris',
#                        zip: '75001',
#                        phone: '0660066006',
#                        email: 'test@gmail.com',
#                        relay_id: '011430')



#HTTP.post(service_url,
#          json: {
#              "contractNumber": ColissimoLabel.contract_number,
#              "password":       ColissimoLabel.contract_password,
#              "outputFormat":   {

#20, rue des Sables 1000 Bruxelles Belgique, +32 (0)2 219 19 80
#
#32 Rue Notre-Dame, 2240 Luxembourg Luxembourg, +352 27 85 84 68
#
#127 Ledbury Road, W11 2AQ Londres Angleterre, +44 20 7792 9090
#
# Rue du 31 Décembre 32, 1207 Genève, Suisse, +41 22 736 32 32