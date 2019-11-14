module Tracking
  class TrackingClass

    def initialize
      @suivis = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.tracking_url
        config.encoding 'UTF-8'
        config.ssl_version :TLSv1
        config.headers 'SOAPAction' => ''
      end
      @auth = { accountNumber: ColissimoAIO.configuration.account,
                password: ColissimoAIO.configuration.password }
    end

    def track(skybillNumber)
      data = { skybillNumber: skybillNumber }
      begin
        tracking = @suivis.call :track, message: @auth.merge(data) unless data.empty?
      rescue Savon::Error => e
        puts "Error: #{e}\n"
      end
      if tracking.xpath('//errorCode').first.inner_text != '0'
        raise StandardError, tracking.xpath('//errorMessage')
      else
        [tracking.xpath('//eventLibelle').first.inner_text, tracking.xpath('//eventDate').first.inner_text, tracking.xpath('//recipientCity').first.inner_text]
      end
    end
  end
end