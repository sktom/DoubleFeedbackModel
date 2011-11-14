
class Hash
  include Module.new{
    def method_missing arg
      self[arg] || super(arg)
    end
  }
end

