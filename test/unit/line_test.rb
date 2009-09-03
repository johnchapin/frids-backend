require 'test_helper'

class LineTest < ActiveSupport::TestCase

  test "Line creation" do
    line = Line.create_or_update( :skip_update => false, :line_args => get_line_args)
    assert_equal(line.line_type, "rids")
    assert_equal(Time.local("2009","08","21","05","21","38"),line.call_received)
    assert_equal(Time.local("2009","08","21","05","27","32"),line.arrived_on_scene)
  end

  test "Arrived on scene rolls to next day" do
    line_options = get_line_args(:call_received => "23:59:59",
                                 :arrived_on_scene => "00:01:01")
    line = Line.create_or_update( :skip_update => false, :line_args => line_options)
    assert_equal(Time.local("2009","08","21","23","59","59"),line.call_received)
    assert_equal(Time.local("2009","08","22","00","01","01"),line.arrived_on_scene)
  end

  test "Arrived on scene doesn't add more than 10 days" do
    line_options = get_line_args(:call_received => "23:59:59",
                                 :arrived_on_scene => "00:01:01")
    line = Line.create_or_update( :skip_update => false, :line_args => line_options)
    assert_equal(Time.local("2009","08","21","23","59","59"),line.call_received)
    assert_equal(Time.local("2009","08","22","00","01","01"),line.arrived_on_scene)
  end

end
