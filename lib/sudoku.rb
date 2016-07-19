module Sudoku
  DIGITS = (1..9).to_a

  class Puzzle < Array
    attr_accessor :iterations

    def self.parse(text)
      data = text.gsub(/[^0123456789.]/, '').chars.map(&:to_i)
      Puzzle.new(data)
    end

    def row(x)
      self[x * 9, 9]
    end

    def column(y)
      Array.new(9) { |j| self[j * 9 + y] }
    end

    def box(i)
      xy = i / 27 * 27 + i % 9 / 3 * 3 # 0,3,6,27,30,33,54,57,60
      self[xy, 3] + self[xy + 9, 3] + self[xy + 18, 3]
    end

    def choices(i)
      DIGITS - row(i / 9) - column(i % 9) - box(i)
    end

    def all_choices
      each_with_object({}).with_index do |(n, acc), i|
        n.zero? && (acc[i] = choices(i)) && acc[i].empty? && (return false)
      end.sort_by { |_i, v| v.size }
    end

    def backtrack(puzzle)
      puzzle.iterations += 1
      choices = puzzle.all_choices
      return false unless choices
      choices.each do |i, sorted|
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
      each_with_object([]).with_index do |(n, acc), i|
        acc << "\n#{'-' * 29}" if [27, 54].include?(i)
        if i % 9 == 0
          acc << "\n"
        elsif i % 3 == 0
          acc << '|'
        end
        acc << " #{n} "
      end.join
    end

    def render
      puts "#{self}\n\n#{iterations && "iterations: #{iterations}\n\n"}"
    end
  end

  def self.solve(raw)
    puzzle = Puzzle.parse(raw)
    if (solved = puzzle.solve)
      solved.render
    else
      puzzle.render
      puts 'No solution found :('
    end
  end
end
