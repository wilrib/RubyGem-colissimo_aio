# Colissimo

This is an unofficial Ruby Gem that allow you to:
- Generate Colissimo Label in different format (DPL, ZPL and PDF) `(only france actually)`
- Generate Bordereau Colissimo in PDF
- Return all informations about a Relay Point from his ID (address, opening hour, etc)

TODO:
- Generate Colissimo Label to other country `(in progress)`
- Tracking information `(in progress)`
- Generate Relay Point Label

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
  config.format = 'PDF' #=> Format accepted PDF, ZPL_203/ZPL_300, DPL_203/DPL_300
  config.weight = '5' #=> weight in Kg of your package
end
```


#### Next :

You can create your object and follow all this example.
###### In `test.rb` file, have example, quite same as following
```ruby
# GENRATING BORDEREAU 
bordarray = %w(6C14325660897 8R49974797470 6C12363204744 8R42972003544)
bordereau = ColissimoAIO::Deposit.new
bordereau.generateBordereauxByParcelNumbers(bordarray) #=> take an array of tracking number
#=> Create a Bordereau.pdf label in root folder of your project


# RELAY POINT INFORMATION
retrait = ColissimoAIO::RelayPoint.new
retrait.find_relay_point_informations(relay_point_id)
#=> Return string with all informations about a Relay Point


# GENERATING SHIPPING LABEL
aller = ColissimoAIO::Label.new
aller.shipping_label(customer_first_name, customer_last_name, 
                      customer_address, customer_country_code, 
                      customer_city, customer_zip, customer_email, 
                      label_format)
#=> Create a label in specified format in root folder of your project and return the tracking number


# GENERATING RETURN SHIPPING LABEL
retour = ColissimoAIO::Label.new
puts retour.return_label(customer_first_name, customer_last_name, 
                         customer_address, customer_country_code, 
                         customer_city, customer_zip, customer_email, 
                         label_format)
#=> Create a label in specified format in root folder of your project and return the tracking number
```


## Informations

- `config.format` accepted : 'PDF', 'ZPL_203', 'ZPL_300', 'DPL_203', 'DPL_300'
- `label_format` accepted : 'DOS'
- `label_format` return label accepted : 'CORE'


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/colissimo.
