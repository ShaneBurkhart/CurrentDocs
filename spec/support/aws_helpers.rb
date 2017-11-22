module AWSHelper
  def mock_s3_object
    bucket_array_double = double()
    bucket_double = double(AWS::S3::Bucket)
    object_array_double = double()
    object_double = double(AWS::S3::S3Object)

    # LOL #works
    allow_any_instance_of(AWS::S3).to receive(:buckets)
      .and_return(bucket_array_double)
    allow(bucket_array_double).to receive(:[]).and_return(bucket_double)
    allow(bucket_double).to receive(:objects)
      .and_return(object_array_double)
    allow(object_array_double).to receive(:[]).and_return(object_double)

    return object_double
  end
end

