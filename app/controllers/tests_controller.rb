# frozen_string_literal: true

class TestsController < ApplicationController
  add_breadcrumb 'Musems', :courses_path

  before_action :authenticate_user!
  before_action :find_test
  before_action :payment_verification
  # before_action :course_visible_verification

  def start
    # if @test.questions_and_answers?
      user_test_passages = @test.test_passages.where(user_id: current_user.id) # finish the method !!! 26 Sql queries

      if user_test_passages.load.size > 0
        last_test_passage = user_test_passages.last

        last_test_passage.destroy unless last_test_passage.passed?
        last_test_passage.destroy if user_test_passages.completeded.load.size > 1
      end

      current_user.tests.push(@test)
      current_user.test_passage(@test).current_question.update(time_start: Time.now.to_i)

      redirect_to current_user.test_passage(@test)
    # else
    #   redirect_to root_path, alert: 'Нужно создать вопросы и ответы для теста!'
    # end
  end

  def show
    add_breadcrumb @test.testable.topic.course.title, course_path(@test.testable.topic.course)
    add_breadcrumb @test.testable.topic.title, topic_path(@test.testable.topic)
    add_breadcrumb @test.testable.title, lesson_path(@test.testable)
    add_breadcrumb "Test", test_path(@test)
  end

  def semi
    unless current_user.semi_test_open?(@test.testable)
      redirect_to topic_path(@test.testable), alert: 'You need to complete all tests for the halls'
    end

    add_breadcrumb @test.testable.course.title, course_path(@test.testable.course)
    add_breadcrumb @test.testable.title, topic_path(@test.testable)
    add_breadcrumb 'Semi test', semi_test_path(@test.testable.test)
  end

  def main
    unless current_user.main_test_open?(@test.testable)
      redirect_to course_path(@test.testable), alert: 'You need to complete all tests for the halls'
    end

    add_breadcrumb @test.testable.title, course_path(@test.testable)
    add_breadcrumb 'Main test', main_test_path(@test.testable.test)    
  end

  private

  def find_test
    @test = Test.find(params[:id])
  end

  def payment_verification
    if @test.testable.is_a?(Course)
      redirect_to course_path(@test.testable) unless current_user.course_purchased?(@test.testable) && current_user.main_test_open?(@test.testable)
    elsif @test.testable.is_a?(Topic)
      redirect_to course_path(@test.testable.course) unless current_user.course_purchased?(@test.testable.course) && current_user.semi_test_open?(@test.testable)
    else
      redirect_to course_path(@test.testable.topic.course) unless current_user.course_purchased?(@test.testable.topic.course) && current_user.topic_open?(@test.testable.topic)
    end
  end

  def course_visible_verification
    if @test.testable.is_a?(Course)
      redirect_to root_path unless @test.testable.visible? || user_signed_in? && current_user.admin?
    elsif @test.testable.is_a?(Topic)
      redirect_to root_path unless @test.testable.course.visible? || user_signed_in? && current_user.admin?
    else
      redirect_to root_path unless @test.testable.topic.course.visible? || user_signed_in? && current_user.admin?
    end
  end
end

