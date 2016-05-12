class Polynomial
  def initialize(list)
    @list = list
  end

  #Covert a term to string
  def term_to_str(coeff, exp)
    term_str = ""
    coeff = coeff.abs
    term_str = coeff.to_s unless coeff == 1 && exp > 0
    term_str += "X" if exp > 0
    term_str += "^" + exp.to_s if exp > 1
    term_str
  end

  def make_poly_str
    poly_str = ""
    exp_len = @list.length - 1
    exponents = []
    coefficients = []

    #Create a list for coefficients
    @list.each { |x| coefficients.push(x)}
    
    #Create a list for exponents
    for i in exp_len.downto(0) do
      exponents.push(i)
    end

    coefficients.each_with_index do |coeff, index|
      exp = exponents[index]
      next if coeff == 0
      if index == 0
        poly_str = (if coeff < 0 then "-" else "" end)   + term_to_str(coeff, exp)
      else
        poly_str += (if coeff < 0 then "-" else "+" end)   + term_to_str(coeff, exp)
      end
    end
    poly_str
  end

  def print_polynomial
    coeff_count = 0

    #Calculate valid co-efficients
    @list.each {|x| coeff_count += 1 if x != 0}
    if coeff_count <= 1
      "Need atleast 2 coefficients"
    else
      make_poly_str
    end
  end 
end

test1 = [-3, -4, 1, 0, 6]
test2 = [1,0,2]
test3 = [0, 1, 0, 0, 0]
result1 = Polynomial.new(test1).print_polynomial
result2 = Polynomial.new(test2).print_polynomial
result3 = Polynomial.new(test3).print_polynomial

puts result1
puts result2
puts result3