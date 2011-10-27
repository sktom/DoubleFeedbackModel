
module Indicators

  def d_ema term
    return 0 unless @log.count > term
    sum = 0.0
    term.times do |i|
      sum += (term - i) * (@log[-i].last - @log[- i - 1].last)
    end
    sum * 2 / term / term.next
  end


end

