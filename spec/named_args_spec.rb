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

  context 'symbol: "--symbol=hello"' do
    subject do
      Obtions.parse("--symbol=hello") do
        named_arg :symbol, type: Symbol
      end
    end

    its(:symbol) { should == :hello }
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

  context 'required args' do
    context 'when arg is missing' do
      it 'should raise an error' do
        expect do
          Obtions.parse "" do
            named_arg :debug, required: true
          end
        end.to raise_error(Obtions::RequiredArgsMissing)
      end

      context 'error object' do
        subject do
          begin
            Obtions.parse "" do
              named_arg :debug, required: true
            end
          rescue Exception => e
            e
          end
        end

        it('should have 1 arg') { subject.args.length.should == 1 }
        it('arg name == :debug') { subject.args.first.name.should == :debug }
      end

      context 'multiple required args missing' do
        context 'error.args.map(&:name)' do
          subject do
            begin
              Obtions.parse "" do
                named_arg :debug, required: true
                named_arg :test, required: true
                arg :first, required: true
              end
            rescue Exception => e
              e.args.map &:name
            end
          end

          it('should have 3 args')    { subject.length.should == 3 }
          it('should contain :debug') { subject.should include :debug }
          it('should contain :test')  { subject.should include :test }
          it('should contain :first') { subject.should include :first }
        end
      end

      context 'required args present' do
        subject do
          Obtions.parse "--test=yes --debug true first_arg" do
            named_arg :debug, required: true
            named_arg :test, required: true
            arg :first, required: true
          end
        end

        its(:debug) { should == "true" }
        its(:test)  { should == "yes" }
        its(:first) { should == "first_arg" }
      end
    end

    context 'when arg is present' do
      subject do
        Obtions.parse "--debug=true" do
          named_arg :debug, required: true
        end
      end

      its(:debug) { should == "true" }
    end
  end
end
