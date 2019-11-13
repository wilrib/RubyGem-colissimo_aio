module Label
  class LabelClass

    def initialize
      @client = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.label_url
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { contractNumber: ColissimoAIO.configuration.account, password: ColissimoAIO.configuration.password }
      @address_sender = { companyName: ColissimoAIO.configuration.company_name,
                          line2: ColissimoAIO.configuration.address,
                          countryCode: ColissimoAIO.configuration.country_code,
                          city: ColissimoAIO.configuration.city,
                          zipCode: ColissimoAIO.configuration.zip_code,
                          mobileNumber: ColissimoAIO.configuration.phone,
                          email: ColissimoAIO.configuration.email }
      @depo_date = DateTime.now.strftime('%Y-%m-%d')
      @label_weight = ColissimoAIO.configuration.weight
      @signed = ColissimoAIO.configuration.signed
      @format = ColissimoAIO.configuration.format
      @international = ColissimoAIO.configuration.international
      @raw_format = ColissimoAIO.configuration.raw_format
      @local_path = ColissimoAIO.configuration.local_path
    end

    def generate_label(address_expeditor, output_format, service_forman, parcel_new)
      if caller_locations(1, 1)[0].label == 'return_label'
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
      begin
        response = @client.call :generate_label, message: { generateLabelRequest: message_with_authentication }
      rescue Savon::Error => soap_fault
        puts "Error: #{soap_fault}\n"
      end
      response_to_s = response.to_s
      if response_to_s[/#{'<id>'}(.*?)#{'</id>'}/m, 1] != '0'
        raise StandardError, (response_to_s[/#{'<messageContent>'}(.*?)#{'</messageContent>'}/m, 1]).to_s
      else
        response_to_s
      end
    end

    def shipping_label(hash)
      address_expeditor = { lastName: hash[:first_name],
                            firstName: hash[:last_name],
                            line2: hash[:street], countryCode: hash[:country],
                            city: hash[:city],
                            zipCode: hash[:zip],
                            mobileNumber: hash[:phone],
                            email: hash[:email] }
      output_for = output
      output_format = output_for[0]
      i = output_for[1]
      j = output_for[2]
      service_forman = if @signed
                         { productCode: 'DOS', depositDate: @depo_date }
                       else
                         { productCode: 'DOM', depositDate: @depo_date }
                       end
      weight = { weight: @label_weight }
      response = generate_label(address_expeditor, output_format, service_forman, weight)
      parcel_number = response.to_s
      colis_number = parcel_number[/#{'<parcelNumber>'}(.*?)#{'</parcelNumber>'}/m, 1]
      begin
        regex = Regexp.new("#{Regexp.escape(i)}(.|\n)*#{Regexp.escape(j)}")
        etiquette = parcel_number[regex]
        if @raw_format
          return colis_number, etiquette
        else
          save = Save::SaveClass.new(etiquette, colis_number, @format)
          save.saving
          return colis_number
        end
      rescue StandardError => e
        raise e
      end
    end

    def return_label(hash)
      address_expeditor = { lastName: hash[:first_name],
                            firstName: hash[:last_name],
                            line2: hash[:street], countryCode: hash[:country],
                            city: hash[:city],
                            zipCode: hash[:zip],
                            mobileNumber: hash[:phone],
                            email: hash[:email] }
      output_for = output
      output_format = output_for[0]
      i = output_for[1]
      j = output_for[2]
      service_forman = if @international
                         { productCode: 'CORI', depositDate: @depo_date }
                       else
                         { productCode: 'CORE', depositDate: @depo_date }
                       end
      weight = { weight: @label_weight }
      response = generate_label(address_expeditor, output_format, service_forman, weight)
      parcel_number = response.to_s
      colis_number = parcel_number[/#{'<parcelNumber>'}(.*?)#{'</parcelNumber>'}/m, 1]
      begin
        regex = Regexp.new("#{Regexp.escape(i)}(.|\n)*#{Regexp.escape(j)}")
        etiquette = parcel_number[regex]
        if @raw_format
          return colis_number, etiquette
        else
          save = Save::SaveClass.new(etiquette, colis_number, @format)
          save.saving
          return colis_number
        end
      rescue StandardError => e
        raise e
      end
    end

    def relay_point_label(hash)
      address_expeditor = { lastName: hash[:first_name],
                            firstName: hash[:last_name],
                            line2: hash[:street], countryCode: hash[:country],
                            city: hash[:city],
                            zipCode: hash[:zip],
                            mobileNumber: hash[:phone],
                            email: hash[:email] }
      output_for = output
      output_format = output_for[0]
      i = output_for[1]
      j = output_for[2]
      service_forman = { productCode: 'BPR', depositDate: @depo_date }.merge(commercialName: ColissimoAIO.configuration.company_name)
      weight = { weight: @label_weight }.merge(pickupLocationId: hash[:relay_id])
      response = generate_label(address_expeditor, output_format, service_forman, weight)
      parcel_number = response.to_s
      colis_number = parcel_number[/#{'<parcelNumber>'}(.*?)#{'</parcelNumber>'}/m, 1]
      begin
        regex = Regexp.new("#{Regexp.escape(i)}(.|\n)*#{Regexp.escape(j)}")
        etiquette = parcel_number[regex]
        if @raw_format
          return colis_number, etiquette
        else
          save = Save::SaveClass.new(etiquette, colis_number, @format)
          save.saving
          return colis_number
        end
      rescue StandardError => e
        raise e
      end
    end

    def output
      output_format = if @format == 'DPL_203'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: ColissimoAIO.configuration.dpl_203 }
                      elsif @format == 'DPL_300'
                        i = "\x02n"
                        j = "E\r"
                        { outputPrintingType: ColissimoAIO.configuration.dpl_300 }
                      elsif @format == 'PDF'
                        i = '%PDF-'
                        j = '%%EOF'
                        { outputPrintingType: ColissimoAIO.configuration.pdf }
                      elsif @format == 'ZPL_203'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: ColissimoAIO.configuration.zpl_203 }
                      elsif @format == 'ZPL_300'
                        i = '^XA'
                        j = '^XZ'
                        { outputPrintingType: ColissimoAIO.configuration.zpl_300 }
                      else
                        raise ArgumentError, 'BAD FORMAT'
                      end
      [output_format, i, j]
    end
  end
end