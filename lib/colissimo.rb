require 'colissimo/version'
require 'colissimo/configuration'
require 'ostruct'
require 'savon'

module Colissimo

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Error < StandardError;
  end

  class PointRetrait

    def initialize
      @client = Savon.client do |config|
        config.wsdl Colissimo.configuration.retrait
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { accountNumber: Colissimo.configuration.account,
                password: Colissimo.configuration.password }
    end

    def find_point_retrait_address(retrait_id)
      data = { id: retrait_id, date: DateTime.now.strftime('%d/%m/%Y') }
      @client.call :find_point_retrait_acheminement_by_id, message: @auth.merge(data) unless data.empty?
    end
  end

  class Bordereau

    def initialize
      @client = Savon.client do |config|
        config.wsdl Colissimo.configuration.label
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { contractNumber: Colissimo.configuration.account, password: Colissimo.configuration.password }
    end

    def generateBordereauxByParcelNumbers(bordarray)
      response = { generateBordereauParcelNumberList: { parcelsNumbers: bordarray } }
      message_with_authentication = @auth.merge(response) unless response.empty?
      bordereau = @client.call :generate_bordereau_by_parcels_numbers, message: message_with_authentication

      unless bordereau.nil?

        response_body = bordereau.http.body
        final = response_body[/#{"%PDF-"}(.*)#{"%%EOF"}/m].force_encoding('UTF-8')
        File.open('Bordereau.pdf', 'w+') { |file| file.write(final) }
      end
    end
  end

  class Label

    def initialize
      @client = Savon.client do |config|
        config.wsdl Colissimo.configuration.label
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { contractNumber: Colissimo.configuration.account, password: Colissimo.configuration.password }
      @address_sender = { companyName: Colissimo.configuration.company_name,
                          line2: Colissimo.configuration.address,
                          countryCode: Colissimo.configuration.country_code,
                          city: Colissimo.configuration.city,
                          zipCode: Colissimo.configuration.zip_code,
                          mobileNumber: Colissimo.configuration.phone,
                          email: Colissimo.configuration.email }
      @depo_date = DateTime.now.strftime('%Y-%m-%d')
      @label_weight = Colissimo.configuration.weight
    end

    def generate_label(address_expeditor, output_format, service_forman, parcel_new, type)
      if type == 'retour'
        @address_sender, address_expeditor = address_expeditor, @address_sender
      end
      response = { outputFormat: output_format,
                   letter: {
                       service: service_forman,
                       parcel: parcel_new,
                       sender: {
                           address: @address_sender
                       },
                       addressee: {
                           address: address_expeditor
                       }
                   }
      }
      message_with_authentication = @auth.merge(response) unless response.empty?
      @client.call :generate_label, message: { generateLabelRequest: message_with_authentication }
    end

    def colis_aller(first_name, last_name, street, country, city, zip, email, code, format = Colissimo.configuration.format, poid = @label_weight)
      address_expeditor = { lastName: first_name,
                            firstName: last_name,
                            line2: street, countryCode: country,
                            city: city,
                            zipCode: zip,
                            email: email }
      output_format = if format == 'DPL_203'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: Colissimo.configuration.dpl_203 }
                      elsif format == 'DPL_300'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: Colissimo.configuration.dpl_300 }
                      elsif format == 'PDF'
                        i = '%PDF-'
                        j = '%%EOF'
                        { outputPrintingType: Colissimo.configuration.pdf }
                      elsif format == 'ZPL_203'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: Colissimo.configuration.zpl_203 }
                      elsif format == 'ZPL_300'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: Colissimo.configuration.zpl_300 }
                      else
                        raise ArgumentError, 'BAD FORMAT'
                      end
      service_forman = { productCode: code, depositDate: @depo_date }
      weight = { weight: poid }

      response = generate_label(address_expeditor, output_format, service_forman, weight, 'aller')
      parcel_number = response.to_s
      colis_number = parcel_number[/#{'<parcelNumber>'}(.*?)#{'</parcelNumber>'}/m, 1]
      begin
        regex = Regexp.new("#{Regexp.escape(i)}(.|\n)*#{Regexp.escape(j)}")
        etiquette = parcel_number[regex]
        etiquette_save(etiquette, colis_number, 'aller', format)
        return colis_number, etiquette
      rescue => e
        raise e
      end
    end

    def colis_retour(first_name, last_name, street, country, city, zip, email, code, format = Colissimo.configuration.format, poid = @label_weight)
      address_expeditor = { lastName: first_name,
                            firstName: last_name,
                            line2: street, countryCode: country,
                            city: city,
                            zipCode: zip,
                            email: email }
      output_format = if format == 'DPL_203'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: Colissimo.configuration.dpl_203 }
                      elsif format == 'DPL_300'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: Colissimo.configuration.dpl_300 }
                      elsif format == 'PDF'
                        i = '%PDF-'
                        j = '%%EOF'
                        { outputPrintingType: Colissimo.configuration.pdf }
                      elsif format == 'ZPL_203'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: Colissimo.configuration.zpl_203 }
                      elsif format == 'ZPL_300'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: Colissimo.configuration.zpl_300 }
                      else
                        raise ArgumentError, 'BAD FORMAT'
                      end
      service_forman = { productCode: code, depositDate: @depo_date }
      weight = { weight: poid }
      response = generate_label(address_expeditor, output_format, service_forman, weight, 'retour')
      parcel_number = response.to_s
      colis_number = parcel_number[/#{'<parcelNumber>'}(.*?)#{'</parcelNumber>'}/m, 1]
      begin
        regex = Regexp.new("#{Regexp.escape(i)}(.|\n)*#{Regexp.escape(j)}")
        etiquette = parcel_number[regex]
        etiquette_save(etiquette, colis_number, 'retour', format)
        return colis_number, etiquette
      rescue => e
        raise e
      end
    end

    def etiquette_save(etiquette, colis_number, type, format)
      if format.include?('DPL')
        # final = Base64.encode64(etiquette).delete("\n")
        extension = 'dpl'
      elsif format.include?('PDF')
        etiquette = etiquette.force_encoding('UTF-8')
        extension = 'pdf'
      elsif format.include?('ZPL')
        # final = Base64.encode64(etiquette).delete("\n")
        extension = 'zpl'
      else
        raise ArgumentError, 'BAD FORMAT'
      end
      File.open("#{type}_#{colis_number}.#{extension}", 'w+') { |file| file.write(etiquette) }
    end
  end

  class Tracking

    def initialize
      @suivis = Savon.client do |config|
        config.wsdl Colissimo.configuration.suivi
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { accountNumber: Colissimo.configuration.account,
                password: Colissimo.configuration.password }
    end

    def track(skybillNumber)
      data = { skybillNumber: skybillNumber }
      tracking = @suivis.call :track, message: @auth.merge(data) unless data.empty?
      case tracking.xpath('//errorCode').first.inner_text
      when '0'
        return tracking.xpath('//eventLibelle').first.inner_text, tracking.xpath('//eventDate').first.inner_text, tracking.xpath('//recipientCity').first.inner_text
      when '1000'
        raise StandardError, 'Erreur système (erreur technique)'
      when '202'
        raise StandardError, 'Service non autorisé pour cet identifiant'
      when '201'
        raise StandardError, 'Identifiant / mot de passe invalide'
      when '105'
        raise StandardError, 'Numéro de colis inconnu'
      when '104'
        raise StandardError, 'Numéro de colis hors plage client'
      when '103'
        raise StandardError, 'Numéro de colis datant de plus de 30 jours'
      when '101'
        raise StandardError, 'Numéro de colis invalide'
      end
    end
  end
end