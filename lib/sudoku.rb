require 'pp'
require 'pry'

# Basic Sudoku Solver
module Sudoku
  DIGITS = (1..9).to_a

  # Puzzle is a flat Array of integers.
  # 0 or '.' represents an unknown cell.
  class Puzzle < Array
    attr_accessor :iterations

    def self.parse(text)
      data = text.gsub(/[^0123456789.]/, '').chars.map(&:to_i)
      Puzzle.new(data)
    end

    # x: 0-8 index of row
    def row(x)
      self[x * 9, 9]
    end

    # y: 0-8 index of column
    def column(y)
      Array.new(9) { |j| self[j * 9 + y] }
    end

    # i: any element in puzzle array
    def box(i)
      xy = i / 27 * 27 + i % 9 / 3 * 3 # 0,3,6,27,30,33,54,57,60
      self[xy, 3] + self[xy + 9, 3] + self[xy + 18, 3]
    end

    # @return [Array<Int>] of possible numbers for any square.
    def choices(i)
      DIGITS - row(i / 9) - column(i % 9) - box(i)
    end

    def backtrack(puzzle)
      puzzle.iterations += 1
      puzzle.each_with_object({}).with_index { |(n, acc), i| 
        n.zero? and acc[i] = puzzle.choices(i) and acc[i].empty? and return false
      }.sort_by { |_i, v| v.size }.each do |i, sorted|
        sorted.each do |c|
          puzzle[i] = c
          return puzzle if backtrack(puzzle)
        end
        puzzle[i] = 0
        return false
      end
    end

    def solve
      copy = dup
      copy.iterations = 0
      backtrack(copy)
    end

    def to_s
      each_with_object([]).with_index do | (n,acc), i|
        acc << "\n#{'-' * 29}" if [27,54].include?(i)
        if i % 9 == 0
          acc << "\n" 
        elsif i % 3 == 0
          acc << '|'
        end
        acc << " #{n} "
      end.join
    end

    def render
      puts "#{self}\n\n#{"iterations: #{iterations}\n\n" if iterations}"
    end
  end

  def self.solve(raw)
    puzzle = Puzzle.parse(raw)
    puzzle.render

    if (solved = puzzle.solve)
      solved.render
    else
      puts 'No solution found :('
    end
  end
end
