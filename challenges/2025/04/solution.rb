# frozen_string_literal: true
module Year2025
  class Day04 < Solution

    def get_adjacent(r, c)
      return [
        [r-1, c-1], [r-1, c], [r-1, c+1],

        [r, c-1],             [r, c+1],

        [r+1, c-1], [r+1, c], [r+1, c+1],
      ]

    end

    def get_pos(map, r, c)
      lim = data.size
      return nil if data[r].nil?
      return nil if r < 0 or c < 0 or r >= lim or c >= lim
      data[r][c]
    end

    def part_1
      res = 0
      for row in 0..data.size
        for col in 0..data.size
          cur = get_pos(data, row, col)
          res += 1 if (
            cur == '@' \
            and get_adjacent(row, col).count{get_pos(data, _1, _2) == '@'} < 4
          )
        end
      end
      res
    end

    def part_2
      $L = data.size
      map = data
      res = 0

      loop do
        to_update = []
        for row in 0..$L
          for col in 0..$L
            cur = get_pos(map, row, col)

            if (
              cur == '@' \
              and get_adjacent(row, col).count{get_pos(map, _1, _2) == '@'} < 4
            )
              to_update += [[row, col]]
            end
          end
        end
        break if to_update.empty?

        for r,c in to_update
          map[r][c] = '.'
        end

        res += to_update.size
      end

      res
    end

  end
end
