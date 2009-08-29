require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module PipeImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :InetSocketAddress
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Util, :Random
    }
  end
  
  # A simple Pipe implementation based on a socket connection.
  class PipeImpl < PipeImplImports.const_get :Pipe
    include_class_members PipeImplImports
    
    # Source and sink channels
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    attr_accessor :sink
    alias_method :attr_sink, :sink
    undef_method :sink
    alias_method :attr_sink=, :sink=
    undef_method :sink=
    
    class_module.module_eval {
      when_class_loaded do
        Util.load
        some_bytes = Array.typed(::Java::Byte).new(8) { 0 }
        result_ok = IOUtil.random_bytes(some_bytes)
        if (result_ok)
          const_set :Rnd, Random.new(ByteBuffer.wrap(some_bytes).get_long)
        else
          const_set :Rnd, Random.new
        end
      end
      
      const_set_lazy(:Initializer) { Class.new do
        extend LocalClass
        include_class_members PipeImpl
        include PrivilegedExceptionAction
        
        attr_accessor :sp
        alias_method :attr_sp, :sp
        undef_method :sp
        alias_method :attr_sp=, :sp=
        undef_method :sp=
        
        typesig { [class_self::SelectorProvider] }
        def initialize(sp)
          @sp = nil
          @sp = sp
        end
        
        typesig { [] }
        def run
          ssc = nil
          sc1 = nil
          sc2 = nil
          begin
            # loopback address
            lb = InetAddress.get_by_name("127.0.0.1")
            raise AssertError if not ((lb.is_loopback_address))
            # bind ServerSocketChannel to a port on the loopback address
            ssc = ServerSocketChannel.open
            ssc.socket.bind(self.class::InetSocketAddress.new(lb, 0))
            # Establish connection (assumes connections are eagerly
            # accepted)
            sa = self.class::InetSocketAddress.new(lb, ssc.socket.get_local_port)
            sc1 = SocketChannel.open(sa)
            bb = ByteBuffer.allocate(8)
            secret = Rnd.next_long
            bb.put_long(secret).flip
            sc1.write(bb)
            # Get a connection and verify it is legitimate
            loop do
              sc2 = ssc.accept
              bb.clear
              sc2.read(bb)
              bb.rewind
              if ((bb.get_long).equal?(secret))
                break
              end
              sc2.close
            end
            # Create source and sink channels
            self.attr_source = self.class::SourceChannelImpl.new(@sp, sc1)
            self.attr_sink = self.class::SinkChannelImpl.new(@sp, sc2)
          rescue self.class::IOException => e
            begin
              if (!(sc1).nil?)
                sc1.close
              end
              if (!(sc2).nil?)
                sc2.close
              end
            rescue self.class::IOException => e2
            end
            x = self.class::IOException.new("Unable to establish" + " loopback connection")
            x.init_cause(e)
            raise x
          ensure
            begin
              if (!(ssc).nil?)
                ssc.close
              end
            rescue self.class::IOException => e2
            end
          end
          return nil
        end
        
        private
        alias_method :initialize__initializer, :initialize
      end }
    }
    
    typesig { [SelectorProvider] }
    def initialize(sp)
      @source = nil
      @sink = nil
      super()
      begin
        AccessController.do_privileged(Initializer.new_local(self, sp))
      rescue PrivilegedActionException => x
        raise x.get_cause
      end
    end
    
    typesig { [] }
    def source
      return @source
    end
    
    typesig { [] }
    def sink
      return @sink
    end
    
    private
    alias_method :initialize__pipe_impl, :initialize
  end
  
end
