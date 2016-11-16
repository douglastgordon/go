# Go

This is an terminal version of the popular board game Go, built using Ruby.

###Technical Details

To account for capturing, the program first finds all the contiguous groups of like pieces. The the program checks if any of the pieces in the group is adjacent to an empty tile. If it is, the group is not dead and will not be removed from the board. Otherwise it will. The score is updated accordingly.

In the snippet below, it is the job of kill_dead_groups to iterate over all existing groups and check to see if they are dead, which is the job of surrounding?(group).

```ruby
def kill_dead_groups
  groups = find_groups
  groups.each do |group|
    if surrounded?(group)
      @board.delete(group)
      update_score(group)
    end
  end
end

def surrounded?(group)
  group.each do |cell|
    neighbors = neighboring_cells(cell[0], cell[1])
    return false if neighbors["blank"] >= 1
  end
  true
end
```
