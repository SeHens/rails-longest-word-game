class GamesController < ApplicationController
    require 'open-uri'
    require 'json'

    def new
        @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    end

    def score
        @word = params[:word].upcase
        @letters = params[:letters]
        @result = check_word(@word, @letters)
        render :score
    end
        
        private
        
          def check_word(word, letters)
            if !word_in_grid?(word, letters)
              { message: "The word can’t be built out of the original grid", success: false }
            elsif !valid_english_word?(word)
              { message: "The word is valid according to the grid, but is not a valid English word", success: false }
            else
              { message: "The word is valid according to the grid and is an English word", success: true }
            end
          end
        
          def word_in_grid?(word, letters)
            word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
          end
        
          def valid_english_word?(word)
            url = "https://dictionary.lewagon.com/#{word}"
            response = URI.open(url).read
            json = JSON.parse(response)
            json['found']
          rescue OpenURI::HTTPError, JSON::ParserError
            false
          end
end
