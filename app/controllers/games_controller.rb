require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (ALPHABET - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    # @result = result(@word)
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    json = JSON.parse(response)
    return json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

end
