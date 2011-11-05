
class Hash
  alias original_method_missing method_missing
  def method_missing sym_method
    self[sym_method] || original_method_missing
  end
end

module XML

  class Document < Hash

    def initialize(xml)
      stream = File.open(xml, 'r:utf-8')
      Kernel.send(:define_method, :read_line) do
        @line = stream.readline
      end

      @ans = Array.new
      def read
        read_line rescue return
        case @line
        when /<\//
          @ans.pop
        when /<(.+?)>/
          @ans << $1
        when /(\S+)\s*=\s*(.+)/
          ans_chain = ''
          @ans.each do |ans|
            ans_chain += "[:#{ans}]"
            eval "self#{ans_chain} ||= {}"
          end

          eval "self[:#{@ans.join('][:')}][:#{$1}] = #{$2}"
        end
        read
      end

      read
    end

  end


end


