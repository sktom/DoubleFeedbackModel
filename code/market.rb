
require './agent'
require './indicators'
require '../lib/exthash'

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
    @cur_rate = Cond.const.OriginalRate
    @log = [{:dt => 1, :dr => 0.01, :rate => @cur_rate}] * Cond.const.Leeway
    set_agents Cond.const.N

    term.times do |time|
      @cur_time += Cond.const.dt
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
    file_name = '../res/' + file_name
    index = 0
    @log.shift Cond.const.Leeway
    File.open file_name, 'w' do |fout|
      @log.each do |log|
        fout.puts "#{index += 1} #{log.dt} #{log.dr} #{log.rate}"
      end
    end
    `gnuplot -persist -e "
     plot '#{file_name}' using 1:4 w l"`
  end

  private
  def set_rate new_rate
    @dt = @cur_time - @last_time
    @last_time = @cur_time
    @dtlist ||= Array.new
    @dtlist << @dt
    @dr = new_rate - @cur_rate
    @cur_rate = new_rate
    @log << {:dt => @dt, :dr => @dr, :rate => new_rate}
    p @log.count - Cond.const.Leeway
  end


end

