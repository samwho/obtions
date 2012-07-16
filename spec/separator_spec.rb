describe Obtions::Separator do
  context 'simple string separators' do
    subject do
      Obtions.parse do
        separator "This is a separator."
      end
    end

    its(:help) { should include "This is a separator." }
  end

  context 'content from file' do
    subject do
      Obtions.parse do
        separator file: "#{Obtions::DATADIR}/test_file.txt"
      end
    end

    its(:help) { should include "I aim to misbehave." }
  end

  context 'invalid file name' do
    it "should raise an error" do
      expect do
        Obtions.parse do
          separator file: "#{Obtions::DATADIR}/non/existing/file.txt"
        end
      end.to raise_error(Errno::ENOENT)
    end
  end

  context 'invalid data type' do
    it "should raise an error" do
      expect do
        Obtions.parse do
          separator 10
        end
      end.to raise_error(Obtions::InvalidType)
    end
  end
end
