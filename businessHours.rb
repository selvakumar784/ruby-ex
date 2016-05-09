require 'time'
require 'date'

class BusinessHours
  @@days = {"sun" => 6, "mon" => 0,
            "tue" => 1, "wed" => 2,
            "thu" => 3, "fri" => 4,
            "sat" => 5}
            
  @@h = Hash.new{|hsh, key| hsh[key] = []}
  
  def initialize(startTime, endTime, cur_date=Time.new.localtime.to_date)
    @startTime = startTime
    @endTime = endTime
    @cur_date = cur_date.to_s

    #Check if given date exists in the past.
    #If its a valid date, add an entry if the date doesn't exist already.
    temp_date = Date.parse @cur_date
    if temp_date < Time.new.localtime.to_date
      abort("The date is in past. Provide a valid entry.")
    else
      if @@h.has_key? cur_date
        abort("Entry exists already. You can only update.")
      else
        @@h[@cur_date].push @startTime
        @@h[@cur_date].push @endTime
      end
    end
  end
  
  def update(day_or_date, newStartTime, newEndTime)
    day_or_date = day_or_date.to_s
    
    #Convert given day to date
    if @@days.has_key? day_or_date
      day_id = @@days[day_or_date]
      datey = Date.today
      conv_date = (datey - datey.wday + day_id + 1).strftime
    else
      conv_date = day_or_date
    end
    
    conv_date = conv_date.to_s
    
    #Update the entries, based on the converted date.
    if @@h.length == 0
      abort("No entry exists. Please add an entry and update it.")
    else
      if @@h.has_key? conv_date
        @@h[conv_date][0] = newStartTime
        @@h[conv_date][1] = newEndTime
      else
        abort("Illegal entry to update. Given date/day doesnt exists. Please add.")
      end
    end
  end
  
  def closed(day_or_date)
    day_or_date = day_or_date.to_s
    
    #Convert day to date.
    if @@days.has_key? day_or_date
      day_id = @@days[day_or_date]
      datey = Date.today
      conv_date = (datey - datey.wday + day_id + 1).strftime
    else
      conv_date = day_or_date
    end
    
    conv_date = conv_date.to_s

    #Add Opening time and closing time as 0:00 for a given closed date.
    if @@h.has_key? conv_date
      @@h[conv_date][0] = "0:00"
      @@h[conv_date][1] = "0:00"
    else
      @@h[conv_date].push "0:00"
      @@h[conv_date].push "0:00"
    end
  end
  
  def calculate_deadline(timeInterval, startingTime)
    numSeconds = timeInterval
    startDate = startingTime.split(' ')[0]
    startTime = startingTime.split(' ')[1] + startingTime.split(' ')[2]
    
    #Sort the hash based on key
    @@h = Hash[@@h.sort_by{|k,v| k}] 
    
    total_length = 0
    total_length = @@h.length      
    
    openingTime = ""
    closingTime = ""
    cur_index = 0
    
    #Get the opening and closing time for a given request.
    @@h.each_with_index do |(key,value), index|
      if key == startDate
        openingTime = value[0]
        closingTime = value[1]
        cur_index = index
      end
    end    
      
    while cur_index < total_length
      
      #Convert the string to time objects
      start_str = "#{startDate} #{openingTime.split(" ")[0] + openingTime.split(" ")[1]}"  
      time_start = Time.parse(start_str)
      
      req_str = "#{startDate} #{startTime}"
      time_req = Time.parse(req_str)
      
      end_str = "#{startDate} #{closingTime.split(" ")[0] + closingTime.split(" ")[1]}"  
      time_end = Time.parse(end_str)
      
      
      if time_start <= time_req
        del_time = time_req + numSeconds
        if  del_time <= time_end
          puts del_time.strftime("%a %b %d %H:%M:%S %Y")
          break
        else
          diff_time = del_time - time_end
          openingTime = ""
          closingTime = ""
          flag = 0
          @@h.each_with_index do |(key, value), index|
            if index > cur_index
              openingTime = value[0]
              closingTime = value[1]
              if openingTime != "0:00" && closingTime != "0:00"
                startDate = key
                flag = 1
                cur_index = index
                startTime = openingTime
                numSeconds = diff_time
                break
              end
            end
            if cur_index == @@h.length - 1
              puts "Can't schedule."
              break
            end
          end
        end
      cur_index = cur_index + 1 if flag == 0
    end
    end
  end
end


#Object creation and method calls
obj = BusinessHours.new("9:00 AM", "5:00 PM" , "2016-05-11")
obj.update(:wed, "10:00 AM", "4:00 PM")
obj.update("2016-05-11", "10:00 AM", "5:00 PM")
obj.closed("2016-05-13")
obj.closed("sat")

BusinessHours.new("9:00 AM", "05:00 PM", "2016-05-12")
BusinessHours.new("9:00 AM", "10:00 AM", "2016-05-15")
BusinessHours.new("9:00 AM", "10:00 AM", "2016-05-16")


obj.calculate_deadline(2 * 60 * 60, "2016-05-12 4:30 PM")