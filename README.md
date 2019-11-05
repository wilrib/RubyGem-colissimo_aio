# Colissimo

This is an unofficial Ruby Gem that allow you to:
- Generate Colissimo Label in different format (DPL, ZPL and PDF) `(only france actually)`
- Generate Bordereau Colissimo in PDF
- Return all informations about a Pickup Point from his ID (address, opening hour, etc)

TODO:
- Generate Colissimo Label to other country `(in progress)`
- Tracking information `(in progress)`
- Generate Pickup Point Label

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'colissimo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install colissimo

## Usage

#### First :

You have to configure Colissimo Gem with your colissimo account, compagny information, and specific information about generated label.

```ruby
Colissimo.configure do |config|
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

You can create your object
You can follow all this example
```ruby
# GENRATING BORDEREAU 
bordarray = %w(6C14325660897 8R49974797470 6C12363204744 8R42972003544)
bordereau = Colissimo::Bordereau.new
bordereau.generateBordereauxByParcelNumbers(bordarray) => take an array
#=> Create a Bordereau.pdf label in root folder of your project


# PICKUP POINT INFORMATION
retrait = Colissimo::PointRetrait.new
retrait.find_point_retrait_address(pickup_point_id)
#=> Return string with all informations about a Pickup Point


# GENERATING SHIPPING LABEL
aller = Colissimo::Label.new
aller.colis_aller(customer_first_name, customer_last_name, 
                      customer_address, customer_country_code, 
                      customer_city, customer_zip, customer_email, 
                      label_format)
#=> Create a label in specified format in root folder of your project and return the tracking number


# GENERATING RETURN SHIPPING LABEL
retour = Colissimo::Label.new
puts retour.colis_retour(customer_first_name, customer_last_name, 
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
