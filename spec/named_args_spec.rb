describe "Named Arguments" do
  context 'basic: "--test hello"' do
    subject do
      Obtions.parse("--test hello") do
        named_arg :test
      end
    end

    its(:test) { should == "hello" }
  end

  context 'with equals: "--test=hello"' do
    subject do
      Obtions.parse("--test=hello") do
        named_arg :test
      end
    end

    its(:test) { should == "hello" }
  end

  context 'with optional: "--test=hello --debug[=VALUE]"' do
    context 'optional argument excluded' do
      subject do
        Obtions.parse("--test=hello") do
          named_arg :test
          named_arg :debug, optional: true
        end
      end

      its(:test)  { should == "hello" }
      its(:debug) { should be_nil }
    end

    context 'optional argument specified' do
      subject do
        Obtions.parse("--test=hello --debug=yes") do
          named_arg :test
          named_arg :debug, optional: true
        end
      end

      its(:test)  { should == "hello" }
      its(:debug) { should == "yes" }
    end
  end

  # The way that mandatory arguments are processed is really weird. For example,
  # if I had this Obtions code:
  #
  #   Obtions.parse "testing" do
  #     named_arg :debug # this is mandatory!
  #   end
  #
  # No exception would be raised. However, if I had this:
  #
  #   Obtions.parse "testing --debug" do
  #     named_arg :debug # this is mandatory!
  #   end
  #
  # Then I would get an OptionParser::MissingArgument error.
  context 'mandatory argument missing' do
    it "should raise an error" do
      expect do
        Obtions.parse("--test=true --debug") do
          named_arg :test
          named_arg :debug
        end
      end.to raise_error(OptionParser::MissingArgument)
    end
  end

  context 'with type: "--numeric=10"' do
    subject do
      Obtions.parse("--numeric=10") do
        named_arg :numeric, type: Integer
      end
    end

    its(:numeric) { should be_a Integer }
    its(:numeric) { should be_a Fixnum }
    its(:numeric) { should == 10 }
  end

  context 'float: "--float=10.45"' do
    subject do
      Obtions.parse("--float=10.45") do
        named_arg :float, type: Float
      end
    end

    its(:float) { should == 10.45 }
  end

  context 'invalid data for float: "--float=not_float"' do
    it "should raise an error" do
      expect do
        Obtions.parse "--float=not_float" do
          named_arg :float, type: Float
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'invalid data for integer: "--numeric=not_numeric"' do
    it 'should raise an error' do
      expect do
        Obtions.parse("--numeric=not_numeric") do
          named_arg :numeric, type: Integer
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'with limited number of possible choices' do
    context 'string, only "text", "binary" or "audio"' do
      context 'valid input' do
        subject do
          Obtions.parse("--type audio") do
            named_arg :type, in: ["text", "binary", "audio"]
          end
        end

        its(:type) { should == "audio" }
      end

      context 'invalid input' do
        it "should raise an error" do
          expect do
            Obtions.parse("--type invalid") do
              named_arg :type, in: ["text", "binary", "audio"]
            end
          end.to raise_error(OptionParser::InvalidArgument)
        end
      end
    end
  end
end
