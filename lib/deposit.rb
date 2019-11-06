module Deposit
  class DepositClass

    def initialize
      @client = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.label
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { contractNumber: ColissimoAIO.configuration.account, password: ColissimoAIO.configuration.password }
    end

    def generateBordereauxByParcelNumbers(bordarray)
      response = { generateBordereauParcelNumberList: { parcelsNumbers: bordarray } }
      message_with_authentication = @auth.merge(response) unless response.empty?
      begin
        response = @client.call :generate_bordereau_by_parcels_numbers, message: message_with_authentication
      rescue Savon::Error => soap_fault
        puts "Error: #{soap_fault}\n"
      end
      response_to_s = response.to_s
      if response_to_s[/#{'<id>'}(.*?)#{'</id>'}/m, 1] != '0'
        raise StandardError, (response_to_s[/#{'<messageContent>'}(.*?)#{'</messageContent>'}/m, 1]).to_s
      else
        response_body = response.http.body
        final = response_body[/#{"%PDF-"}(.*)#{"%%EOF"}/m].force_encoding('UTF-8')
        File.open('Bordereau.pdf', 'w+') { |file| file.write(final) }
      end
    end
  end
end