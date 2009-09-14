class Sun::Misc::Launcher
  class_module.module_eval {
    def get_bootstrap_class_path
      urls = RJava::ClassLoading.bootstrap_class_paths.map { |path| get_file_url(JavaFile.new(path)) }
      URLClassPath.new(urls, self.attr_factory)
    end
  }
end
