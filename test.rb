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
  config.date = DateTime.now.strftime('%d-%m-%Y')
  config.signed = true
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
relay = ColissimoAIO::RelayPointClass.new
relay.find_relay_point_informations('011430')


## INFO D'UN RELAY POINT
relay = ColissimoAIO::RelayPointClass.new
relay.find_nearest_relay_point(address: '12 Rue de la Roquette', zipCode: '75001',
                                 city: 'Paris', countryCode: 'FR')


## TRACKING INFORMATIONS
tracking = ColissimoAIO::TrackingClass.new
p tracking.track('6C14365610897')

puts "================"
puts "LABEL FRANCE"
puts "================"
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
p relay.relay_point_label(first_name: 'Axel',
                        last_name: 'XELA',
                        street: '12 Rue de la Roquette',
                        country: 'FR',
                        city: 'Paris',
                        zip: '75001',
                        phone: '0660066006',
                        email: 'test@gmail.com',
                        relay_id: '011430')

puts "================"
puts "ETIQUETTE BELGIQUE"
puts "================"
# ETIQUETTE ALLER
shipping = ColissimoAIO::LabelClass.new
p shipping.shipping_label(first_name: 'Axel',
                          last_name: 'XELA',
                          street: '20 rue des Sables',
                          country: 'BE',
                          city: 'Bruxelles',
                          zip: '1000',
                          phone: '+32475871902',
                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
returnLabel = ColissimoAIO::LabelClass.new
p returnLabel.return_label(first_name: 'Axel',
                           last_name: 'XELA',
                           street: '20 rue des Sables',
                           country: 'BE',
                           city: 'Bruxelles',
                           zip: '1000',
                           phone: '+32475871902',
                           email: 'test@gmail.com')

puts "================"
puts "LABEL LUXEMBOURG"
puts "================"
# ETIQUETTE ALLER
shipping = ColissimoAIO::LabelClass.new
p shipping.shipping_label(first_name: 'Axel',
                          last_name: 'XELA',
                          street: '32 Rue Notre-Dame',
                          country: 'LU',
                          city: 'Luxembourg',
                          zip: '2240',
                          phone: '+35227858468',
                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
returnLabel = ColissimoAIO::LabelClass.new
p returnLabel.return_label(first_name: 'Axel',
                           last_name: 'XELA',
                           street: '32 Rue Notre-Dame',
                           country: 'LU',
                           city: 'Luxembourg',
                           zip: '2240',
                           phone: '+35227858468',
                           email: 'test@gmail.com')

puts "================"
puts "LABEL ANGLETERRE"
puts "================"
# ETIQUETTE ALLER
shipping = ColissimoAIO::LabelClass.new
p shipping.shipping_label(first_name: 'Axel',
                          last_name: 'XELA',
                          street: '127 Ledbury Road',
                          country: 'GB',
                          city: 'London',
                          zip: 'W11 2AQ',
                          phone: '+442077929090',
                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
returnLabel = ColissimoAIO::LabelClass.new
p returnLabel.return_label(first_name: 'Axel',
                           last_name: 'XELA',
                           street: '127 Ledbury Road',
                           country: 'GB',
                           city: 'London',
                           zip: 'W11 2AQ',
                           phone: '+442077929090',
                           email: 'test@gmail.com')

puts "================"
puts "LABEL SUISSE"
puts "================"
# ETIQUETTE ALLER
shipping = ColissimoAIO::LabelClass.new
p shipping.shipping_label(first_name: 'Axel',
                          last_name: 'XELA',
                          street: 'Rue du 31 Décembre 32',
                          country: 'CH',
                          city: 'Genève',
                          zip: '1207',
                          phone: '+41227363232',
                          email: 'test@gmail.com')


# ETIQUETTE RETOUR
returnLabel = ColissimoAIO::LabelClass.new
p returnLabel.return_label(first_name: 'Axel',
                           last_name: 'XELA',
                           street: 'Rue du 31 Décembre 32',
                           country: 'CH',
                           city: 'Genève',
                           zip: '1207',
                           phone: '+41227363232',
                           email: 'test@gmail.com')