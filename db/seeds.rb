# frozen_string_literal: true

User.create!(
  email: 'admin@mail.ru',
  password: '123456',
  admin: true
)

##############################################################################

3.times do
  course = Course.create!(
    title: Faker::Educator.subject,
    body: Faker::Company.bs,
    video: 'https://player.vimeo.com/video/607528814?h=5680ae1057&color=ffffff&title=0&byline=0&portrait=0&badge=0',
    category: 'palace',
    price: rand(100),
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    visible: true
  )
  # course.image.attach(io: File.open('app/assets/storage/plan3.png'), filename: 'plan3.png')
  # course.image.attach(io: File.open(Rails.root.join('app/assets/storage/plan3.png')), filename: 'plan3.png')
  # course.save!

# ##############################################################################

  3.times do
    topic = Topic.create!(
      title: Faker::Educator.subject,
      body: Faker::Company.bs,
      video: 'https://player.vimeo.com/video/607528814?h=5680ae1057&color=ffffff&title=0&byline=0&portrait=0&badge=0',
      number: rand(16),
      coords: '552,279,444,222',
      shape: 'rect',
      # image: 'https://res.cloudinary.com/dmwubn5wl/image/upload/v1634413579/tri018t9p3oef6ewjoaxi8v3zkfu.png',
      course_id: course.id
    )

# ##############################################################################

    3.times do
      lesson = Lesson.create!(
        title: Faker::Educator.subject,
        body: Faker::Company.bs,
        video: 'https://player.vimeo.com/video/607528814?h=5680ae1057&color=ffffff&title=0&byline=0&portrait=0&badge=0',
        number: rand(32),
        topic_id: topic.id,
        shape: 'rect',
        coords: '553,331,436,306'
        
      )


#       # Photo.create!(
#       #   title:
#       #   description:
#       #   url:
#       #   lesson_id:
#       # )

# ##############################################################################

      test_course = Test.create!(
        testable_type: 'Course',
        testable_id: course.id
      )

      test_topic = Test.create!(
        testable_type: 'Topic',
        testable_id: topic.id
      )

      test_lesson = Test.create!(
        testable_type: 'Lesson',
        testable_id: lesson.id
      )

# ##############################################################################

      1.times do
        question = Question.create!(
          body: 'Question',
          test_id: test_course.id
        )

        Answer.create!(correct: true, body: 'A1', question_id: question.id)

      end

      1.times do
        question = Question.create!(
          body: 'Question',
          test_id: test_topic.id
        )

        Answer.create!(correct: true, body: 'A1', question_id: question.id)

      end

      3.times do
        question = Question.create!(
          body: 'Question',
          test_id: test_lesson.id
        )

        Answer.create!(correct: true, body: 'A1', question_id: question.id)
        Answer.create!(correct: false, body: 'A2', question_id: question.id)
        Answer.create!(correct: false, body: 'A2', question_id: question.id)
        Answer.create!(correct: false, body: 'A2', question_id: question.id)

      end
    end
  end
end