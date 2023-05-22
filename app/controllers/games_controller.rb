require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
    render :new
  end

   def score
    word = params[:word]
    letters = params[:letters].split(' ')

    @result = if valid_grid_word?(word, letters) && valid_english_word?(word)
                "Congratulations! '#{word}' is a valid English word that can be built using the original grid."
              elsif valid_grid_word?(word, letters)
                "Sorry, but '#{word}' cannot be built using the original grid."
              else
                "Sorry, but '#{word}' not an English word."
              end
  end

  private

  def valid_grid_word?(word, letters)
    word.chars.all? { |char| letters.include?(char) && letters.count(char) >= word.count(char) }
  end

  def valid_english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    JSON.parse(response).is_a?(Array)
  rescue OpenURI::HTTPError
    false
  end
end
