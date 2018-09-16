describe "#try_chain" do
  # it "should chain methods on non-nil values" do  # TODO fix after rails 4 upgrade
  #   :abcd.try_chain(:to_s, :upcase).should == "ABCD"
  # end

  # it "should return nil if one of the values is nil" do
  #   nil.try_chain(:to_date, :to_s).should be_nil
  # end

  # it "should raise NoMethodError when the value is present but the method is wrong" do
  #   lambda do
  #     "foo".try_chain(:aldkjasld)
  #   end.should raise_error(NoMethodError)
  # end
end
