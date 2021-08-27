require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GitlabTagReleaseHelper
      # class methods that you define here become available in your action
      # as `Helper::GitlabTagReleaseHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the gitlab_tag_release plugin helper!")
      end
    end
  end
end
