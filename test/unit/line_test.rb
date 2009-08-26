require 'test_helper'

class LineTest < ActiveSupport::TestCase

  line_options = {
      :line_type => "rids",
      :line_date => "08/21/2009",
      :incident_number => "10084",
      :unit => "141",
      :address => "804 PAGE ST",
      :tax_map => "077",
      :call_type => "OVERDOSE AWAK AND T",
      :call_received => "05:21:38",
      :call_dispatch => "05:21:56",
      :unit_enroute => "05:23:41",
      :arrived_on_scene => "05:27:32",
      :in_service => "05:39:44",
      :url => "calldisp.php?full_incidentno=MRS090821010084&unitno=141"
  }

  test "Line creation" do
    line = Line.create_or_update(line_options)
    assert_equal(line.line_type, "rids")
    assert_equal(Time.local("2009","08","21","05","21","38"),line.call_received)
    assert_equal(Time.local("2009","08","21","05","27","32"),line.arrived_on_scene)
  end

  test "Line update" do
    line_options.delete(:arrived_on_scene)
    line = Line.create_or_update(line_options)
    assert_nil(line.arrived_on_scene)
    line_options[:arrived_on_scene] = "05:27:32"
    line = Line.create_or_update(line_options)
    assert_equal(Time.local("2009","08","21","05","27","32"),line.arrived_on_scene)
  end

  test "Line perform" do
    line = Line.create_or_update(line_options)
    assert_equal(Time.local("2009","08","21","05","27","32"),line.arrived_on_scene)
    assert_nil(line.event_id)
    line.perform
    assert_not_nil(line.event_id)
  end

  test "Fix time after received" do
    test_time1 = Time.local("2009","08","21","23","59","59")
    # This looks like what we might get from the web scaping
    test_time2 = Time.local("2009","08","21","00","01","01")
    assert_equal(21,test_time2.day);
    test_time2 = Line.fix_time_after_received(test_time1, test_time2)
    assert_equal(22,test_time2.day);

    test_time3 = Time.local("2009","07","01","00","01","01")
    assert_equal(Time.local("2009","07","01","00","01","01"), test_time3)
  end

end
