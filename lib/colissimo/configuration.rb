module ColissimoAIO
  class Configuration
    attr_accessor :account, :password, :weight, :company_name,
                  :address, :country_code, :city, :zip_code, :phone,
                  :email, :format, :dpl_203, :dpl_300, :zpl_203, :zpl_300,
                  :pdf, :relay_url, :label_url, :tracking_url, :signed,
                  :international, :raw_format, :local_path

    def initialize
      @account = nil
      @password = nil
      @weight = nil
      @company_name = nil
      @address = nil
      @country_code = nil
      @city = nil
      @zip_code = nil
      @phone = nil
      @email = nil
      @format = nil
      @dpl_203 = 'DPL_10x15_203dpi'
      @dpl_300 = 'DPL_10x15_300dpi'
      @zpl_203 = 'ZPL_10x15_203dpi'
      @zpl_300 = 'ZPL_10x15_300dpi'
      @pdf = 'PDF_A4_300dpi'
      @relay_url = 'https://ws.colissimo.fr/pointretrait-ws-cxf/PointRetraitServiceWS/2.0?wsdl'
      @label_url = 'https://ws.colissimo.fr/sls-ws/SlsServiceWS?wsdl'
      @tracking_url = 'https://www.coliposte.fr/tracking-chargeur-cxf/TrackingServiceWS?wsdl'
      @signed ||= false
      @international ||= false
      @raw_format ||= false
      @local_path ||= '/colissimo_label'
    end
  end
end