require 'faraday'
require 'multi_json'

module Snorkeler
  module Response
    class ParseSnorkleResponse < Faraday::Response::Middleware

      def parse(body)

        case body
          # WTF is this matching exactly? -JD
        when /\A^\s*$\z/, nil
          nil
        when /INSERTED/
          {message: "INSERTED"}
        when /ERROR/
          {message: "ERROR"}
        else
          {message: "NORESPONSE"}
        end
      end

      def on_complete(env)
        if respond_to?(:parse)
          env[:body] = parse(env[:body]) unless [204, 301, 302, 304].include?(env[:status])
        end
      end
    end
  end
end