require 'configie/version'

class Configie
  def initialize(&block)
    @config = {}
    merge!(&block)
  end

  def merge(&block)
    abort 'FIXME: merge is not fully implemented, it should be deep copied.'
    self.dup.merge!(&block)
  end

  def merge!(&block)
    if block_given?
      @outter_binding = block.binding
      @outter_context = @outter_binding.eval('self')
      @outter_variables = @outter_binding.eval('local_variables')
      # TODO: instance_variables can't be supported
      # @outter_context.instance_variables

      instance_eval &block

      @outter_binding = nil
    end
    self
  end

  def method_missing(meth, *args, &blk)
    meth = meth.to_sym

    # outter variables
    if @outter_binding
      if @outter_variables.include? meth
        return @outter_binding.eval(meth.to_s)
      end

      # method could come from the outside
      # but it can't trigger outter method_missing
      if @outter_context.respond_to?(meth)
        return @outter_context.send(meth, *args, &blk) rescue nil
      end
    end

    if block_given?
      # deep writer: key { key2 value2 }
      @config[meth] = Configie.new(&blk)
      @config
    elsif args.empty?
      # reader: key
      @config[meth]
    else
      # writer: key value
      define_method()
      @config[meth] = args[0]
    end
  end
end
