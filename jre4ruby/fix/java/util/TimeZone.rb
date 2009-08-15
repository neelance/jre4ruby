class Java::Util::TimeZone
  class_module.module_eval {
    def get_system_time_zone_id(java_home, country)
      Time.new.zone
    end

    def get_system_gmtoffset_id
      format "GMT%+03d:00", Time.new.gmt_offset / 60 / 60
    end
  }
end
