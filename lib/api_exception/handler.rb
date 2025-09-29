module ApiException

  EXCEPTIONS = {
    'AuthenticationError' => {
      status: 401,
      title: 'Invalid credentials',
      detail: 'Please provide valid credentials.'
    },

    'MissingToken' => {
      status: 401,
      title: 'Missing token',
      detail: 'Please provide a token.'
    },

    'InvalidToken' => {
      status: 401,
      title: 'Invalid token',
      detail: 'Please provide a valid token.'
    },

    'ExpiredSignature' => {
      status: 401,
      title: 'Expired token',
      detail: 'Sorry, your token has expired. Please login to continue.'
    },

    'ActiveRecord::RecordNotFound' => {
      status: 404,
      title: 'Record not Found',
      detail: 'We could not find the object you were looking for.'
    },

    'ActiveRecord::RecordInvalid' => {
      status: 422,
      title: 'Validation failed'
    }
  }

  class BaseError < StandardError; end

  module Handler
    def self.included(klass)
      klass.class_eval do
        EXCEPTIONS.each do |exception_name, context|
          unless ApiException.const_defined?(exception_name)
            ApiException.const_set(exception_name, Class.new(BaseError))
            exception_name = "ApiException::#{exception_name}"
          end


          rescue_from exception_name do |exception|
            render json: {
              errors: {
                status: context[:status],
                title: context[:title],
                detail: context[:status] == 422 ? exception.record.errors.to_hash : context[:detail]
              }
            }.compact, status: context[:status]
          end
        end
      end
    end
  end
end
