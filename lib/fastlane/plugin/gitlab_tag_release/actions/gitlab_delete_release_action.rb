require 'fastlane/action'
require_relative '../helper/gitlab_tag_release_helper'

module Fastlane
  module Actions
    class GitlabDeleteReleaseAction < Action
      def self.run(params)
        UI.important "Deleting release from tag \"#{params[:tag]}\"..."

        response = Helper::GitlabTagReleaseHelper::GitlabClient.new(
          endpoint: params[:endpoint],
          private_token: params[:private_token],
          project_id: params[:project_id]
        ).delete_release_with!(tag: params[:tag])

        if response[:status] >= 300
          UI.user_error!(response[:body][:message])
        end 

        UI.success "Release from tag \"#{params[:tag]}\" deleted succesfuly"
        delete_release_body = response[:body]

        if params[:including_tag]
          other_action.gitlab_delete_tag(
            endpoint: params[:endpoint],
            private_token: params[:private_token],
            project_id: params[:project_id],
            tag: params[:tag]
          )
        end

        delete_release_body
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

          FastlaneCore::ConfigItem.new(key: :including_tag,
                               description: "If true it will delete the tag as well",
                                  optional: false,
                                      type: Boolean),
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
