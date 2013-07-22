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
