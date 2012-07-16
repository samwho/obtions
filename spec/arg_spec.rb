describe "Unnamed Arguments" do
  context 'typed input' do
    context 'integer: "first 10"' do
      subject do
        Obtions.parse("first 10") do
          arg :first
          arg :number, type: Integer
        end
      end

      its(:number) { should == 10 }
    end

    context 'integer non-base-10: "first 110"' do
      subject do
        Obtions.parse("first 110") do
          arg :first
          arg :number, type: Integer, base: 2
        end
      end

      its(:number) { should == 6 }
    end

    context 'integer hex: "first 0xFF"' do
      subject do
        Obtions.parse("first 0xFF") do
          arg :first
          arg :number, type: Integer, base: 16
        end
      end

      its(:number) { should == 255 }
    end

    context 'array: "first "1, 2, 3, 4, dog""' do
      subject do
        Obtions.parse('first "1, 2, 3, 4, dog"') do
          arg :first
          arg :second, type: Array
        end
      end

      its(:second) { should == ["1", "2", "3", "4", "dog"] }
    end

    context 'array of ints: "first "1, 2, 3, 4""' do
      subject do
        Obtions.parse('first "1, 2, 3, 4"') do
          arg :first
          arg :second, type: Array, of: Integer
        end
      end

      its(:second) { should == [1, 2, 3, 4] }
    end

    context 'date: "05/10/1990 second"' do
      subject do
        Obtions.parse("05/10/1990 second") do
          arg :birthday, type: Date, format: '%d/%m/%Y'
          arg :second
        end
      end

      its(:birthday) { should == Date.strptime('05/10/1990', '%d/%m/%Y') }
    end

    context "file: \"#{Obtions::DATADIR}/test_file.txt second\"" do
      subject do
        Obtions.parse("#{Obtions::DATADIR}/test_file.txt second") do
          arg :file, type: File
          arg :second
        end
      end

      context 'file contents' do
        specify { subject.file.read.should == "I aim to misbehave.\n" }
      end
    end
  end

  context 'default values' do
    subject do
      Obtions.parse("test") do
        flag :p, default: true

        arg :first, default: "nope"
        arg :second, default: "yep"
      end
    end

    its(:p?)     { should be_true }
    its(:first)  { should == "test" }
    its(:second) { should == "yep" }
  end
end
