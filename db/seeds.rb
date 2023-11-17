# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'
require 'open-uri'

puts 'Cleaning database...'
Bookmark.destroy_all
Movie.destroy_all
puts 'Creating movies...'

url = 'https://tmdb.lewagon.com/movie/top_rated'
data_serialized = URI.open(url).read
data = JSON.parse(data_serialized)

movie_hashes = data["results"]

movie_hashes.each do |movie_hash|
  poster_url = 'https://tmdb.lewagon.com/t/p/original/#{movie_hash["poster_path"]}'
  # file = URI.open(poster_url)

  movie = Movie.new(title: movie_hash['original_title'],
                    overview: movie_hash['overview'],
                    poster_url: poster_url,
                    rating: movie_hash['vote_average'])
  movie.save
end

puts "#{Movie.count.to_i} Movies created"
