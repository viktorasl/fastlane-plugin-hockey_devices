describe Fastlane::Actions::HockeyDevicesAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The hockey_devices plugin is working!")

      Fastlane::Actions::HockeyDevicesAction.run(nil)
    end
  end
end
