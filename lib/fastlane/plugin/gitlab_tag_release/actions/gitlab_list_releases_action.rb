require 'fastlane/action'
require_relative '../helper/gitlab_tag_release_helper'

module Fastlane
  module Actions
    class GitlabListReleasesAction < Action
      def self.run(params)
        Helper::GitlabTagReleaseHelper::GitlabClient.new(
          endpoint: params[:endpoint],
          private_token: params[:private_token],
          project_id: params[:project_id]
        ).list_releases!
      end

      def self.description
        "Simple plugin to manage gitlab releases"
      end

      def self.authors
        ["Erick Martins"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Simple plugin to manage gitlab releases"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :endpoint,
                               description: "The API endpoint URL, default: ENV['GITLAB_ENDPOINT']",
                                  env_name: "GITLAB_ENDPOINT",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :private_token,
                               description: "User's private token or OAuth2 access token. Default ENV[\"GITLAB_PRIVATE_TOKEN\"]",
                                  env_name: "GITLAB_PRIVATE_TOKEN",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :project_id,
                               description: "The id of this project, given from GitLab. Default ENV[\"GITLAB_PROJECT_ID\"]",
                                  env_name: "GITLAB_PROJECT_ID",
                                  optional: true,
                                      type: String)
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
