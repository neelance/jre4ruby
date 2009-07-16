class Java::Util::Arrays
  class_module.module_eval {
    alias_method :converted_to_s, :to_s
    def to_s(array = :no_arg)
      if array == :no_arg
        super()
      else
        converted_to_s array
      end
    end

		def copy_of(array, new_size)
			if array.is_a? CharArray
				a = CharArray.allocate
				a.data = array.data.dup.concat("\0" * (new_size - array.size))
				a
			else
				array.dup.concat Array.new(new_size - array.size, 0)
			end
		end
  }
end
