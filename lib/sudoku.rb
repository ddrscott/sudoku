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
      result = []
      9.times do |i|
        r = row(i)
        result << [r[0, 3].join(' '), r[3, 3].join(' '), r[6, 3].join(' ')].join(' | ').tr('0', '.')
        result << '-' * 21 if i == 2 || i == 5
      end
      result.join("\n")
    end

    def render
      puts "#{self}\n iterations: #{iterations}\n\n"
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
