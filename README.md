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
gem 'colissimo_AIO'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install colissimo_AIO

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
  config.format = 'PDF'               #=> Format accepted PDF, ZPL_203/ZPL_300, DPL_203/DPL_300
  config.weight = '5'                 #=> weight in Kg of your package
  config.signed = false/true          #=> signed shipping label or not
  config.internationnal = false/true  #=> international shipping label or not
  config.raw_format = false/true      #=> if false, `label` method will return an array with ["label_in_raw_format", "tracking_number"] into
                                      #=> if true, `label` method will create label_file.pdf/zpl/dpl and return an array with ["tracking_number"] into
end
```


#### Next :

You can create your object and follow all this example.
###### In `test.rb` file, have example, quite same as following
```ruby
# GENERATE DEPOSIT
depositArray = %w(6C14365610897 8R41974798470 6C14363208744 8R41972000544)
deposit = ColissimoAIO::DepositClass.new
deposit.generateBordereauxByParcelNumbers(depositArray) #=> take an array of tracking number
#=> Create a Bordereau.pdf file in root folder of your project


# RELAY POINT INFORMATIONS
relayPoint = ColissimoAIO::RelayPointClass.new
relayPoint.find_relay_point_informations('011430')
#=> Return string with all informations about a Relay Point


# TRACKING INFORMATION
tracking = ColissimoAIO::TrackingClass.new
tracking.track('6C14365610897')
#=> Return the last state of the tracking number

 
# GENERATING LOCAL SHIPPING LABEL
shippingLabel = ColissimoAIO::LabelClass.new
shippingLabel.shipping_label('customer_first_name', 'customer_last_name', 
                             'customer_address', 'customer_country_code', 
                             'customer_city', 'customer_zip', 'customer_phone_number',
                             'customer_email')
#=> Create a local shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RETURN SHIPPING LABEL
returnLabel = ColissimoAIO::LabelClass.new
returnLabel.return_label('customer_first_name', 'customer_last_name', 
                      'customer_address', 'customer_country_code', 
                      'customer_city', 'customer_zip', 'customer_phone_number',
                      'customer_email')
#=> Create a local return shipping label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number


# GENERATING RELAY POINT SHIPPING LABEL
relayLabel = ColissimoAIO::LabelClass.new
relayLabel.relay_point_label('customer_first_name', 'customer_last_name', 
                      'customer_address', 'customer_country_code', 
                      'customer_city', 'customer_zip', 'customer_phone_number',
                      'customer_email', 'relay_id') 
#=> Create a local relay label and return it in specified format in root folder of your project if `raw_format = true`, else return an array with label in raw format + tracking number
```


## Informations

- `config.format` accepted : 'PDF', 'ZPL_203', 'ZPL_300', 'DPL_203', 'DPL_300'
- `config.weight` : weight in Kg
- `config.signed` : `true` if you want signed shipping label, else `false`
- `config.internationnal` : `true` if you want international shipping label, else `false`
- `config.raw_format` : if `false`, `label` method will return an array with ["label_in_raw_format", "tracking_number"] into, else `label` method will create label_file.pdf/zpl/dpl in root folder and return an array with ["tracking_number"] into



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilrib/colissimo_AIO.
