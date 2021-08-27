require 'fastlane_core/ui/ui'
require 'faraday'
require 'uri'

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

      class GitlabService
        def initialize(options = {})
          @private_token = options[:private_token]
          @project_id = options[:project_id]

          @endpoint = URI.join(options[:endpoint], "projects/#{options[:project_id]}/").to_s
        end

        def get(path:, paramenters: {}, headers: {})
          url = get_url(path)
          response = Faraday.get(url, paramenters, merge_headers(headers: headers))

          JSON.parse(response.body, symbolize_names: true)
        end

        def post(path:, body: {}, headers: {})
          url = get_url(path)
          parse_response Faraday.post(url, body.to_json, merge_headers(headers: headers))
        end

        def put(path:, body: {}, headers: {})
          url = get_url(path)
          parse_response Faraday.put(url, body.to_json, merge_headers(headers: headers))
        end

        def delete!(path:, paramenters: {}, headers: {})
          url = get_url(path)
          response = Faraday.delete(url, paramenters, merge_headers(headers: headers))
          parse_response response
        end

        private

        def parse_response(response)
          body = {}
          if response.body.is_a?(String)
            begin
              body = JSON.parse(response.body.strip, symbolize_names: true)
            rescue => ex
              UI.important "Could not convert json response into hash"
              UI.error ex.message
              body = response.body
            end
          else
            body = response.body
          end

          {
            :status => response.status,
            :body => body
          }
        end

        def get_url(path)
          URI.join(@endpoint, path).to_s
        end

        def merge_headers(headers: {})
          full_headers = { 
            "PRIVATE-TOKEN" => @private_token, 
            "Content-Type" => "application/json" 
          }
          full_headers.merge headers
          
          full_headers
        end
      end


      class GitlabClient
        def initialize(options = {})
          @service = Helper::GitlabTagReleaseHelper::GitlabService.new(options)
        end

        def list_releases!
          @service.get(path: 'releases/')
        end

        def get_release_by(tag:)
          @service.get(path: "releases/#{tag}")
        end

        def create_release(tag:, ref:, name: "", description: "", milestones: nil, assets_links: nil, released_at: nil)
          @service.post(
            path: 'releases/', 
            body: {
              :tag_name => tag,
              :ref => ref,
              :name => name,
              :description => description,
              :milestones => milestones,
              :assets => {
                :links => assets_links
              },
              :released_at => released_at
            }.compact
          )
        end

        def update_release(tag:, name: "", description: "", milestones: nil, released_at: nil)
          @service.put(
            path: "releases/#{tag}/", 
            body: {
              :name => name,
              :description => description,
              :milestones => milestones,
              :released_at => released_at
            }.compact
          )
        end

        def collect_release_evidence(tag:)
          @service.post(path: "releases/#{tag}/evidence")
        end

        def delete_release_with!(tag:)
          @service.delete!(path: "releases/#{tag}")
        end

        def delete!(tag:)
          @service.delete!(path: "repository/tags/#{tag}")
        end
      end
    end
  end
end
