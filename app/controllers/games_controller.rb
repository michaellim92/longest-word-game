require "open-uri"

class GamesController < ApplicationController
  def new
    @starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    # generate an array of letters
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @start = params[:start].to_f
    @end = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @elapsed_time = (@end - @start).round(2)
    @pop_letters = params[:letters]

    @user_word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@user_word}"
    result = JSON.parse(open(url).read)

    if @user_word.chars.all? { |letter| @pop_letters.count(letter) >= @user_word.count(letter) }
      if result["found"] == true 
        @final_score = params[:word].length * (@elapsed_time - (@elapsed_time * 0.4))
        @final_score
        @string = ": is an English word! Congrats!"
      else
        @final_score = 0
        @string = " is not a word, try again!"
      end
    else
      @final_score = 0
      @string = ": Use the right letters, try again!"
      @elapsed_time = 0
    end
  end
end
