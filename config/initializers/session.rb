# We keep this patch until rails enables support
# for setting cross subdomain cookies for memcached session store
#
# see pull request https://github.com/rails/rails/pull/11210
module ActionDispatch
  module Session
    class MemCacheStore
    private

      def set_cookie(env, session_id, cookie)
        request = ActionDispatch::Request.new(env)
        request.cookie_jar[key] = cookie
      end
    end
  end
end


# Here the error is revealed
module Rack
  module Session
    module Abstract
      class ID
        private
        def commit_session(env, status, headers, body)
          session = env[ENV_SESSION_KEY]

          options = session.options

          if options[:drop] || options[:renew]
            session_id = destroy_session(env, session.id || generate_sid, options)
            return [status, headers, body] unless session_id
          end

          return [status, headers, body] unless commit_session?(env, session, options)

          session.send(:load!) unless loaded_session?(session)

          puts "1 > #{session_id.inspect}"
          puts "1a > #{session.class.name} #{session.id.inspect}"
          puts "1b > #{env[ENV_SESSION_OPTIONS_KEY][:id].inspect}"

          session_id ||= session.id

          puts "2 > #{session_id.inspect}"

          session_data = session.to_hash.delete_if { |k,v| v.nil? }

          if not data = set_session(env, session_id, session_data, options)
            env["rack.errors"].puts("Warning! #{self.class.name} failed to save session. Content dropped.")
          elsif options[:defer] and not options[:renew]
            env["rack.errors"].puts("Defering cookie for #{session_id}") if $VERBOSE
          else
            cookie = Hash.new
            cookie[:value] = data
            cookie[:expires] = Time.now + options[:expire_after] if options[:expire_after]
            set_cookie(env, headers, cookie.merge!(options))
          end

          [status, headers, body]
        end
      end
    end
  end
end

