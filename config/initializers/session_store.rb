# Be sure to restart your server when you modify this file.
MemcacheStoreErrorApp::Application.config.session_store :mem_cache_store, expire_after: 29.days, domain: :all
