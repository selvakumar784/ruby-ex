
def skip_tracks(arr_cpy, i)
  start = inc = i % arr_cpy.size()
  count = 1

  while inc > 0 && count < arr_cpy.size() do
    c = start
  
    while (c + inc) % arr_cpy.size != start
      before = (c - inc) % arr_cpy.size()
      arr_cpy[before], arr_cpy[c] = arr_cpy[c], arr_cpy[before]
      count = count + 1
      c = c + 1
    end
    count = count + 1
    start = start - 1
  end
  arr_cpy
end

def skip_tracks_ruby(arr_cpy, n)
  arr_cpy.rotate(n)
end

arr = ["Gilly", "Pokkiri", "Thuppakki", "Kaththi", "Theri"]

res_ruby = skip_tracks_ruby(arr, 2)
res_ruby1 = skip_tracks_ruby(arr, -2)

puts res_ruby
puts "\n"
puts res_ruby1
puts "\n"