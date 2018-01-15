require 'aws-sdk-s3'

describe Fastlane::Actions::S3CheckFileAction do
  describe '#run' do
    aws_access_key = 'zxcvbnmwertyuio'
    aws_secret_access_key = 'asdfghjklwertyui'

    bucket_name = 'the_bucket'
    file_name = 'file_name'

    it 'check a file exists in a bucket using credentials' do
      stub_client = Aws::S3::Client.new(stub_responses: true)

      expect(Aws::S3::Client).to receive(:new).and_return(stub_client)
      expect(stub_client).to receive(:head_object).with(bucket: bucket_name, key: file_name)

      result = Fastlane::Actions::S3CheckFileAction.run({
        access_key_id: aws_access_key,
        secret_access_key: aws_secret_access_key,
        bucket: bucket_name,
        file_name: file_name
      })

      expect(result).to be(true)
    end

    it 'check a file exists in a bucket using credentials when the file is not there' do
      stub_client = Aws::S3::Client.new(stub_responses: true)

      expect(Aws::S3::Client).to receive(:new).and_return(stub_client)
      expect(stub_client).to receive(:head_object).with(bucket: bucket_name, key: file_name).and_throw('Aws::S3::Errors::NotFound')

      result = Fastlane::Actions::S3CheckFileAction.run({
        access_key_id: aws_access_key,
        secret_access_key: aws_secret_access_key,
        bucket: bucket_name,
        file_name: file_name
      })

      expect(result).to be(false)
    end
  end
end
