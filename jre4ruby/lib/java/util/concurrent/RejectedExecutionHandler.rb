require "rjava"

# 
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
# 
# 
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module RejectedExecutionHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
    }
  end
  
  # 
  # A handler for tasks that cannot be executed by a {@link ThreadPoolExecutor}.
  # 
  # @since 1.5
  # @author Doug Lea
  module RejectedExecutionHandler
    include_class_members RejectedExecutionHandlerImports
    
    typesig { [Runnable, ThreadPoolExecutor] }
    # 
    # Method that may be invoked by a {@link ThreadPoolExecutor} when
    # {@link ThreadPoolExecutor#execute execute} cannot accept a
    # task.  This may occur when no more threads or queue slots are
    # available because their bounds would be exceeded, or upon
    # shutdown of the Executor.
    # 
    # <p>In the absence of other alternatives, the method may throw
    # an unchecked {@link RejectedExecutionException}, which will be
    # propagated to the caller of {@code execute}.
    # 
    # @param r the runnable task requested to be executed
    # @param executor the executor attempting to execute this task
    # @throws RejectedExecutionException if there is no remedy
    def rejected_execution(r, executor)
      raise NotImplementedError
    end
  end
  
end
