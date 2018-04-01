# frozen_string_literal: true
require "stringio"
require "aws-sdk"

module SidekiqProfilingMiddleware
  class S3
    class Object < StringIO
      def initialize(bucket:, key:)
        @bucket = bucket
        @key = key

        super()
      end

      def upload
        rewind

        S3.client.put_object(bucket: bucket, key: key, body: self)
      end

      private

      attr_reader :bucket, :key
    end

    def self.client=(client)
      @client = client
    end

    def self.client
      @client ||= Aws::S3::Client.new
    end
  end
end
