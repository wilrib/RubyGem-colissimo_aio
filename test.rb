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
  config.format = 'ZPL_203'
  config.weight = '5'
  config.signed = false
  config.international = false
  config.raw_format = false
end


# GENERATE DEPOSIT
#depositArray = %w(6C14365610897 8R41974798470 6C14363208744 8R41972000544)
#deposit = ColissimoAIO::DepositClass.new
#deposit.generateBordereauxByParcelNumbers(depositArray)
#
#
## INFO D'UN RELAY POINT
#relayPoint = ColissimoAIO::RelayPointClass.new
#p relayPoint.find_relay_point_informations('011430')
#
#
## TRACKING INFORMATIONS
#tracking = ColissimoAIO::TrackingClass.new
#p tracking.track('6C14365610897')


# ETIQUETTE ALLER
#shippingLabel = ColissimoAIO::LabelClass.new
#shippingLabel.shipping_label('Alex', 'XELA',
#                             '12 Rue de la Roquette', 'FR',
#                             'Paris', '75011',
#                             '0660066006', 'test@gmail.com')
#TODO: Plutot que faire un array faire un Hash key=>value

# ETIQUETTE RETOUR
#returnLabel = ColissimoAIO::LabelClass.new
#returnLabel.return_label('Alex', 'XELA',
#                         '12 Rue de la Roquette', 'FR',
#                         'Paris', '75011', '0660066006',
#                         'test@gmail.com')
#TODO: Plutot que faire un array faire un Hash key=>value

# ETIQUETTE ALLER RELAY POINT
#retour = ColissimoAIO::LabelClass.new
#retour.relay_point_label('Alex', 'XELA',
#                         '12 Rue de la Roquette', 'FR',
#                         'Paris', '75011', '0660066006',
#                         'test@gmail.com', '011430')

# ETIQUETTE RETOUR RELAY POINT
#retour = ColissimoAIO::LabelClass.new
#retour.relay_point_retour('Alex', 'XELA',
#                          '12 Rue de la Roquette', 'FR',
#                          'Paris', '75011', 'test@gmail.com', 'CORE')
