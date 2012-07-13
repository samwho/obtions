describe Obtions do
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
        flag :s, as: "silent"
      end
    end

    its(:silent)  { should be_true }
    its(:silent?) { should be_true }
  end

  context 'flags with input: "-p first second"' do
    subject do
      Obtions.parse("-p") do
        flag :p

        arg as: "first"
        arg as: "second"
      end
    end
  end
end
