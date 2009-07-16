require "rjava"

lib_path = "#{File.dirname(__FILE__)}/jre4ruby/lib"
fix_path = "#{File.dirname(__FILE__)}/jre4ruby/fix"
rep_path = "#{File.dirname(__FILE__)}/jre4ruby/rep"

add_class_loader { |package_path|
  dirs, names = list_paths "#{lib_path}/#{package_path}", "#{rep_path}/#{package_path}"
  
  dirs.each do |dir|
    import_package dir, package_path
  end
  
  names.each do |name|
    file_path = "#{package_path}/#{name}.rb"
    if File.exist?("#{rep_path}/#{file_path}")
      import_class name, "jre4ruby/rep/#{file_path}"
    elsif File.exist?("#{fix_path}/#{file_path}")
      import_class name, "jre4ruby/lib/#{file_path}", "jre4ruby/fix/#{file_path}"
    elsif File.exist?("#{lib_path}/#{file_path}")
      import_class name, "jre4ruby/lib/#{file_path}"
    else
      import_java_class name, "#{package_path.gsub("/", ".")}.#{name}"
    end
  end
}
