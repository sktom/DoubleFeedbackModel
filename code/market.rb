
require './agent'
require './indicators'

Market = Object.new
class << Market
  include Indicators
  def dt; @dt; end
  def dr; @dr; end
  def cur_rate; @cur_rate; end

  def set_agents number
    @agentList = Array.new(number).map{Agent.new}
  end

  def test term
    @cur_time = 0
    @last_time = @cur_time
    @cur_rate = Condition.const.original_rate
    @log = [[@cur_time, @cur_rate]]
    set_agents Condition.const.N

    term.times do |time|
      @cur_time += Condition.const.dt
      @agentList.each do |agent|
        agent.update_rate
      end
      buyer = @agentList.sort{|a1, a2| a1.bid <=> a2.bid}.last
      seller = @agentList.sort{|a1, a2| a1.ask <=> a2.ask}.first
      bid, ask = buyer.bid, seller.ask
      next if bid < ask
      new_rate = (bid + ask) / 2  
      set_rate new_rate
      [buyer, seller].each{|agent| agent.init}
    end

  end

  def output file_name = 'res.csv'
    index = 0
    @log.shift 2
    File.open file_name, 'w' do |fout|
      @log.each do |timerate|
        fout.puts "#{index += 1} #{timerate.join ' '}"
      end
    end
    p @dtlist.inject(:+) / @dtlist.count
    `gnuplot -persist -e "
     plot '#{file_name}' using 1:3 w l"`
  end

  private
  def set_rate new_rate
    @dt = @cur_time - @last_time
    @last_time = @cur_time
    @dtlist ||= Array.new
    @dtlist << @dt
    @dr = new_rate - @cur_rate
    @cur_rate = new_rate
    @log << [@cur_time, new_rate, @dr]
  end


end

