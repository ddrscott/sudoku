require 'spec_helper'

describe Sudoku do
  let(:easy){File.read('spec/easy.txt')}

  let(:hard){File.read('spec/hard.txt')}

  it 'solves easy' do
    Sudoku.solve(easy)
  end

  it 'solves hard' do
    Sudoku.solve(hard)
  end
end
