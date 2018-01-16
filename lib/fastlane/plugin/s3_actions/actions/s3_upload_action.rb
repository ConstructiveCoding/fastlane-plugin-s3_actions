require 'aws-sdk-s3'

module Fastlane
  module Actions
    class S3UploadAction < Action
      def self.run(params)
        Actions.verify_gem!('aws-sdk-s3')

        FastlaneCore::PrintTable.print_values(
          config: params,
          title: 'Summary for AWS S3 Upload Action',
          mask_keys: [:access_key_id, :secret_access_key,  :session_token]
        )

        if params[:profile]
          creds = Aws::SharedCredentials.new(profile_name: params[:profile])
        else
          creds = Aws::Credentials.new(params[:access_key_id], params[:secret_access_key], params[:session_token])
        end

        Aws.config.update({
          region: params[:region],
          credentials: creds
        })

        client = Aws::S3::Client.new

        bucket_name = params[:bucket]
        bucket_exists = false

        begin
          client.head_bucket({ bucket: bucket_name, use_accelerate_endpoint: false })
          bucket_exists = true
        rescue
        end

        unless bucket_exists
          UI.user_error! "Bucket '#{bucket_name}' not found, please verify bucket and credentials 🚫"
        end

        file_name = params[:name] || File.basename(params[:content_path])

        s3 = Aws::S3::Resource.new(client: client)
        UI.important("Uploading file to '#{bucket_name}/#{file_name}' 📤")
        object = s3.bucket(bucket_name).object(file_name)
        object.upload_file(params[:content_path])
      end

      def self.description
        "Upload a file to AWS S3"
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
                             default_value: ENV['AWS_ACCESS_KEY_ID'],
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                  env_name: "S3_ACTIONS_SECRET_ACCESS_KEY",
                               description: "AWS Secret Access Key",
                             default_value: ENV['AWS_SECRET_ACCESS_KEY'],
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :session_token,
                                  env_name: "S3_ACTIONS_SESSION_TOKEN",
                               description: "AWS Session Token",
                                  optional: true,
                             default_value: ENV['AWS_SESSION_TOKEN'],
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :bucket,
                                  env_name: "S3_ACTIONS_BUCKET",
                               description: "S3 Bucket",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :access_control,
                                  env_name: "S3_ACTIONS_UPLOAD_ACCESS_CONTROL",
                               description: "File ACL: :public_read or :private",
                                  optional: false,
                             default_value: :private,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :content_path,
                                  env_name: "S3_ACTIONS_UPLOAD_CONTENT_PATH",
                               description: "Path for file to upload",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                              if value.nil? || value.empty?
                                                UI.user_error!("No content path for S3_upload action given, pass using `content_path: 'path/to/file.txt'`")
                                              elsif File.file?(value) == false
                                                UI.user_error!("File for path '#{value}' not found")
                                              end
                                            end),
          FastlaneCore::ConfigItem.new(key: :name,
                                  env_name: "S3_ACTIONS_FILE_NAME",
                               description: "File name",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
