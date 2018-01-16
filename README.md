# s3_actions plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-s3_actions)
[![Twitter: @fsaragoca](https://img.shields.io/badge/contact-@fsaragoca-blue.svg?style=flat)](https://twitter.com/fsaragoca)

[![CircleCI](https://circleci.com/gh/fsaragoca/fastlane-plugin-s3_actions.svg?style=svg)](https://circleci.com/gh/fsaragoca/fastlane-plugin-s3_actions)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-s3_actions`, add it to your project by running:

```bash
fastlane add_plugin s3_actions
```

## About s3_actions

Download and upload files from AWS S3. This plugin uses [s3](https://github.com/qoobaa/s3) library for accessing AWS S3.

### Actions

#### s3_check_file

Check if file exists in AWS S3.

| Option | Description |
|--------|--------------|
| access_key_id | The Access Key ID used to sign requests made to AWS |
| secret_access_key | The Secret Access Key used to sign requests made to AWS |
| bucket | The AWS S3 bucket |
| file_name | The file to search the bucket for |

#### s3_download

Download a file from AWS S3.

| Option | Environment Variable | Default Value | Description |
|--------|----------------------|---------------|-------------|
| aws_profile | AWS_KMS_PROFILE | ENV['AWS_PROFILE'] | The profile to use from the user's `~/.aws/credentials` file. If specified, overrides aws_access_key and aws_secret_access_key. |
| aws_access_key | AWS_ACCESS_KEY_ID | ENV['AWS_ACCESS_KEY_ID'] | The Access Key ID used to sign requests made to AWS |
| aws_secret_access_key | AWS_SECRET_ACCESS_KEY | ENV['AWS_SECRET_ACCESS_KEY'] | The Secret Access Key used to sign requests made to AWS |
| aws_session_token | AWS_SESSION_TOKEN | ENV['AWS_SESSION_TOKEN'] | The Session Token used to sign requests made to AWS |
| aws_region | AWS_REGION | ENV['AWS_REGION'] | The AWS Region where AWS resources will be accessed |
| bucket | | | The AWS S3 bucket |
| output_path | | | The path to save downloaded file to |
| file_name | | | The file to download from the AWS S3 bucket |

#### s3_upload

Upload a file from AWS S3.

| Option | Environment Variable | Default Value | Description |
|--------|----------------------|---------------|-------------|
| aws_profile | AWS_KMS_PROFILE | ENV['AWS_PROFILE'] | The profile to use from the user's `~/.aws/credentials` file. If specified, overrides aws_access_key and aws_secret_access_key. |
| aws_access_key | AWS_ACCESS_KEY_ID | ENV['AWS_ACCESS_KEY_ID'] | The Access Key ID used to sign requests made to AWS |
| aws_secret_access_key | AWS_SECRET_ACCESS_KEY | ENV['AWS_SECRET_ACCESS_KEY'] | The Secret Access Key used to sign requests made to AWS |
| aws_session_token | AWS_SESSION_TOKEN | ENV['AWS_SESSION_TOKEN'] | The Session Token used to sign requests made to AWS |
| aws_region | AWS_REGION | ENV['AWS_REGION'] | The AWS Region where AWS resources will be accessed |
| bucket | | | The AWS S3 bucket |
| access_control | | :private | File ACL: :public_read or :private |
| content_path | | | The path to the file to upload to the AWS S3 bucket |
| file_name | | | The file name to use for file uploaded to the AWS S3 bucket |

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
