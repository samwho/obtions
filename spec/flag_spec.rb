describe "Flag Parsing" do
  context 'simple flag parsing: "-p"' do
    subject do
      Obtions.parse("-p") do
        flag :p
      end
    end

    its(:p)  { should be_true }
    its(:p?) { should be_true }
  end

  context 'named flag parsing: "-s"' do
    subject do
      Obtions.parse("-s") do
        flag :s, long: "silent"
      end
    end

    its(:silent)  { should be_true }
    its(:silent?) { should be_true }
  end

  context 'long name flags: "--debug --no-test"' do
    subject do
      Obtions.parse("--debug --no-test") do
        flag :d, long: "debug"
        flag :t, long: "test", default: true
      end
    end

    its(:d)     { should == true }
    its(:debug) { should == true }
    its(:t)     { should == false }
    its(:test)  { should == false }
  end

  context 'flags with input: "-p first second"' do
    subject do
      Obtions.parse("-p first second") do
        flag :p

        arg :first
        arg :second
      end
    end

    its(:p?)     { should be_true }
    its(:first)  { should == "first" }
    its(:second) { should == "second" }
  end

  context 'extraneous flag: -s -d -f' do
    specify '-f is an invalid option, should raise' do
      expect do
        Obtions.parse("-s -d -f") do
          flag :s
          flag :d
        end
      end.to raise_error(OptionParser::InvalidOption)
    end
  end

  context 'flag -d defined but not present in input: "input"' do
    subject do
      Obtions.parse "input" do
        flag :d
      end
    end

    its(:d) { should be_false }
  end
end
