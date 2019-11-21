module Deposit
  class DepositClass

    def initialize
      @client = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.label_url
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @local_path = ColissimoAIO.configuration.local_path
      @raw_format = ColissimoAIO.configuration.raw_format
      @auth = { contractNumber: ColissimoAIO.configuration.account, password: ColissimoAIO.configuration.password }
    end

    def generate_deposit_by_parcel(bordarray)
      response = { generateBordereauParcelNumberList: { parcelsNumbers: bordarray } }
      message_with_authentication = @auth.merge(response) unless response.empty?
      begin
        response = @client.call :generate_bordereau_by_parcels_numbers, message: message_with_authentication
      rescue Savon::Error => e
        puts "Error: #{e}\n"
      end
      response_parsing(response)
    end

    def generate_deposit_by_id(id)
      response = { bordereauNumber: id }
      message_with_authentication = @auth.merge(response) unless response.empty?
      begin
        response = @client.call :get_bordereau_by_number, message: message_with_authentication
      rescue Savon::Error => e
        puts "Error: #{e}\n"
      end
      response_parsing(response)
    end

    def response_parsing(response)
      response_to_s = response.to_s
      if response_to_s[/#{'<id>'}(.*?)#{'</id>'}/m, 1] != '0'
        raise StandardError, (response_to_s[/#{'<messageContent>'}(.*?)#{'</messageContent>'}/m, 1]).to_s
      else
        begin
          response_body = response.http.body
          final = response_body[/#{"%PDF-"}(.*)#{"%%EOF"}/m]
          deposit_number = (response_to_s[/#{'<bordereauNumber>'}(.*?)#{'</bordereauNumber>'}/m, 1]).to_s
          if @raw_format
            return deposit_number, final
          else
            save = Save::SaveClass.new(final, deposit_number, nil)
            save.saving
            return deposit_number
          end
        rescue StandardError => e
          raise e
        end
      end
    end
  end
end