require 'dotenv/load'
require 'colissimo'

# CONFIGURATION DE LA GEM
Colissimo.configure do |config|
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
end

# GENERATION BORDEREAU
bordarray = %w(6C14365610897 8R41974798470 6C14363208744 8R41972000544)
bordereau = Colissimo::Bordereau.new
bordereau.generateBordereauxByParcelNumbers(bordarray)

# INFO D'UN POINT RETRAIT
retrait = Colissimo::PointRetrait.new
puts retrait.find_point_retrait_address('011430')

#ETIQUETTE ALLER
aller = Colissimo::Label.new
p aller.colis_aller('Alex', 'XELA', '12 Rue de la Roquette', 'FR', 'Paris', '75011', 'test@gmail.com', 'DOS')

#ETIQUETTE RETOUR
retour = Colissimo::Label.new
p retour.colis_retour('Alex', 'XELA', '12 Rue de la Roquette', 'FR', 'Paris', '75011', 'test@gmail.com', 'CORE')