# frozen_string_literal: true

class SinatraServer
  include Singleton

  def initialize
    @pid = nil
  end

  def start
    return if @pid

    @pid = `nohup bundle exec ruby spec/support/sinatra/all.rb > /dev/null 2>&1 & echo $!`.strip
    puts "\nStart Sinatra [#{@pid}]"
    sleep 3
  end

  def restart
    kill
    start
  end

  def kill
    return unless @pid

    puts "\nSinatra kill -9 #{@pid}"
    `kill -9 #{@pid}`
    @pid = nil
  end
end
