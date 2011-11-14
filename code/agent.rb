
class Agent
  def bid; @mid - @spread / 2; end
  def ask; @mid + @spread / 2; end

  def initialize
    @spread = Cond.const.L
    init
  end

  def init
    declare Market.cur_rate
    @d = 1
    @c0 = Cond.const.c0
    @c1 = Cond.const.c1
    @e0 = Cond.const.e0
    @Gamma = Cond.const.Gamma
    @M = Cond.const.M
    @dt = Cond.const.dt
    @dp = Cond.const.dp
  end

  def update_rate
    c = @c1 * 
      (@c0 / Market.sma_dt(@Gamma)) ** 0.5
    desire = @mid +
      @d * Market.ema_dr(@M) * c * @dt +
      @c1 * @dp * (rand(2) > 0 ? 1 : -1)

    declare desire
    @d *= (1 - @e0) + (rand(2) > 0 ? 0.01 : -0.01)
  end

  private
  def declare rate
    @mid = rate
  end


end

