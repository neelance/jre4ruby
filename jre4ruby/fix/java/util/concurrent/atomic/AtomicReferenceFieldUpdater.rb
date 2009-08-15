class Java::Util::Concurrent::Atomic::AtomicReferenceFieldUpdater
  AtomicReferenceFieldUpdaterImpl.class_eval do
    alias_method :initialize_orig, :initialize
    def initialize(tclass, vclass, field_name)
      initialize_orig tclass, nil, field_name # not field type aware
    end
  end
end
