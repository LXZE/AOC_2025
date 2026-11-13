# frozen_string_literal: true
require 'pp'
require 'z3'

module Year2025
  class Day10 < Solution

    def parse_line(line)
      head, rem = line.split(' ', 2)
      *data, tail = rem.split(' ')
      lights = head.chars[1...-1].map{|c| if c == '.' then 0 else 1 end}
      buttons_set = data.map{|elem| elem[1...-1].split(',').map(&:to_i)}
      voltages = tail[1...-1].split(',').map(&:to_i)
      [lights, buttons_set, voltages]
    end

    def update_state(state, pushed_buttons)
      new_state = state.clone
      pushed_buttons.each{|b| new_state[b] = (new_state[b] + 1) % 2}
      new_state
    end

    def part_1
      data.map{|line|
        target_state, buttons_set, _ = parse_line(line)

        states = { Array.new(target_state.size, 0) => [] }
        while not states.include? target_state
          new_states = {}
          for prev_state, procedures in states
            buttons_set.each{|buttons|
              new_state = update_state(prev_state, buttons)
              next if new_state.all?(0) or states.include?(new_state)
              new_states[new_state] = procedures + [buttons]
            }
          end
          states = new_states
        end
        states[target_state].size
      }.sum
    end

    def part_2
      data.map{|line|
        _, buttons_set, target_state = parse_line(line)

        solver = Z3::Optimize.new
        voltages_vars = Array.new(target_state.size, nil)
        vars = buttons_set.zip(0..).map{|buttons, coef|
          var = Z3.Int(coef.to_s)
          solver.assert(var >= 0)
          buttons.each{|button|
            if voltages_vars[button].nil?
              voltages_vars[button] = var
            else
              voltages_vars[button] += var
            end
          }
          var
        }
        target_state.zip(voltages_vars).each{ solver.assert(_1 == _2) }
        solver.minimize(Z3.Add(*vars))
        raise 'Unsolvable' if !solver.satisfiable?
        solver.model.to_h.values.map(&:to_i).sum
      }.sum
    end
  end
end
