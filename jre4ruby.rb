require "rjava"

platform = case RUBY_PLATFORM
when "i386-mingw32"
  "windows"
else
  "solaris"
end

add_class_path "jre4ruby/rep"
add_class_path "jre4ruby/lib/share", "jre4ruby/fix"
add_class_path "jre4ruby/lib/#{platform}", "jre4ruby/fix"
