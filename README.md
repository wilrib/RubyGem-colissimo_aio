# Colissimo

This is an unofficial Ruby Gem that allow you to:
- Generate Colissimo `Shipping_Label` in different format (DPL, ZPL and PDF) (only france actually)
- Generate Colissimo `Return_Label` in different format (DPL, ZPL and PDF) (only france actually)
- Generate `Relay_Point_Label` in different format (DPL, ZPL and PDF) (only france actually)
- Generate Deposit file Colissimo in PDF
- Tracking information (Colissimo allow only to return the last tracking information)
- Return all informations about a Relay Point from his ID (address, opening hour, etc)

TODO:
- Generate Colissimo Label to other country `(in progress)`

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

You have to configure Colissimo Gem with your colissimo account, compagny information, and specific information about generated label.

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
end
```


#### Next :

You can create your object and follow all this example.
###### In `test.rb` file, have example, quite same as following
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


# RELAY POINT INFORMATIONS
relay = ColissimoAIO::RelayPointClass.new
relay.find_relay_point_informations('011430')
#=> Return string with all informations about a Relay Point


# INFO D'UN RELAY POINT
relay = ColissimoAIO::RelayPointClass.new
relay.find_nearest_relay_point(address: '12 Rue de la Roquette', zipCode: '75001',
                                 city: 'Paris', countryCode: 'FR') 
#=> Return string with all Relay Point near specified address


# TRACKING INFORMATION
tracking = ColissimoAIO::TrackingClass.new
tracking.track('6C14365610897')
#=> Return an Array with the last state of the tracking number

 
# GENERATING LOCAL SHIPPING LABEL
shipping = ColissimoAIO::LabelClass.new
shipping.shipping_label(first_name: 'Axel',
                        last_name: 'XELA',
                        street: '12 Rue de la Roquette',
                        country: 'FR',
                        city: 'Paris',
                        zip: '75001',
                        phone: '0660066006',
                        email: 'test@gmail.com')
#=> Create a local shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RETURN SHIPPING LABEL
returnLabel = ColissimoAIO::LabelClass.new
returnLabel.return_label(first_name: 'Axel',
                         last_name: 'XELA',
                         street: '12 Rue de la Roquette',
                         country: 'FR',
                         city: 'Paris',
                         zip: '75001',
                         phone: '0660066006',
                         email: 'test@gmail.com')
#=> Create a local return shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RELAY POINT SHIPPING LABEL
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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilrib/colissimo_AIO.
