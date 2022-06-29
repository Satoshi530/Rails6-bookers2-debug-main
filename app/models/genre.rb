class Genre < ApplicationRecord
  has_many :books,through: :book_genres
  has_many :book_genres,dependent: :destroy, foreign_key: 'genre_id'

end
