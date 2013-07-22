worker_processes 6
timeout 30
# fine tuning
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
 
before_exec do |server|
  ENV['RUBY_HEAP_MIN_SLOTS']=800000
  ENV['RUBY_GC_MALLOC_LIMIT']=59000000
  ENV['RUBY_HEAP_SLOTS_INCREMENT']=10000
  ENV['RUBY_HEAP_SLOTS_GROWTH_FACTOR']=1
  ENV['RUBY_HEAP_FREE_MIN']=100000
end
