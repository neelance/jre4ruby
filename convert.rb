require "converter/converter"

dir = "#{File.dirname __FILE__}/jre4ruby"
controller = Java2Ruby::ConversionController.new
controller.add_files "#{dir}/src", "#{dir}/lib", Dir.dir_glob("#{dir}/src", "**/*")

controller.add_is_constant_hook do |converter, name, value|
  !%w{NULL ENQUEUED}.include?(name) && value
end

controller.add_ruby_constant_name_hook do |converter, name|
  if name == "unsafe"
    "UnsafeInstance"
  elsif name == "referenceQueue"
    "ReferenceQueueInstance"
  else
    nil
  end
end

controller.run $process_count
