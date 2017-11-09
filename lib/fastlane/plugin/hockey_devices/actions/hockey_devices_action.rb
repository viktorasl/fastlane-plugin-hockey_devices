module Fastlane
  module Actions
    class HockeyDevicesAction < Action
      def self.connection(options)
        require 'faraday'
        require 'faraday_middleware'

        base_url = "https://rink.hockeyapp.net"
        foptions = {
          url: base_url
        }
        Faraday.new(foptions) do |builder|
          builder.request :url_encoded
          builder.response :json, content_type: /\bjson$/
          builder.adapter :net_http
        end
      end

      def self.get_devices(api_token, options)
        connection = self.connection(options)
        app_id = options.delete(:public_identifier)
        only_unprovisioned = options.delete(:unprovisioned) ? 1 : 0

        return connection.get do |req|
          req.url("/api/2/apps/#{app_id}/devices?unprovisioned=#{only_unprovisioned}")
          req.headers['X-HockeyAppToken'] = api_token
        end
      end

      def self.run(options)
        values = options.values
        api_token = values.delete(:api_token)

        values.delete_if { |k, v| v.nil? }
        
        response = self.get_devices(api_token, values)

        case response.status
        when 200...300
          devices = response.body['devices']
          devices_hash = devices.map { |d| [d['name'], d['udid']] }.to_h
          UI.message("successfully got devices list")
          devices_hash
        else
          UI.user_error!("Error trying to get devices list:  #{response.status} - #{response.body}")
        end
      end

      def self.description
        "Retrieves a list of devices from Hockey which can then be used with Match"
      end

      def self.authors
        ["viktorasl"]
      end

      def self.return_value
        "The hash of devices"
      end

      def self.details
        "Retrieves all or unprovisioned list of devices from Hockey. List then can be used either to register new devices using Match etc."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_HOCKEY_API_TOKEN",
                                       sensitive: true,
                                       description: "API Token for Hockey Access",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :public_identifier,
                                      env_name: "FL_HOCKEY_PUBLIC_IDENTIFIER",
                                      description: "App id of the app you are targeting",
                                      optional: false),
          FastlaneCore::ConfigItem.new(key: :unprovisioned,
                                      env_name: "HOCKEY_DEVICES_UNPROVISIONED",
                                      description: "Only retrieve unprovisioned devices list",
                                      optional: true,
                                      is_string: false,
                                      default_value: true)
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'hockey_devices(
            api_token: "XXXXYYYYZZZZWWWW",
            public_identifier: "aaaabbbbccccdddd"
          )'
        ]
      end
    end
  end
end
