module Save
  class SaveClass

    def initialize(raw, label_number, format)
      @raw = raw
      @label_number = label_number
      @format = format
      @local_path = ColissimoAIO.configuration.local_path
    end

    def saving
      if caller_locations(1, 1)[0].label == 'response_parsing'
        raw = @raw.force_encoding('UTF-8')
        basename = "BORDEREAU_#{@label_number}.pdf"
      else
        if @format.include?('DPL')
          raw = @raw
          extension = 'dpl'
        elsif @format.include?('PDF')
          raw = @raw.force_encoding('UTF-8')
          extension = 'pdf'
        elsif @format.include?('ZPL')
          raw = @raw
          extension = 'zpl'
        else
          raise ArgumentError, 'BAD FORMAT'
        end
        case caller_locations(1, 1)[0].label
        when 'shipping_label'
          basename = "ALLER_#{@label_number}.#{extension}"
        when 'return_label'
          basename = "RETOUR_#{@label_number}.#{extension}"
        when 'relay_point_label'
          basename = "RELAY_#{@label_number}.#{extension}"
        else
          raise StandardError, 'BAD METHOD'
        end
      end
      dirname = File.join(Dir.pwd, @local_path)
      FileUtils.mkpath dirname unless File.exist?(dirname)
      filename = File.join(dirname, basename)
      File.open(filename, 'a') do |file|
        file.write(raw)
      end
    end
  end
end