#CURRENTLY UNUSED

# class Counter
#   attr_reader :color_trackers

#   def initialize(color_counters)
#     @color_counters = make_counters(color_counters)
#   end

#   def make_counters(array)
#     counters = {}
#     array.each do |element|
#       if !counters[element]
#         counters[element] = 0
#       end
#       counters[element] = counters[element] + 1
#     end
#     counters
#   end
# end