require 'aws-sdk-s3'

module Fastlane
  module Actions
    class S3DownloadAction < Action
      def self.run(params)
        Actions.verify_gem!('aws-sdk-s3')

        FastlaneCore::PrintTable.print_values(
          config: params,
          title: 'Summary for AWS S3 Action',
          mask_keys: [:access_key_id, :secret_access_key]
        )

        if params[:profile]
          creds = Aws::SharedCredentials.new(profile_name: params[:profile]);
        else
          creds = Aws::Credentials.new(params[:access_key_id], params[:secret_access_key])
        end
        
        Aws.config.update({
          region: params[:region],
          credentials: creds
        })
        
        bucket_name = params[:bucket]
        file_name = params[:file_name]
        output_path = params[:output_path]

        output_directory = File.dirname(output_path)
        unless File.exist?(output_directory)
          Actions.sh("mkdir #{output_directory}", log: $verbose)
        end

        bucket_exists = false
        
        client = Aws::S3::Client.new()
        
        begin
          resp = client.head_bucket({bucket: bucket_name, use_accelerate_endpoint: false})
          bucket_exists = true
        rescue
        end

        if !bucket_exists
          UI.user_error! "Bucket '#{bucket_name}' not found, please verify bucket and credentials 🚫"
        end

        s3 = Aws::S3::Resource.new()
        begin
          object = s3.bucket(bucket_name).object(file_name)
        rescue
          UI.user_error! "Object '#{file_name}' not found, please verify file and bucket 🚫"
        end

        unless object.exists?
          UI.user_error! "Object '#{file_name}' not found, please verify file and bucket 🚫"
        end

        UI.important("Downloading file '#{bucket_name}/#{file_name}' 📥")
        object.get(response_target: output_path)
      end

      def self.description
        "Download a file from AWS S3"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :profile,
                                  env_name: "AWS_S3_PROFILE",
                               description: "The profile to use for S3 interactions",
                                  optional: true,
                             default_value: ENV['AWS_PROFILE'],
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :region,
                                  env_name: "AWS_REGION",
                               description: "AWS region (for S3) ",
                                  optional: true,
                             default_value: ENV['AWS_REGION'],
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :access_key_id,
                                  env_name: "S3_ACTIONS_ACCESS_KEY_ID",
                               description: "AWS Access Key",
                                  optional: true,
                             default_value: ENV['AWS_ACCESS_KEY_ID'],
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                  env_name: "S3_ACTIONS_SECRET_ACCESS_KEY",
                               description: "AWS Secret Access Key",
                                  optional: true,
                             default_value: ENV['AWS_SECRET_ACCESS_KEY'],
                              type: String),
          FastlaneCore::ConfigItem.new(key: :bucket,
                                  env_name: "S3_ACTIONS_BUCKET",
                               description: "S3 Bucket",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :output_path,
                                  env_name: "S3_ACTIONS_OUTPUT_PATH",
                               description: "Path to save downloaded file",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                  env_name: "S3_ACTIONS_DOWNLOAD_FILE_NAME",
                               description: "File name",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
