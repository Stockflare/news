class UserApi
  module Errors

    extend ActiveSupport::Autoload

    autoload :Base
    autoload :ServerError
    autoload :BadRequest
    autoload :MfaEnforced
    autoload :UserNotFound

    def self.determine_from(response)
      case response.status
      when 401
        if(JSON.parse(response.body)['error'] == 'mfa_enforced')
          raise MfaEnforced.new response.body
        else
          raise UserNotFound.new response.body
        end
      when 422 then raise BadRequest.new response.body
      else raise ServerError.new response.body
      end
    end

  end
end
