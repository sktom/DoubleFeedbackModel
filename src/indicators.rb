
module Indicators

  def ema_dr term
    return 0 unless @log.count > term
    sum = 0.0
    index = 0
    @log[-term..-1].each do |log|
      sum += (term - index) * log.dr
      index += 1
    end
    sum * 2 / term / term.next
  end

  def sma_dt term
    return 0 unless @log.count > term
    sum = 0.0
    @log[-term..-1].each do |log|
      sum += log.dt
    end
    [[sum / term, 1.5].max, 50].min
  end


end

