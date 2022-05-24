require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times { @grid << ("A".."Z").to_a.sample }
  end

  def score
    @word = params["word"]
    @time = Time.now - Time.zone.parse(params["time"]).utc
    @grid = params["grid"].split(" ")
    @found = word_found?(@word)
    @valid = word_valid?(@word, @grid)
    @score = @word.length + (10 * (1 / @time))
    render :new
  end

  # The word can’t be built out of the original grid
  # The word is valid according to the grid, but is not a valid English word
  # The word is valid according to the grid and is an English word
  private

  def word_found?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    word_checked = JSON.parse(word_serialized)
    return word_checked["found"]
  end

  def word_valid?(word, grid)
    letters = grid.clone
    word.chars.each do |letter|
      if letters.include? letter.upcase
        letters.delete_at(letters.index(letter.upcase) || letters.length)
      else
        return false
      end
    end
    return true
  end
end
