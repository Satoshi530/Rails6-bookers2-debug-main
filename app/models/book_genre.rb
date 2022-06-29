class BookGenre < ApplicationRecord
  belongs_to :book
  belongs_to :genre

  validates :book_id, presence: true
  validates :genre_id, presence: true
end
