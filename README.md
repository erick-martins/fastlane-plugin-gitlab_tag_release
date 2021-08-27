# gitlab_tag_release plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-gitlab_tag_release)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/erick-martins/fastlane-plugin-gitlab_tag_release/blob/master/LICENSE)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-gitlab_tag_release.svg)](https://badge.fury.io/rb/fastlane-plugin-gitlab_tag_release)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-gitlab_tag_release`, add it to your project by running:

```bash
fastlane add_plugin gitlab_tag_release
```

## About gitlab_tag_release

Manages gitlab releases

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.
```ruby
lane :test do
  commit = last_git_commit
  assets_links = [{ :name => "hoge", :url => "https://google.com", :filepath => "/binaries/linux-amd64", :link_type => "other" }]
  
  # Lists all releases
  gitlab_list_releases(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
  )

  # Gets a specific release
  gitlab_get_releases(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.0"                               # [Required] String: The name of the tag. (ex: 1.0)
  )

  # Creates a release
  # Read more about these parameters here: https://docs.gitlab.com/ee/api/releases/#create-a-release
  gitlab_create_release(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.0",                              # [Required] String: The name of the tag. (ex: 1.0)
    ref: commit[:commit_hash],                   # [Optional] String: If a tag specified in tag_name doesn’t exist, the release is created from ref and tagged with tag_name. It can be a commit SHA, another tag name, or a branch name
    name: "New release",                         # [Optional] String: The release name
    description: "Super nice release",           # [Optional] String: The description of the release. You can use Markdown
    milestones: ["v1.0", "v1.0-rc"],             # [Optional] String: The title of each milestone the release is associated with. GitLab Premium customers can specify group milestones
    assets_links: assets_links                   # [Optional] String: An array of assets links. Format { "name": String, "url": String, "filepath": String, "link_type": String }
  )

  # Collects evidence of a release
  gitlab_collect_release_evidence(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.0"
  )

  # Updates a release
  gitlab_update_release(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.0",                              # [Required] String: The name of the tag. (ex: 1.0)
    name: "New release updated", 
    description: "Super nice release updated", 
    milestones: ["v1.0", "v1.0-rc"], 
  )

  # Deletes a release
  gitlab_delete_release(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.1",                              # [Required] String: The name of the tag. (ex: 1.0)
    including_tag: true                          # [Optional] Boolean: If true it will delete the tag as well (Default: false)
  )

  # Deletes a tag
  gitlab_delete_tag(
    endpoint: ENV["GITLAB_ENDPOINT"],            # [Optional] String: The API endpoint URL (default: ENV['GITLAB_ENDPOINT'])
    private_token: ENV["GITLAB_PRIVATE_TOKEN"],  # [Optional] String: User's private token or OAuth2 access token (default: ENV['GITLAB_PRIVATE_TOKEN'])
    project_id: ENV["GITLAB_PROJECT_ID"],        # [Optional] String: The id of this project, given from GitLab. (default: ENV['GITLAB_PROJECT_ID'])
    tag: "v2.69.1"                               # [Required] String: The name of the tag. (ex: 1.0)
  )
end
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```bash
rake
```

To automatically fix many of the styling issues, use
```bash
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
