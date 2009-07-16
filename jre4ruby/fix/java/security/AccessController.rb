class Java::Security::AccessController
  def self.do_privileged(action, arg1 = nil)
    action.run
  end
end
