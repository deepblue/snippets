class Array
  def jolly?
    differences.sort == (1...length).to_a
  end
  
  def differences
    self[0..-2].zip(self[1..-1]).map{|x| (x[0] - x[1]).abs }
  end
end

describe "Jolly Jumpers" do
  it "서로 인접해 있는 두 수의 차를 계산한다" do
    [1,4,2,3].differences.should == [3,2,1]
  end
  
  it "유쾌한 점퍼인가?" do
    [1, 4, 2, 3].should be_jolly
    [1, 4, 2, -1, 6].should_not be_jolly
  end
end