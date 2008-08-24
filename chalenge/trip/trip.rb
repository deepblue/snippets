%w(rubygems facets/enumerable).each{|lib| require lib}

def minimum_transfer(*vals)
  vals = vals.map{|v| (v*100).to_i }.sort{|x, y| y <=> x}  
  len = vals.length
  
  to_pay = [vals.sum / len] * len             # 공평하게 나누고
  (vals.sum % len).times{|i| to_pay[i] += 1 } # 나머지는 이미 많이 지불한 사람들이 부담
  
  vals.map_with_index{|v, i| (v - to_pay[i]).abs}.sum / 200.0
end

describe "The Trip" do
  it "모든 사람이 사용한 금액이 똑같아지기 위해 전달되어야하는 금액의 총합을 구한다" do
    minimum_transfer(10.00, 20.00, 30.00).should      == 10.00
    minimum_transfer(15.00, 15.01, 3.00, 3.01).should == 11.99
  end
end
