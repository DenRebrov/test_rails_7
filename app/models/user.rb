class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  has_many :course_users, dependent: :destroy
  has_many :courses, through: :course_users

  has_many :test_passages, dependent: :destroy
  has_many :tests, through: :test_passages

  def get_course_progress(course)
    course_users.select(:course_id, :progress).where(course_id: course.id).pluck(:progress).first
  end

  def course_completed?(course)
    get_course_progress(course) == 100
  end

  def course_purchased?(course)
    course_users.select(:course_id).pluck(:course_id).include?(course.id)
  end

  def main_test_open?(course)
    count = 0
    course.topics.preload(:test).each { |topic| count += 1 if test_passed?(topic.test) }

    count == course.topics.load.size
  end

  def semi_test_open?(topic)
    count = 0
    topic.lessons.preload(:test).each { |lesson| count += 1 if test_passed?(lesson.test) }

    count == topic.lessons.load.size
  end

  def topic_open?(topic)
    topic.previous_topic == nil || test_completed_for?(topic.previous_topic)
  end

  def test_completed_for?(resourse)
    test_passed?(resourse.test)
  end

  def test_passage(test)
    test_passages.order(id: :desc).find_by(test_id: test.id)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user_name = auth.info[:name]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]

      # if email == nil
      #   email = Devise.friendly_token[0, 20].to_s
      #   email += "_guest@mail.com"
      # end

      user = User.new(name: user_name, email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save!(name: user_name, email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  # private

  def test_passed?(test)
    test_passages.select(:test_id, :passed).completeded.pluck(:test_id).include?(test.id)
  end
end
