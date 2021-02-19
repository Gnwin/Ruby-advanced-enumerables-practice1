# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/ModuleLength
module Enumerable
  # 3.
  def my_each
    block_given? ? length.times { |idx| yield(self[idx]) } : to_enum(__method__)
  end

  # 4.
  def my_each_with_index
    block_given? ? length.times { |idx| yield(self[idx], idx) } : to_enum(__method__)
  end

  # 5.
  def my_select
    if block_given?
      ary = []
      my_each do |e|
        ary << e if yield(e)
      end
      ary
    else
      to_enum(__method__)
    end
  end

  # 6.
  def my_all?(word = nil)
    all = true

    my_type = lambda do |f|
      my_each do |r|
        unless r.instance_of?(f)
          all = !all
          break
        end
      end
      all
    end

    if block_given? && word.nil?
      my_each do |e|
        unless yield(e)
          all = !all
          break
        end
      end
      all
    elsif !block_given?
      if word == Regexp
        my_each do |e|
          if e != word
            all = !all
            break
          end
        end
        all
      elsif word == Numeric
        my_each do |e|
          unless e.is_a? word
            all = !all
            break
          end
        end
        all
      elsif word == Integer
        my_type.call(Integer)
      elsif word == Float
        my_type.call(Float)
      elsif word == Symbol
        my_type.call(Symbol)
      elsif word == String
        my_type.call(String)
      elsif word.instance_of?(Regexp)
        my_each do |e|
          unless word.match(e)
            all = !all
            break
          end
        end
        all
      elsif word.nil?
        my_each do |e|
          if !e || e.nil?
            all = !all
            break
          end
        end
        all
      elsif empty?
        all
      end
    else
      to_enum(__method__)
    end
  end

  # 7.
  def my_any?(word = nil)
    any = false

    my_type1 = lambda do |j|
      my_each do |d|
        if d.instance_of?(j)
          any = !any
          break
        end
      end
      any
    end

    if block_given? && word.nil?
      ary = []
      idx = 0
      my_each do |e|
        ary << yield(e)
        idx += 1
      end
      ary.my_each do |e|
        if e
          any = !any
          break
        end
      end
      any
    elsif !block_given?
      if word == Regexp || word.instance_of?(Regexp)
        my_each do |e|
          if e == Regexp || e.instance_of?(Regexp)
            any = !any
            break
          end
        end
        any
      elsif word == Numeric
        my_each do |e|
          if e.is_a? word
            any = !any
            break
          end
        end
        any
      elsif word == Integer
        my_type1.call(Integer)
      elsif word == Float
        my_type1.call(Float)
      elsif word == Symbol
        my_type1.call(Symbol)
      elsif word.nil?
        my_each do |e|
          if e
            any = !any
            break
          end
        end
        any
      elsif empty?
        any
      end
    else
      to_enum(__method__)
    end
  end

  # 8.
  def my_none?(word = nil)
    none = true

    my_type2 = lambda do |v|
      my_each do |y|
        if y.instance_of?(v)
          none = !none
          break
        end
      end
      none
    end

    if block_given? && word.nil?
      my_each do |e|
        if yield(e)
          none = !none
          break
        end
      end
      none
    elsif !block_given?
      if word == Regexp || word.instance_of?(Regexp)
        my_each do |e|
          if e == word || e.instance_of?(Regexp)
            none = !none
            break
          end
        end
        none
      elsif word == Numeric
        my_each do |e|
          if e.is_a? word
            none = !none
            break
          end
        end
        none
      elsif word == Integer
        my_type2.call(Integer)
      elsif word == Float
        my_type2.call(Float)
      elsif word == Symbol
        my_type2.call(Symbol)
      elsif word.nil?
        each do |e|
          if e
            none = !none
            break
          end
        end
        none
      elsif empty?
        none
      end
    else
      to_enum(__method__)
    end
  end

  # 9.
  def my_count(num = nil)
    count = 0
    if block_given? && num.nil?
      return 'A block is passed and there are no elements in your array' if empty?

      my_each do |e|
        count += 1 if yield(e)
      end
      count
    elsif !block_given?
      if num.instance_of?(Integer)
        return 'The argument is an Integer and there are no elements in your array' if empty?

        count = num
      elsif num.nil? && empty?
        count = length
      elsif num.nil?
        count = length
      elsif empty?
        count
      end
    else
      to_enum(__method__)
    end
  end

  # 10.
  def my_map
    arr = nil
    my_type = lambda do |type|
      arr = instance_of?(type) ? to_a : self
    end
    my_type.call(self.class)

    if block_given?
      ary = []
      arr.my_each do |e|
        ary << yield(e)
      end
      ary
    else
      to_enum(__method__)
    end
  end

  # 11.
  def my_inject(arg = nil)
    arr = nil

    my_type = lambda do |type|
      arr = instance_of?(type) ? to_a : self
    end

    my_type.call(self.class)

    if block_given?
      if arg.nil?
        acc = 0
        acc = arr[0] if arr.my_all?(String)
      else
        acc = arg
      end
      arr.my_each do |e|
        acc = yield(acc, e)
      end
      acc
    else
      to_enum(__method__)
    end
  end

  # 13. proc defined in method and used with block(&)
  # def my_map_proc(&proc_arg)

  #   arr = nil
    
  # 	my_type = lambda do |type|
  # 		arr = self.instance_of?(type) ? self.to_a : self
  #   end
    
  # 	my_type.call(self.class)

  # 	if proc_arg
  #     ary = []
      
  # 		arr.my_each do |e|
  # 			ary << proc_arg.call(e)
  #     end
      
  # 		ary
  # 	else
  # 		to_enum(__method__)
  #   end
    
  # end

  # 13. proc defined in method and used with yield
  # def my_map_proc(proc = nil)

  # 	arr = nil
  # 	my_type = lambda do |type|
  # 		arr = self.instance_of?(type) ? self.to_a : self
  #   end
    
  #   my_type.call(self.class)
    
  #   if block_given?
      
  # 		proc = Proc.new do |num|
  # 			yield(num)
  #     end
      
  #     ary = []
      
  # 		arr.my_each do |e|
  # 			ary << proc.call(e)
  # 		end
  # 		ary
  # 	else
  # 		to_enum(__method__)
  #   end
    
  # end

  # 13. proc defined in parameters(deprecated)
  # def my_map_proc (proc_arg = Proc.new)

  # 	arr = nil
  # 	my_type = lambda do |type|
  # 		arr = self.instance_of?(type) ? self.to_a : self
  # 	end
  #   my_type.call(self.class)
    
  # 	if proc_arg || !proc_arg.nil?
  # 		ary = []
  # 		arr.my_each do |e|
  # 			ary << proc_arg.call(e)
  # 		end
  # 		ary
  # 	else
  # 		to_enum(__method__)
  #   end
    
  # end

  # 13.
  def my_map_proc(proc_arg = nil)
    arr = nil
    my_type = lambda do |type|
      arr = instance_of?(type) ? to_a : self
    end
    my_type.call(self.class)

    if proc_arg.instance_of? Proc
      ary = []
      arr.my_each do |e|
        ary << proc_arg.call(e)
      end
      ary
    else
      to_enum(__method__)
    end
  end

  # 14.
  def my_map_proc_or_block(proc_arg = nil, &block)
    arr = nil
    my_type = lambda do |type|
      arr = instance_of?(type) ? to_a : self
    end
    my_type.call(self.class)

    if proc_arg.instance_of? Proc and block
      to_enum(__method__)
    elsif proc_arg.instance_of? Proc
      ary = []
      arr.my_each do |e|
        ary << proc_arg.call(e)
      end
      ary
    elsif block
      ary = []
      arr.my_each do |e|
        ary << block.call(e)
      end
      ary
    else
      to_enum(__method__)
    end
  end
end

# 12.
def multiply_els(val = nil)
  if block_given? && !val.nil?
    acc = 1
    val.my_inject do |_s, e|
      acc = yield(acc, e)
    end
    acc
  else
    to_enum(__method__)
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity

arr = [1, 2, 3, 4, 5]
# ary = [1, 2, 4, 2]
# ary = []

# arr.my_each { |e| puts e }
# arr.my_each_with_index { |v, i| puts "#{v} and #{i}" }

# p arr.my_select { |e| e != 2 }

# puts arr.my_all? { |e| e == 2 }
# puts %w[ant bear cat].my_all? { |word| word.length >= 3 }
# puts %w[ant bear cat].my_all? { |word| word.length >= 4 }
# puts %w[ant bear cat].my_all?(/a/)
# puts [1, 2i, 3.14].my_all?(Numeric) #=> true
# puts [nil, true, 99].my_all? #=> false
# puts [].my_all?
# puts [1, 2i, 3.14].my_all?(3) {|word| word == 3}                             #=> err enumerable

# puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# puts %w[ant bear cat].my_any?(/d/)                        #=> false
# puts [nil, true, 99].my_any?(Integer)                     #=> true
# puts [nil, true, 99].my_any?                              #=> true
# puts [].my_any?                                           #=> false

# puts %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
# puts %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
# puts %w[ant bear cat].my_none?(/d/) #=> true
# puts [1, 3.14, 42].my_none?(Float) #=> false
# puts [].my_none? #=> true
# puts [nil].my_none? #=> true
# puts [nil, false].my_none? #=> true
# puts [nil, false, true].my_none? #=> false

# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count{ |x| x%2==0 } #=> 3
# puts ary.my_count(2) { |x| x%2==0 } #=> 3

# p arr.my_map { |e| e + 2 }

# puts arr.my_inject { |sum, n| sum + n }
# puts (5..10).my_inject { |sum, n| sum + n }
# puts (5..10).my_inject(2) { |sum, n| sum * n }
# puts %w{ cat sheep bear }.my_inject { |memo, word| longest = memo.length > word.length ? memo : word }

# puts arr.multiply_els { |sum, n| sum * n }
# puts multiply_els(arr) { |sum, n| sum * n }

#-------------------------Proc
# proc = Proc.new { |num| num * 4 }
# p arr.my_map_proc(proc)

# p arr.my_map_proc { |num| num + 3 }
#--------------------------

#------------------------Proc or Block
# proc = Proc.new { |num| num + 2 }
# p arr.my_map_proc_or_block(proc)

# p arr.my_map_proc_or_block { |num| num + 2 }
#---------------------------

#------------------------Proc and Block
# proc = Proc.new { |num| num + 2 }
# p arr.my_map_proc_or_block(proc)

# p arr.my_map_proc_or_block(proc) { |num| num + 2 }
#---------------------------
