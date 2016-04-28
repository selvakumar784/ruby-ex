
class Polynomial
  def initialize(list)
    @list = list
  end
  def print_polynomial
    pol_string = ""
    valid = 0
    
    #Calculate valid co-efficients
    @list.each {|x| valid += 1 if x != 0}
    
    if valid <= 1
      pol_string += "Need atleast 2 coefficients"
    else
      #Calculte maximum power
      power = @list.length - 1
      for coeff in 0..power - 1 do 
        #If a co-efficient is 0, decrement power by 1
        if @list[coeff] == 0
          power -= 1
        #If a co-efficient is -ve, add it the result string directly
        elsif @list[coeff] < 0
          if @list[coeff] != -1
            if power == 1
              pol_string += "#{@list[coeff]}X"
            else
              pol_string += "#{@list[coeff]}X^#{power}"
            end
          else
            if power == 1
              pol_string += "-X"
            else
              pol_string += "-X^#{power}"
            end
          end
          power -= 1
        #If a co-efficient is -ve, add it the result string,
        #check differnt conditions and do processing on the 
        #result string
        elsif @list[coeff] > 0
          if @list[coeff] != 1
            if power == 1 
              pol_string += "+#{@list[coeff]}X"
            elsif power == @list.length - 1
              pol_string += "#{@list[coeff]}X^#{power}"
            else
              pol_string += "+#{@list[coeff]}X^#{power}"
            end
          else
            if power == 1
              if pol_string.length == 0
                pol_string += "X"
              else
                pol_string += "+X"
              end
            elsif power == @list.length - 1
              pol_string += "X^#{power}"
            else
              if pol_string.length != 0
                pol_string += "+X^#{power}"
              else
                pol_string += "X^#{power}"
              end
            end
          end
          power -= 1
        end
      end
      coeff = coeff + 1
      #Add constant to the result string
      if @list[coeff] > 0
        if pol_string.length > 0
          pol_string += "+#{@list[coeff]}" 
        else
          pol_string += "#{@list[coeff]}" 
        end
      elsif list[coeff] < 0
          pol_string += "#{@list[coeff]}" 
      end
    end
    pol_string
  end
end


list1 = [-3, -4, 1, 0, 6]
list2 = [1,0,2]
list3 = [0, 1, 0, 0, 0]
result_list1 = Polynomial.new(list1).print_polynomial
result_list2 = Polynomial.new(list2).print_polynomial
result_list3 = Polynomial.new(list3).print_polynomial

puts result_list1
puts result_list2
puts result_list3

