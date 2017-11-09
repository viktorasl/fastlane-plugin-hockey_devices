module Fastlane
  module Actions
    class HockeyDevicesAction < Action
      def self.run(params)
        UI.message("The hockey_devices plugin is working!")
      end

      def self.description
        "Retrieves a list of devices from Hockey which can then be used with Match"
      end

      def self.authors
        ["viktoras"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Retrieves all/provisioned/unprovisioned list of devies from Hockey. List then can be used either to register new devices using Match etc."
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "HOCKEY_DEVICES_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
