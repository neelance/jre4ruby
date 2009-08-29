require "rjava"

# Copyright 1994-1998 Sun Microsystems, Inc.  All Rights Reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
module Sun::Net::Www
  module MimeLauncherImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Net, :URL
      include ::Java::Io
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  class MimeLauncher < MimeLauncherImports.const_get :JavaThread
    include_class_members MimeLauncherImports
    
    attr_accessor :uc
    alias_method :attr_uc, :uc
    undef_method :uc
    alias_method :attr_uc=, :uc=
    undef_method :uc=
    
    attr_accessor :m
    alias_method :attr_m, :m
    undef_method :m
    alias_method :attr_m=, :m=
    undef_method :m=
    
    attr_accessor :generic_temp_file_template
    alias_method :attr_generic_temp_file_template, :generic_temp_file_template
    undef_method :generic_temp_file_template
    alias_method :attr_generic_temp_file_template=, :generic_temp_file_template=
    undef_method :generic_temp_file_template=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :exec_path
    alias_method :attr_exec_path, :exec_path
    undef_method :exec_path
    alias_method :attr_exec_path=, :exec_path=
    undef_method :exec_path=
    
    typesig { [MimeEntry, Java::Net::URLConnection, InputStream, String, String] }
    def initialize(m, uc, is, temp_file_template, thread_name)
      @uc = nil
      @m = nil
      @generic_temp_file_template = nil
      @is = nil
      @exec_path = nil
      super(thread_name)
      @m = m
      @uc = uc
      @is = is
      @generic_temp_file_template = temp_file_template
      # get the application to launch
      launch_string = @m.get_launch_string
      # get a valid path to launch application - sets
      # the execPath instance variable with the correct path.
      if (!find_executable_path(launch_string))
        # strip off parameters i.e %s
        app_name = nil
        index = launch_string.index_of(Character.new(?\s.ord))
        if (!(index).equal?(-1))
          app_name = RJava.cast_to_string(launch_string.substring(0, index))
        else
          app_name = launch_string
        end
        raise ApplicationLaunchException.new(app_name)
      end
    end
    
    typesig { [URL, String] }
    def get_temp_file_name(url, template)
      temp_filename = template
      # Replace all but last occurrance of "%s" with timestamp to insure
      # uniqueness.  There's a subtle behavior here: if there is anything
      # _after_ the last "%s" we need to append it so that unusual launch
      # strings that have the datafile in the middle can still be used.
      wildcard = temp_filename.last_index_of("%s")
      prefix = temp_filename.substring(0, wildcard)
      suffix = ""
      if (wildcard < temp_filename.length - 2)
        suffix = RJava.cast_to_string(temp_filename.substring(wildcard + 2))
      end
      timestamp = System.current_time_millis / 1000
      arg_index = 0
      while ((arg_index = prefix.index_of("%s")) >= 0)
        prefix = RJava.cast_to_string(prefix.substring(0, arg_index) + timestamp + prefix.substring(arg_index + 2))
      end
      # Add a file name and file-extension if known
      filename = url.get_file
      extension = ""
      dot = filename.last_index_of(Character.new(?..ord))
      # BugId 4084826:  Temp MIME file names not always valid.
      # Fix:  don't allow slashes in the file name or extension.
      if (dot >= 0 && dot > filename.last_index_of(Character.new(?/.ord)))
        extension = RJava.cast_to_string(filename.substring(dot))
      end
      filename = "HJ" + RJava.cast_to_string(url.hash_code)
      temp_filename = prefix + filename + RJava.cast_to_string(timestamp) + extension + suffix
      return temp_filename
    end
    
    typesig { [] }
    def run
      begin
        ofn = @m.get_temp_file_template
        if ((ofn).nil?)
          ofn = @generic_temp_file_template
        end
        ofn = RJava.cast_to_string(get_temp_file_name(@uc.get_url, ofn))
        begin
          os = FileOutputStream.new(ofn)
          buf = Array.typed(::Java::Byte).new(2048) { 0 }
          i = 0
          begin
            while ((i = @is.read(buf)) >= 0)
              os.write(buf, 0, i)
            end
          rescue IOException => e
            # System.err.println("Exception in write loop " + i);
            # e.printStackTrace();
          ensure
            os.close
            @is.close
          end
        rescue IOException => e
          # System.err.println("Exception in input or output stream");
          # e.printStackTrace();
        end
        inx = 0
        c = @exec_path
        while ((inx = c.index_of("%t")) >= 0)
          c = RJava.cast_to_string(c.substring(0, inx) + @uc.get_content_type + c.substring(inx + 2))
        end
        substituted = false
        while ((inx = c.index_of("%s")) >= 0)
          c = RJava.cast_to_string(c.substring(0, inx)) + ofn + RJava.cast_to_string(c.substring(inx + 2))
          substituted = true
        end
        if (!substituted)
          c = c + " <" + ofn
        end
        # System.out.println("Execing " +c);
        Runtime.get_runtime.exec(c)
      rescue IOException => e
      end
    end
    
    typesig { [String] }
    # This method determines the path for the launcher application
    # and sets the execPath instance variable.  It uses the exec.path
    # property to obtain a list of paths that is in turn used to
    # location the application.  If a valid path is not found, it
    # returns false else true.
    def find_executable_path(str)
      if ((str).nil? || (str.length).equal?(0))
        return false
      end
      command = nil
      index = str.index_of(Character.new(?\s.ord))
      if (!(index).equal?(-1))
        command = RJava.cast_to_string(str.substring(0, index))
      else
        command = str
      end
      f = JavaFile.new(command)
      if (f.is_file)
        # Already executable as it is
        @exec_path = str
        return true
      end
      exec_path_list = nil
      exec_path_list = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("exec.path")))
      if ((exec_path_list).nil?)
        # exec.path property not set
        return false
      end
      iter = StringTokenizer.new(exec_path_list, "|")
      while (iter.has_more_elements)
        prefix = iter.next_element
        full_cmd = prefix + RJava.cast_to_string(JavaFile.attr_separator) + command
        f = JavaFile.new(full_cmd)
        if (f.is_file)
          @exec_path = prefix + RJava.cast_to_string(JavaFile.attr_separator) + str
          return true
        end
      end
      return false # application not found in exec.path
    end
    
    private
    alias_method :initialize__mime_launcher, :initialize
  end
  
end
