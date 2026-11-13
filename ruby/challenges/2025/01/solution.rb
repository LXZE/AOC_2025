# frozen_string_literal: true
module Year2025
  class Day01 < Solution
    def parse(line)
      [line[0], line[1..].to_i.divmod(100)[1]]
    end

    def parse_raw(line)
      [line[0], line[1..].to_i]
    end

    def part_1
      zero_found = 0
      pointer = 50
      data.map{parse _1}.each{
        cmd, count = _1
        case cmd
          when "L" then pointer -= count
          when "R" then pointer += count
        end

        if pointer < 0
          pointer += 100
        elsif pointer > 99
          pointer -= 100
        end

        zero_found += 1 if pointer == 0
      }
      zero_found
    end

    def calculate_over_zero(from, to)
      range = if from > to # target to left
        (to..(from-1))
      else # target to right
        ((from+1)..to)
      end

      _, new_pointer = to.divmod(100)
      new_pointer += 100 if new_pointer < 0
      [new_pointer, range.count{_1 % 100 == 0}]
    end

    def part_2
      zero_found = 0
      pointer = 50
      data.map{parse_raw _1}.each{
        cmd, count = _1
        pointer, zeros = case cmd
          when "L" then calculate_over_zero(pointer, pointer - count)
          when "R" then calculate_over_zero(pointer, pointer + count)
        end
        zero_found += zeros
      }
      zero_found
    end
  end
end
