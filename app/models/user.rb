# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string
#  password_digest     :string
#  session_token       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#'
    }, default: 'default_profile.png'

  validates_attachment :avatar,
    content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png']}

  after_initialize :ensure_session_token!

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :in_follows, class_name: :Follow, foreign_key: :followee_id
  has_many :out_follows, class_name: :Follow, foreign_key: :follower_id
  has_many :followers, through: :in_follows, source: :follower
  has_many :followees, through: :out_follows, source: :followee
  has_many :followed_posts, through: :followees, source: :posts



  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user && user.valid_password?(password)
    user
  end

  def password
    @password
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = generate_token
    self.save!
    self.session_token
  end

  def ensure_session_token!
    self.session_token ||= generate_token
  end

  private

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end
end
