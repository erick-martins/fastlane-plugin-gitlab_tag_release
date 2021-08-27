require 'fastlane/action'
require_relative '../helper/gitlab_tag_release_helper'

module Fastlane
  module Actions
    class GitlabUpdateReleaseAction < Action
      def self.run(params)
        response = Helper::GitlabTagReleaseHelper::GitlabClient.new(
          endpoint: params[:endpoint],
          private_token: params[:private_token],
          project_id: params[:project_id]
        ).update_release(
          tag: params[:tag],
          name: params[:name],
          description: params[:description],
          milestones: params[:milestones],
          released_at: params[:released_at],
        )

        if response[:status] >= 300
          UI.user_error!(response[:body][:message])
        end 

        response[:body]
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
                               description: "User's private token or OAuth2 access token",
                                  env_name: "GITLAB_PRIVATE_TOKEN",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :project_id,
                               description: "The id of this project, given from GitLab. Default ENV[\"GITLAB_PROJECT_ID\"]",
                                  env_name: "GITLAB_PROJECT_ID",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :tag,
                               description: "The name of the tag. (ex: 1.0)",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :name,
                               description: "The release name",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :description,
                               description: "The description of the release. You can use Markdown",
                                  optional: true,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :milestones,
                               description: "The title of each milestone the release is associated with. GitLab Premium customers can specify group milestones",
                                  optional: true,
                                      type: Array),

          FastlaneCore::ConfigItem.new(key: :released_at,
                               description: "The date when the release is/was ready. Defaults to the current time. Expected in ISO 8601 format (2019-03-15T08:00:00Z)",
                                  optional: true,
                                      type: String),
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
