describe Fastlane::Actions::GitlabTagReleaseAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gitlab_tag_release plugin is working!")

      Fastlane::Actions::GitlabTagReleaseAction.run(nil)
    end
  end
end
