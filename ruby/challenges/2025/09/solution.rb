# frozen_string_literal: true
require 'pp'
require 'rainbow/refinement'
require 'parallel'
using Rainbow

Pos = Data.define(:col, :row)
class Edge
  def initialize(a, b)
    if a.col == b.col
      @a, @b = [a, b].minmax_by{_1.row}
      @type = :|
    else
      @a, @b = [a, b].minmax_by{_1.col}
      @type = :-
    end
  end
  attr_accessor :a
  attr_accessor :b
  attr_accessor :type

  def to_s() "Edge<a=#{@a}, b=#{@b}>" end

  def intersect?(other_edge)
    return false if @type == other_edge
    case @type
    when :-
      @a.col < other_edge.a.col and other_edge.a.col < @b.col \
      and other_edge.a.row < @a.row and @a.row < other_edge.b.row
    when :|
      @a.row < other_edge.a.row and other_edge.a.row < @b.row \
      and other_edge.a.col < @a.col and @a.col < other_edge.b.col
    end
  end
end

module Year2025
  class Day09 < Solution
    def locs
      data.map{ col, row = _1.split(',').map(&:to_i); Pos.new(col, row) }
    end

    def size(a, b)
      w = (a.col - b.col).abs + 1
      h = (a.row - b.row).abs + 1
      w*h
    end

    def part_1
      locs.combination(2).map{size(_1, _2)}.max
    end

    $CACHE = {}
    def is_inside_polygon?(point, locs_pair)
      return $CACHE[point] if not $CACHE[point].nil?
      if locs.include? point
        $CACHE[point] = true
        return $CACHE[point]
      end

      # angle sum (alternatives are ray casting & line-segment intersection)
      angle = 0
      for v1, v2 in locs_pair
        x, y = point.col, point.row
        x1, y1 = v1.col, v1.row
        x2, y2 = v2.col, v2.row

        theta1 = Math::atan2(y1-y, x1-x)
        theta2 = Math::atan2(y2-y, x2-x)
        dtheta = theta2 - theta1
        while dtheta >= Math::PI
          dtheta -= 2 * Math::PI
        end
        while dtheta <= -Math::PI
          dtheta += 2 * Math::PI
        end
        angle+=dtheta
      end
      res = angle.abs > Math::PI
      $CACHE[point] = res

      $CACHE[point]
    end

    def display # for debug purpose
      polygon = locs
      locs_pair = (polygon + [polygon[0]]).each_cons(2).to_a
      print "\n"
      for row in (0..12)
        line_chars = []
        for col in (0..12)
          pos = Pos.new(col, row)
          is_point = polygon.include? pos

          if is_point
            line_chars.push '#'.red
          elsif is_inside_polygon?(pos, locs_pair)
            line_chars.push 'X'.green
          else
            line_chars.push '.'
          end
        end
        print line_chars.join + "\n"
      end
    end

    def get_corners(a, b)
      start_col, end_col = [a.col, b.col].minmax
      start_row, end_row = [a.row, b.row].minmax
      [
        Pos.new(start_col, start_row), Pos.new(end_col, start_row),
        Pos.new(end_col, end_row), Pos.new(start_col, end_row),
      ]
    end

    def get_edges(a, b)
      corners = get_corners(a, b)
      (corners + [corners[0]]).each_cons(2).map{ Edge.new(_1, _2) }
    end

    def is_edge_intersects_polygon?(given_edge, edges)
      return $CACHE[given_edge] if not $CACHE[given_edge].nil?
      is_intersect_edge_found = edges.any?{given_edge.intersect? _1}
      $CACHE[given_edge] = is_intersect_edge_found
      $CACHE[given_edge]
    end

    def part_2
      # display
      polygon = locs
      locs_pair = (polygon + [polygon[0]]).each_cons(2).to_a
      edges = locs_pair.map{Edge.new(_1, _2)}
      res = Parallel.map(polygon.combination(2)){|a, b|
        # fuck it, too lazy to improve performance
        next nil if a.row == b.row or a.col == b.col
        is_all_corners_inside = get_corners(a, b).all?{|corner| is_inside_polygon?(corner, locs_pair)}
        if is_all_corners_inside then [a, b, size(a, b)] else nil end
      }.compact.sort_by{_3}.reverse.each {|a,b,size|
        is_all_edges_no_cuts = get_edges(a, b).all?{|edge| !is_edge_intersects_polygon?(edge, edges)}
        return size if is_all_edges_no_cuts
      }
    end

  end
end
