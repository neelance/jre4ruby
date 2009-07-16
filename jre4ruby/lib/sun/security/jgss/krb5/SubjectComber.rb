require "rjava"

# 
# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Krb5
  module SubjectComberImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include_const ::Javax::Security::Auth::Kerberos, :KerberosTicket
      include_const ::Javax::Security::Auth::Kerberos, :KerberosKey
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth, :DestroyFailedException
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # 
  # This utility looks through the current Subject and retrieves a ticket or key
  # for the desired client/server principals.
  # 
  # @author Ram Marti
  # @since 1.4.2
  class SubjectComber 
    include_class_members SubjectComberImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5Util::DEBUG }
      const_attr_reader  :DEBUG
    }
    
    typesig { [] }
    # 
    # Default constructor
    def initialize
      # Cannot create one of these
    end
    
    class_module.module_eval {
      typesig { [Subject, String, String, Class] }
      def find(subject, server_principal, client_principal, cred_class)
        return find_aux(subject, server_principal, client_principal, cred_class, true)
      end
      
      typesig { [Subject, String, String, Class] }
      def find_many(subject, server_principal, client_principal, cred_class)
        return find_aux(subject, server_principal, client_principal, cred_class, false)
      end
      
      typesig { [Subject, String, String, Class, ::Java::Boolean] }
      # 
      # Find the ticket or key for the specified client/server principals
      # in the subject. Returns null if the subject is null.
      # 
      # @return the ticket or key
      def find_aux(subject, server_principal, client_principal, cred_class, one_only)
        if ((subject).nil?)
          return nil
        else
          answer = (one_only ? nil : ArrayList.new)
          if ((cred_class).equal?(KerberosKey.class))
            # We are looking for a KerberosKey credentials for the
            # serverPrincipal
            iterator = subject.get_private_credentials(KerberosKey.class).iterator
            while (iterator.has_next)
              key = iterator.next
              if ((server_principal).nil? || (server_principal == key.get_principal.get_name))
                if (DEBUG)
                  System.out.println("Found key for " + (key.get_principal).to_s + "(" + (key.get_key_type).to_s + ")")
                end
                if (one_only)
                  return key
                else
                  if ((server_principal).nil?)
                    # Record name so that keys returned will all
                    # belong to the same principal
                    server_principal = (key.get_principal.get_name).to_s
                  end
                  answer.add(key)
                end
              end
            end
          else
            if ((cred_class).equal?(KerberosTicket.class))
              # we are looking for a KerberosTicket credentials
              # for client-service principal pair
              pcs = subject.get_private_credentials
              synchronized((pcs)) do
                iterator_ = pcs.iterator
                while (iterator_.has_next)
                  obj = iterator_.next
                  if (obj.is_a?(KerberosTicket))
                    ticket = obj
                    if (DEBUG)
                      System.out.println("Found ticket for " + (ticket.get_client).to_s + " to go to " + (ticket.get_server).to_s + " expiring on " + (ticket.get_end_time).to_s)
                    end
                    if (!ticket.is_current)
                      # let us remove the ticket from the Subject
                      # Note that both TGT and service ticket will be
                      # removed  upon expiration
                      if (!subject.is_read_only)
                        iterator_.remove
                        begin
                          ticket.destroy
                          if (DEBUG)
                            System.out.println("Removed and destroyed " + "the expired Ticket \n" + (ticket).to_s)
                          end
                        rescue DestroyFailedException => dfe
                          if (DEBUG)
                            System.out.println("Expired ticket not" + " detroyed successfully. " + (dfe).to_s)
                          end
                        end
                      end
                    else
                      if ((server_principal).nil? || (ticket.get_server.get_name == server_principal))
                        if ((client_principal).nil? || (client_principal == ticket.get_client.get_name))
                          if (one_only)
                            return ticket
                          else
                            # Record names so that tickets will
                            # all belong to same principals
                            if ((client_principal).nil?)
                              client_principal = (ticket.get_client.get_name).to_s
                            end
                            if ((server_principal).nil?)
                              server_principal = (ticket.get_server.get_name).to_s
                            end
                            answer.add(ticket)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          return answer
        end
      end
    }
    
    private
    alias_method :initialize__subject_comber, :initialize
  end
  
end
