# Colissimo

This is an unofficial Ruby Gem that allow you to:
- Generate Colissimo `Shipping_Label` in different format (DPL, ZPL and PDF) (France, Belgium, Royaume-Uni, Luxembourg)
- Generate Colissimo `Return_Label` in different format (DPL, ZPL and PDF) (France, Belgium, Royaume-Uni, Luxembourg)
- Generate `Relay_Point_Label` in different format (DPL, ZPL and PDF) (ONLY France)
- Generate `Deposit` file Colissimo in PDF
- ReGenerate `Deposit` file Colissimo in PDF from an ID
- Tracking information (Colissimo allow only to return the last tracking information)
- Return all information about a Relay Point from his ID (address, opening hour, etc) (ONLY France)
- Return all closest Relay Point from giving address (ONLY France)

###### TODO:
- ###### Generate International Shipping_Label / Return_Label `(in progress)`
- ###### Generate International Relay_Point_Label `(in progress)`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'colissimo_aio'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install colissimo_aio

## Usage

#### First :

You have to configure Colissimo Gem with your colissimo account, company information, and specific information about generated label.

###### You can put this configuration on your `config/initializers` folder

```ruby
ColissimoAIO.configure do |config|
  config.account = '12345678'
  config.password = 'MyPassword'
  config.company_name = 'Company'
  config.address = '1 rue de paris'
  config.country_code = 'FR'
  config.city = 'PARIS'
  config.zip_code = '75001'
  config.phone = '0606060606'
  config.email = 'email@email.com'
  config.format = 'PDF'                             #=> Format accepted PDF, ZPL_203/ZPL_300, DPL_203/DPL_300
  config.weight = '5'                               #=> weight in Kg of your package
  config.signed = false/true                        #=> signed shipping label or not
  config.international = false/true                 #=> international shipping label or not
  config.raw_format = false/true                    #=> if false, `label` method will return an array with ["label_in_raw_format", "tracking_number"] into
                                                    #=> if true, `label` method will create label_file.pdf/zpl/dpl and return an array with ["tracking_number"] into
  config.local_path = File.join('public',
                                'colissimo_file')   #=> Specify the storage folder
  config.date = DateTime.now.strftime('%d-%m-%Y')   #=> Specify Date (14-11-2019)
end
```


#### Next :

You can create your object and follow all this example.
###### In `test.rb` file, have examples, quite same as following

## Generate Deposit Label (bordereau.pdf) part:
```ruby
# GENERATE DEPOSIT
array = %w(6C14365610897 8R41974798470 6C14363208744 8R41972000544)
deposit = ColissimoAIO::DepositClass.new
deposit.generate_deposit_by_parcel(array) #=> take an array of tracking number
#=> Create a Bordereau.pdf file in `/colissimo_label`


# REGENERATE DEPOSIT PREVIOUSLY GENERATED (BY ID)
deposit = ColissimoAIO::DepositClass.new
deposit.generate_deposit_by_id('290')
#=> Create a Bordereau.pdf file in `/colissimo_label`
```

## Relay Point Informations part:
```ruby
# RELAY POINT INFORMATIONS FORM HIS ID
relay = ColissimoAIO::RelayPointClass.new
relay.find_relay_point_informations('011430')
#=> Return string with all informations about a Relay Point


# FIND ALL CLOSEST RELAY POINT FROM GIVING ADDRESS
relay = ColissimoAIO::RelayPointClass.new
relay.find_nearest_relay_point(address: '12 Rue de la Roquette', zipCode: '75001',
                                 city: 'Paris', countryCode: 'FR') 
#=> Return all Relay Points closest to a given address
```

## Tracking Informations part:
```ruby
# TRACKING INFORMATION FROM TRACKING NUMBER
tracking = ColissimoAIO::TrackingClass.new
tracking.track('6C14365610897')
#=> Return an Array with the last state of the tracking number
```
 
## Generate Label part:
```ruby
# GENERATING LOCAL SHIPPING LABEL
label = ColissimoAIO::LabelClass.new
label.shipping_label(first_name: 'Axel',
                        last_name: 'XELA',
                        street: '12 Rue de la Roquette',
                        country: 'FR',
                        city: 'Paris',
                        zip: '75001',
                        phone: '0660066006',
                        email: 'test@gmail.com')
#=> Create a local shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RETURN SHIPPING LABEL
label = ColissimoAIO::LabelClass.new
label.return_label(first_name: 'Axel',
                         last_name: 'XELA',
                         street: '12 Rue de la Roquette',
                         country: 'FR',
                         city: 'Paris',
                         zip: '75001',
                         phone: '0660066006',
                         email: 'test@gmail.com')
#=> Create a local return shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RELAY POINT SHIPPING LABEL
label = ColissimoAIO::LabelClass.new
label.relay_point_label(first_name: 'Axel',
                        last_name: 'XELA',
                        street: '12 Rue de la Roquette',
                        country: 'FR',
                        city: 'Paris',
                        zip: '75001',
                        phone: '0660066006',
                        email: 'test@gmail.com',
                        relay_id: '011430')
#=> Create a local relay label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number
```
###### In both cases, if the label cannot be generated it raises a StandardError with the reason. Otherwise, the parcel number is returned and files saved in the specified folders.

## Documentation
Colissimo documentation can be found here:
https://www.colissimo.entreprise.laposte.fr/system/files/imagescontent/docs/spec_ws_affranchissement.pdf

## Informations

- `config.format` accepted : 'PDF', 'ZPL_203', 'ZPL_300', 'DPL_203', 'DPL_300'
- `config.weight` : weight in Kg
- `config.signed` : `true` if you want signed shipping label, else `false`
- `config.internationnal` : `true` if you want international shipping label, else `false`
- `config.raw_format` : if `false`, `label` method will return an array with ["label_in_raw_format", "tracking_number"] into, else `label` method will create label_file.pdf/zpl/dpl in root folder and return an array with ["tracking_number"] into
- `config.local_path` : you can specify here the local storage of all files generated `File.join('public', 'colissimo_file') # Rails.root.join('public', 'colissimo_file')`

- `Shipping_Label` / `Return_Label` / `Relay_Point_Label` methods accept FR/BE/LU/GB country

- `Relay_Point_Label` method is only available in France

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilrib/colissimo_AIO.
