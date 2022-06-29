class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_genres,dependent: :destroy
  has_many :genres,through: :book_genres

  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'

  validates :title, presence: true
  validates :body, presence: true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @bok = Book.where("title LIKE?", "%#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  def save_genres(genre_list)
    current_genres = self.genres.pluck(:name) unless self.genres.nil?
    old_genres = current_genres - genre_list
    new_genres = genre_list - current_genres

    old_genres.each do |old|
      self.genres.delete Genre.find_by(name: old)
    end

    new_genres.each do |new|
      new_book_genre = Genre.find_or_create_by(name: new)
      self.genres << new_book_genre
   end
  end
end
