require 'spec_helper'

describe Sudoku do
  let(:hard){'
    000|000|012
    000|000|003
    002|300|400
    -----------
    001|800|005
    060|070|800
    000|009|000
    -----------
    008|500|000
    900|040|500
    470|006|000'
  }

  let(:easy){'
    040|805|20.
    020|040|050
    500|000|004
    -----------
    090|003|120
    106|078|003
    370|904|080
    -----------
    000|006|700
    008|359|010
    019|007|600'
  }

  it 'solves' do
    Sudoku.solve(easy)
  end

  xit 'profile' do
    require 'ruby-prof'
    result = RubyProf.profile do
      solved = puzzle.solve
      solved.render
    end

    puts "Generating profile results..."
    printer = RubyProf::GraphHtmlPrinter.new(result)
    file = "profile-#{Time.now.to_i}.html"
    File.open(file, 'w'){|f| printer.print(f)}
    `open #{file}`
  end
end
