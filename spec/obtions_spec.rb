describe 'Obtions Base' do
  context 'parse' do
    context 'destructive' do
      it 'should clobber the initial array while parsing' do
        argv = ["-s", "arg", "spare"]

        out = Obtions.parse! argv do
          flag :s
          arg  :first
        end

        out.s?.should be_true
        out.first.should == "arg"

        argv.should == ["spare"]
      end

      it 'cannot work with strings' do
        argv = "-s arg spare"

        out = Obtions.parse! argv do
          flag :s
          arg  :first
        end

        out.s?.should be_true
        out.first.should == "arg"

        argv.should == "-s arg spare"

      end
    end

    context 'non-destructive' do
      it 'should not clobber the initial array while parsing' do
        argv = ["-s", "arg", "spare"]

        out = Obtions.parse argv do
          flag :s
          arg  :first
        end

        out.s?.should be_true
        out.first.should == "arg"

        argv.should == ["-s", "arg", "spare"]
      end
    end
  end

  context 'documentation' do
    context 'arguments' do
      subject do
        Obtions.parse "" do
          flag :s, long: :silent do
            "Silences all logging output."
          end

          named_arg :config do
            "Specify the location of the config file."
          end
        end
      end

      its(:help) { should include "Silences all logging output." }
      its(:help) { should include "Specify the location of the config file." }
    end

    context 'banner' do
      subject do
        Obtions.parse "input" do
          banner "Banner!"
        end
      end

      its(:help) { should start_with "Banner!" }
    end
  end
end
