class Java::Util::ResourceBundle
  class_module.module_eval {
    def get_class_context
			[]
		end
  }

  CacheKey.module_eval {
    def to_s
      l = @locale.to_s
      if ((l.length).equal?(0))
        if (!(@locale.get_variant.length).equal?(0))
          l = "__" + (@locale.get_variant).to_s
        else
          l = "\"\""
        end
      end
      return "CacheKey[#{@name}, lc=#{l}, ldr=#{get_loader}(format=#{@format})]"
    end
  }
end
