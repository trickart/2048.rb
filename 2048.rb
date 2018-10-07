#!/bin/ruby

require 'io/console'
require 'color_echo'

#Color
CE.pickup(" 2  ", :black, :index231).pickup(" 4  ", :black, :index230).pickup(" 8  ", :index16, :index215).pickup(" 16 ", :index16, :index209).pickup(" 32 ", :index16, :index210).pickup(" 64 ", :index16, :index203).pickup("128 ", :black, :index223).pickup("256 ", :black, :index223).pickup("512 ", :black, :index222).pickup("1024", :black, :index222).pickup("2048", :black, :index221)

class Board
  attr_reader :empty_cells, :moved, :score
  def initialize()
    @board = Array.new(4).map{Array.new(4,0)}
    @empty_cells
    @score = 0
    @moved = 0
    self.pop
    self.pop
  end
  def pop
    @empty_cells = Array.new
    @board.each_with_index{|line,i|
      line.each_with_index{|cell,j|
        if cell == 0
          @empty_cells.push([i,j])
        end
      }
    }
    tile = empty_cells.shuffle!.pop
    @board[tile[0]][tile[1]] = (rand < 0.9 ? 2 : 4)
  end
  def print
    puts "┌────┬────┬────┬────┐ SCORE:#{@score}"
    @board.each_with_index{|line, i|
      row = "│"
      line.each{|cell|
        tile = (cell != 0 ? cell.to_s.center(4) : "    ")
        row << "#{tile}│"
      }
      puts row
      if i != 3
        puts "├────┼────┼────┼────┤"
      end
    }
    puts "└────┴────┴────┴────┘"
  end

  def checkmate
    @h_movable = 0
    @board.each{|line|
      for i in 0..2 do
        if line[i] == line[i+1]
          @h_movable = 1
          break
        end
      end
      if @h_movable == 1
        break
      end
    }
    @v_movable = 0
    for j in 0..3 do
      for i in 0..2 do
        if @board[i][j]== @board[i+1][j]
          @v_movable = 1
          break
        end
      end
      if @v_movable == 1
        break
      end
    end
    return [@h_movable, @v_movable]
  end

  def left
    @moved = 0
    if self.empty_cells.length != 0 || self.checkmate[0] == 1 then
      @board.each{|line|
        #merge
        for i in 0..2 do
          j = i+1
          while line[j] != nil
            if line[i] != 0 && line[i] == line[j]
              line[i] *= 2; @score += line[i]
              line[j] = 0
              @moved = 1
              break
            elsif line[j] == 0
              j += 1
              next
            else
              break
            end
          end
        end
        #move
        3.times{
          for i in 0..2 do
            if line[i] == 0 && line[i+1] != 0
              line[i], line[i+1] = line[i+1], line[i]
              @moved = 1
            end
          end
        }
      }
    else
    end
  end
  def right
    @board.each{|line|
      line.reverse!
    }
    self.left
    @board.each{|line|
      line.reverse!
    }
  end
  def up
    @moved = 0
    if self.empty_cells.length != 0 || self.checkmate[1] == 1 then
      for j in 0..3 do
        #merge
        for i in 0..2 do
          k = i+1
          while @board[k] != nil
            if @board[i][j] != 0 && @board[i][j] == @board[k][j]
              @board[i][j] *= 2; @score += @board[i][j]
              @board[k][j] = 0
              @moved = 1
              break
            elsif @board[k][j] == 0
              k += 1
              next
            else
              break
            end
          end
        end
        #move
        3.times{
          for i in 0..2 do
            if @board[i][j] == 0 && @board[i+1][j] != 0
              @board[i][j], @board[i+1][j] = @board[i+1][j], @board[i][j]
              @moved = 1
            end
          end
        }
      end
    end
  end
  def down
    @board.reverse!
    self.up
    @board.reverse!
  end
end

board = Board.new

board.print

while (input = STDIN.getch) != "\C-c"
  case input
  when "\e" then
    second_key = STDIN.getch
    if second_key == "["
      arrow = STDIN.getch
      case arrow
      when "D" then
        board.left
      when "C" then
        board.right
      when "A" then
        board.up
      when "B" then
        board.down
      end
      if board.moved == 1
        board.pop
        board.print
      end
      if board.empty_cells.length == 0 && board.checkmate == [0, 0]
        puts "GAME OVER!"
        exit
      end
    end
  end
end

