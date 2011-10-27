
class Agent
  def bid; @mid - @spread / 2; end
  def ask; @mid + @spread / 2; end

  def initialize
    @spread = Condition.const.L
    init
  end

  def init
    declare Market.cur_rate
    @d = 0
    #@d = rand * 2 - 1
    #@d = rand(2) > 0 ? 1 : -1
    #@d = 1.25
  end

  def update_rate
    desire = @mid +
      Condition.const.c1 * (rand(2) > 0 ? 1 : -1) * Condition.const.dp
      #@d * Market.d_ema(Condition.const.M) * Condition.const.dt +
      #Condition.const.dp * (rand(2) > 0 ? 1 : -1)
      #Condition.const.c1 * Condition.const.dp * (rand(2) > 0 ? 1 : -1)
    declare desire
    #@d = @d * (1 - Condition.const.e0) + (rand(2) > 0 ? 0.01 : -0.01)
  end

  private
  def declare rate
    @mid = rate
  end


end

