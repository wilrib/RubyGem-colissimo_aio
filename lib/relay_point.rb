module RelayPoint
  class RelayPointClass

    def initialize
      @client = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.retrait
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { accountNumber: ColissimoAIO.configuration.account,
                password: ColissimoAIO.configuration.password }
    end

    def find_relay_point_informations(retrait_id)
      data = { id: retrait_id, date: DateTime.now.strftime('%d/%m/%Y') }
      begin
        response = @client.call :find_point_retrait_acheminement_by_id, message: @auth.merge(data) unless data.empty?
      rescue Savon::Error => soap_fault
        puts "Error: #{soap_fault}\n"
      end
      response_to_s = response.to_s
      if response_to_s[/#{'<errorCode>'}(.*?)#{'</errorCode>'}/m, 1] != '0'
        raise StandardError, (response_to_s[/#{'<errorMessage>'}(.*?)#{'</errorMessage>'}/m, 1]).to_s
      else
        response_to_s
      end
    end
  end
end