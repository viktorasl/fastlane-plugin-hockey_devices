module Fastlane
  module Helper
    class HockeyDevicesHelper
      def self.run_with_defaults
        Fastlane::FastFile.new.parse("
          lane :test do
            hockey_devices(
              api_token: 'xu124huh123ug',
              public_identifier: 'as75a875fa8fas865f'
            )
          end
        ").runner.execute(:test)
      end
    end
  end
end
