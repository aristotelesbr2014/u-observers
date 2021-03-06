require 'test_helper'

module Micro::Observers
  class SetSubjectChangedTest < Minitest::Test
    def test_the_subject_changing
      @memory = []

      observers = Set.new('hello')

      observers.attach(-> (value) { @memory << String(value).upcase })

      # --

      refute_predicate(observers, :subject_changed?)

      # --

      assert_instance_of(TrueClass, observers.subject_changed!)

      assert_predicate(observers, :subject_changed?)

      observers.call

      assert_equal(%w[HELLO], @memory)

      # --

      refute_predicate(observers, :subject_changed?)

      observers.subject_changed!

      assert_predicate(observers, :subject_changed?)

      assert_instance_of(FalseClass, observers.subject_changed(false))

      refute_predicate(observers, :subject_changed?)

      observers.call

      assert_equal(%w[HELLO], @memory)

      # --

      err = assert_raises(ArgumentError) { observers.subject_changed(1) }
      assert_equal('expected a boolean (true, false)', err.message)
    end
  end
end
