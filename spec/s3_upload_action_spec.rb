require 'aws-sdk-s3'

describe Fastlane::Actions::S3UploadAction do
  describe '#run' do
    aws_profile = 'dsfsdfds'
    aws_region = 'eu-central-1'

    aws_access_key = 'zxcvbnmwertyuio'
    aws_secret_access_key = 'asdfghjklwertyui'

    bucket_name = 'the_bucket'
    access_control = :private
    content_path = '/path/to/content'
    file_name = 'file_name'

    it 'uploads a file using a profile' do
      stubbed_creds = Aws::Credentials.new(aws_access_key, aws_secret_access_key)

      allow(Aws::SharedCredentials).to receive(:new)
        .with(profile_name: aws_profile)
        .and_return(stubbed_creds)

      stub_client = Aws::S3::Client.new(stub_responses: true)
      stub_resource = Aws::S3::Resource.new(client: stub_client)
      stub_bucket = Aws::S3::Bucket.new(name: bucket_name, client: stub_client)
      stub_object = Aws::S3::Object.new(bucket_name: bucket_name, key: file_name, client: stub_client)

      expect(Aws::S3::Client).to receive(:new).and_return(stub_client)
      expect(stub_client).to receive(:head_bucket).with(bucket: bucket_name, use_accelerate_endpoint: false)
      expect(Aws::S3::Resource).to receive(:new).and_return(stub_resource)
      expect(stub_resource).to receive(:bucket).with(bucket_name).and_return(stub_bucket)
      expect(stub_bucket).to receive(:object).with(file_name).and_return(stub_object)
      expect(stub_object).to receive(:upload_file).with(content_path)

      result = Fastlane::Actions::S3UploadAction.run({
        profile: aws_profile,
        region: aws_region,
        bucket: bucket_name,
        access_control: access_control,
        content_path: content_path,
        name: file_name
      })

      expect(Aws.config[:region]).to eq(aws_region)

      creds = Aws.config[:credentials]
      expect(creds.access_key_id).to eq(aws_access_key)
      expect(creds.secret_access_key).to eq(aws_secret_access_key)
    end

    it 'uploads a file using credentials' do
      stub_client = Aws::S3::Client.new(stub_responses: true)
      stub_resource = Aws::S3::Resource.new(client: stub_client)
      stub_bucket = Aws::S3::Bucket.new(name: bucket_name, client: stub_client)
      stub_object = Aws::S3::Object.new(bucket_name: bucket_name, key: file_name, client: stub_client)

      expect(Aws::S3::Client).to receive(:new).and_return(stub_client)
      expect(stub_client).to receive(:head_bucket).with(bucket: bucket_name, use_accelerate_endpoint: false)
      expect(Aws::S3::Resource).to receive(:new).and_return(stub_resource)
      expect(stub_resource).to receive(:bucket).with(bucket_name).and_return(stub_bucket)
      expect(stub_bucket).to receive(:object).with(file_name).and_return(stub_object)
      expect(stub_object).to receive(:upload_file).with(content_path)

      result = Fastlane::Actions::S3UploadAction.run({
        access_key_id: aws_access_key,
        secret_access_key: aws_secret_access_key,
        region: aws_region,
        bucket: bucket_name,
        access_control: access_control,
        content_path: content_path,
        name: file_name
      })

      expect(Aws.config[:region]).to eq(aws_region)

      creds = Aws.config[:credentials]
      expect(creds.access_key_id).to eq(aws_access_key)
      expect(creds.secret_access_key).to eq(aws_secret_access_key)
    end
  end
end
