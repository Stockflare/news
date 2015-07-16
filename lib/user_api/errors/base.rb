class UserApi
  module Errors
    class Base < Exception

      def response
        JSON.parse(message)
      rescue
        {}
      end

    end
  end
end
