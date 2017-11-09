describe Fastlane::Actions::HockeyDevicesAction do
  describe '#run' do
    let(:connection) { double :connection }
    let(:response) { double :response }
    let(:req) { double :req }

    before do
      allow(Faraday).to receive(:new).with({:url => "https://rink.hockeyapp.net"}).and_return(connection)
      allow(connection).to receive(:get).and_yield(req).and_return(response)
    end

    describe 'configures connection currectly' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return({'devices' => []})
      end

      it 'with correct headers' do
        headers = {}
        allow(req).to receive(:url)
        expect(req).to receive(:headers).and_return(headers)
        Fastlane::Helper::HockeyDevicesHelper.run_with_defaults
        expect(headers).to eq({'X-HockeyAppToken' => 'xu124huh123ug'})
      end

      it 'for provisioned devices' do
        expect(req).to receive(:url).with("/api/2/apps/a78sf8aas986asf/devices?unprovisioned=0")
        expect(req).to receive(:headers).and_return({})
        Fastlane::FastFile.new.parse("
          lane :test do
            hockey_devices(
              api_token: 'xu124huh123ug',
              public_identifier: 'a78sf8aas986asf',
              unprovisioned: false
            )
          end
        ").runner.execute(:test)
      end

      it 'for unprovisioned devices' do
        expect(req).to receive(:url).with("/api/2/apps/hxcv89safa9as6f98/devices?unprovisioned=1")
        expect(req).to receive(:headers).and_return({})
        Fastlane::FastFile.new.parse("
          lane :test do
            hockey_devices(
              api_token: 'xu124huh123ug',
              public_identifier: 'hxcv89safa9as6f98',
              unprovisioned: true
            )
          end
        ").runner.execute(:test)
      end

      it 'for default provisioning devices list' do
        expect(req).to receive(:url).with("/api/2/apps/as75a875fa8fas865f/devices?unprovisioned=1")
        expect(req).to receive(:headers).and_return({})
        Fastlane::Helper::HockeyDevicesHelper.run_with_defaults
      end
    end

    it 'raises an error if request not successful' do
      allow(response).to receive(:status).and_return(500)
      allow(response).to receive(:body).and_return("Error info")

      allow(req).to receive(:url)
      allow(req).to receive(:headers).and_return({})

      expect(Fastlane::UI).to receive(:user_error!).with("Error trying to get devices list:  500 - Error info")
      Fastlane::Helper::HockeyDevicesHelper.run_with_defaults
    end

    describe 'retrieved devices list' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(req).to receive(:url)
        allow(req).to receive(:headers).and_return({})
      end

      it 'is handled if flat' do
        allow(response).to receive(:body).and_return({
          "devices" => [
            {"name" => "Device name", "udid" => "12697asd7692196"}
          ]
        })
        devices_hash = Fastlane::Helper::HockeyDevicesHelper.run_with_defaults
        expect(devices_hash).to eq({
          "Device name" => "12697asd7692196"
        })
      end

      it 'is handled if multiple devices have same name' do
        allow(response).to receive(:body).and_return({
          "devices" => [
            {"name" => "John iPhone 7", "udid" => "12697asd7692196"},
            {"name" => "John iPhone 7", "udid" => "jk2h14679a9sd89"},
            {"name" => "Cristi iPhone 6", "udid" => "91729saa78s6ad"}
          ]
        })
        devices_hash = Fastlane::Helper::HockeyDevicesHelper.run_with_defaults
        expect(devices_hash).to eq({
          "John iPhone 7" => "12697asd7692196",
          "John iPhone 7 (2)" => "jk2h14679a9sd89",
          "Cristi iPhone 6" => "91729saa78s6ad"
        })
      end
    end
  end
end
