require "roda"
require "kvizovi/configuration/refile"

require "kvizovi/authorization"
require "kvizovi/serializer"
require "kvizovi/mailer"
require "kvizovi/mediators/account"
require "kvizovi/error"
require "kvizovi/utils"

module Kvizovi
  class App < Roda
    plugin :all_verbs
    plugin :json,
      classes: Serializer::CLASSES,
      serializer: Serializer, include_request: true
    plugin :json_parser
    plugin :symbolized_params
    plugin :error_handler
    plugin :multi_route
    plugin :heartbeat

    route do |r|
      r.multi_route

      r.post "contact" do
        Mailer.send(:contact, resource(:email)); ""
      end

      r.on Refile.mount_point do
        r.run Refile::App
      end
    end

    def current_user
      Mediators::Account.authenticate(:token, authorization.token)
    end

    def authorization
      Authorization.new(env["HTTP_AUTHORIZATION"])
    end

    def resource(name)
      Utils.resource(params, name)
    end

    def required(name)
      Utils.require_param(params, name)
    end

    error do |error|
      case error
      when Kvizovi::Error
        response.status = error.status
        error
      when Sequel::NoMatchingRow
        response.status = 404
        Kvizovi::Error::NotFound.new(:record_not_found)
      else
        raise error
      end
    end
  end
end

require "kvizovi/routes/account"
require "kvizovi/routes/quizzes"
require "kvizovi/routes/gameplays"
