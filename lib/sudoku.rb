require 'pp'
require 'pry'
# Basic Sudoku Solver
module Sudoku
  DIGITS = (1..9).to_a

  # Internal data if flat array of numbers
  class Puzzle < Array
    def self.parse(text)
      data = text.gsub(/\D/, '').chars.map(&:to_i)
      Puzzle.new(data)
    end

    def each_row
      9.times { |x| yield row(x), x }
    end

    # x: 0-8 index of row
    def row(x)
      self[x * 9, 9]
    end

    def each_column
      9.times { |y| yield column(y), y }
    end

    # y: 0-8 index of column
    def column(y)
      Array.new(9) { |j| self[j * 9 + y] }
    end

    def each_area
      3.times { |i| 3.times { |j| yield area(i, j), i, j } }
    end

    # x: 0-2, y: 0-2
    def area(x, y)
      area_off(x * 27 + y * 3)
    end

    # xy: 0,3,6,27,30,33,54,57,60
    def area_off(xy)
      self[xy, 3] + self[xy + 9, 3] + self[xy + 18, 3]
    end

    # @return [Array<Int>] of possible numbers for any square.
    def can_at(i)
      DIGITS - (row(i / 9) | column(i % 9) | area_off(i / 27 * 27 + i % 9 / 3 * 3))
    end

    def apply_singles(puzzle)
      puzzle.candidates.select { |k, v|
        v.size == 1 && puzzle[k] = v[0]
      }.any? && apply_singles(puzzle)
      puzzle
    end

    def validate!
      each_row { |digits, x| digits.sort == DIGITS || fail("Incomplete row: #{x}")}
      each_column { |digits, y| digits.sort == DIGITS || fail("Incomplete column: #{y}")}
      each_area { |digits, x,y| digits.sort == DIGITS || fail("Incomplete area: #{x}/#{y}")}
    end

    def solve
      solved = apply_singles(Puzzle.new(self.dup))
      solved.validate!
      solved
    end

    def candidates
      each_with_object({}).with_index { |(n, acc), i| n == 0 && acc[i] = can_at(i) }
    end

    def render
      each_row do |r, i|
        puts [r[0, 3].join, r[3, 3].join, r[6, 3].join].join('|')
        puts '-' * 11 if i == 2 || i == 5
      end
    end
  end

  def self.solve(raw)
    puzzle = Puzzle.parse(raw)
    puzzle.render

    solved = puzzle.solve
    puts "\n\n=== solved ==="
    solved.render
  end
end
