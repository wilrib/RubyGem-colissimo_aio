module Tracking
  class TrackingClass

    def initialize
      @suivis = Savon.client do |config|
        config.wsdl ColissimoAIO.configuration.suivi
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
      rescue Savon::Error => soap_fault
        puts "Error: #{soap_fault}\n"
      end
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