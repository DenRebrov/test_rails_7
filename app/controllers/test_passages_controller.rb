# frozen_string_literal: true

class TestPassagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_test_passage, only: %i[show update result help]
  before_action :check_timer, only: :update

  def show; end

  def update
    # correct_questions = @test_passage.correct_questions
    # question_curr = @test_passage.current_question

    @test_passage.accept!(params[:answer_ids])

    if @test_passage.completed?
      # TestsMailer.completed_test(@test_passage).deliver_now
      
      redirect_to result_test_passage_path(@test_passage), notice: t('.completed')
    else
      @test_passage.current_question.update(time_start: Time.now.to_i)

      # if correct_questions == @test_passage.correct_questions

      # flash[:alert] = 'This was the wrong answer. Try another' if @test_passage.current_question == question_curr

      # end
      render :show
    end
  end

  def result
    # @test_passage.calculate_success_points
    if @test_passage.success?
      @test_passage.update(passed: true)

      resource = @test_passage.test.testable

      course_user = if resource.is_a?(Course)
                      CourseUser.find_by(course_id: resource, user_id: current_user)
                    elsif resource.is_a?(Topic)
                      CourseUser.find_by(course_id: resource.course, user_id: current_user)
                    else
                      CourseUser.find_by(course_id: resource.topic.course, user_id: current_user)
                    end

      course_user.add_progress_to_course(current_user)
    end

    # @test_passage.add_test_pass
  end

  def help
    msg = if @test_passage.use_help(params[:help_type].to_sym)
            { flash: { info: I18n.t('controllers.games.help_used') } }
          else
            { alert: I18n.t('controllers.games.help_not_used') }
          end
    
    redirect_to test_passage_path(@test_passage), msg
  end

  private

  def find_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def check_timer
    # find_test_passage
    
    if @test_passage.time_over?
      redirect_to result_test_passage_path(@test_passage), alert: 'Time is over!'
    end
  end
end

