# frozen_string_literal: true
module Year2025
  class Day03 < Solution

    def max_jolt(bank)
      ('1'..'9').reverse_each {|n|
        idx_from = bank.index(n)
        next if idx_from.nil?
        latter = bank[(idx_from+1)..]
        ('1'..'9').reverse_each {|m|
          idx_to = latter.index(m)
          next if idx_to.nil?
          return "#{n}#{m}".to_i
        }
      }
    end

    def recursive_max_jolt(bank, vals = [])
      return vals.join('').to_i if vals.size == 12
      return nil if bank.size == 0

      ('1'..'9').reverse_each {|n|
        idx = bank.index(n)
        next if idx.nil?
        res = recursive_max_jolt(bank[(idx+1)..], vals + [n])
        return res if not res.nil?
      }
      nil
    end

    def part_1
      data.map{max_jolt _1}.sum
    end

    def part_2
      data.map{recursive_max_jolt _1}.sum
    end
  end
end
