require 'time'
require 'date'

DAYS = { "mon" => 0, "tue" => 1,
         "wed" => 2, "thu" => 3,
         "fri" => 4, "sat" => 5,
         "sun" => 6
       } 

class BusinessHours
            
  @@businessHash = Hash.new{|hsh, key| hsh[key] = []}
  
  def initialize(start_time, end_time, cur_date=Time.new.localtime.to_date)
    cur_date = cur_date.to_s

    #Check if given date exists in the past.
    #If its a valid date, add an entry if the date doesn't exist already.
    temp_date = Date.parse cur_date
    if temp_date < Time.new.localtime.to_date
      abort("The date is in past. Provide a valid entry.")
    else
      if @@businessHash.has_key? cur_date
        abort("Entry exists already. You can only update.")
      else
        @@businessHash[cur_date].push start_time
        @@businessHash[cur_date].push end_time
      end
    end
  end
  
  def update(day_or_date, new_start_time, new_end_time)
    day_or_date = day_or_date.to_s
    
    #Convert given day to date
    if DAYS.has_key? day_or_date
      day_id = DAYS[day_or_date]
      datey = Date.today
      conv_date = (datey - datey.wday + day_id + 1).strftime
    else
      conv_date = day_or_date
    end
    
    conv_date = conv_date.to_s
    
    #Update the entries, based on the converted date.
    if @@businessHash.length == 0
      abort("No entry exists. Please add an entry and update it.")
    else
      if @@businessHash.has_key? conv_date
        @@businessHash[conv_date][0] = new_start_time
        @@businessHash[conv_date][1] = new_end_time
      else
        abort("Illegal entry to update. Given date/day doesnt exists. Please add.")
      end
    end
  end
  
  def closed(day_or_date)
    day_or_date = day_or_date.to_s
    
    #Convert day to date.
    if DAYS.has_key? day_or_date
      day_id = DAYS[day_or_date]
      datey = Date.today
      conv_date = (datey - datey.wday + day_id + 1).strftime
    else
      conv_date = day_or_date
    end
    
    conv_date = conv_date.to_s

    #Add Opening time and closing time as 0:00 for a given closed date.
    if @@businessHash.has_key? conv_date
      @@businessHash[conv_date][0] = "0:00"
      @@businessHash[conv_date][1] = "0:00"
    else
      @@businessHash[conv_date].push "0:00"
      @@businessHash[conv_date].push "0:00"
    end
  end
  
  def calculate_deadline(time_interval, submit_req)
    num_seconds = time_interval
    submit_date = submit_req.split(' ')[0]
    submit_time = submit_req.split(' ')[1] + submit_req.split(' ')[2]
    
    #Sort the hash based on key
    @@businessHash = Hash[@@businessHash.sort_by{|k,v| k}] 
    
    total_length = @@businessHash.length      
    
    opening_time = ""
    closing_time = ""
    cur_index = 0
    
    #Get the opening and closing time for a given request.
    @@businessHash.each_with_index do |(key,value), index|
      if key == submit_date
        opening_time = value[0]
        closing_time = value[1]
        cur_index = index
      end
    end    
      
    while cur_index < total_length
      
      #Convert the string to time objects
      start_str = "#{submit_date} #{opening_time.split(" ")[0] + opening_time.split(" ")[1]}"  
      time_open = Time.parse(start_str)
      
      req_str = "#{submit_date} #{submit_time}"
      time_req = Time.parse(req_str)
      
      end_str = "#{submit_date} #{closing_time.split(" ")[0] + closing_time.split(" ")[1]}"  
      time_close = Time.parse(end_str)
      
      
      #Check if a request can be processed in the same day
      if time_open <= time_req
        delivery_time = time_req + num_seconds
        if  delivery_time <= time_close
          puts delivery_time.strftime("%a %b %d %H:%M:%S %Y")
          break
        else
          #Caculate remaining time
          diff_time = delivery_time - time_close
          opening_time = ""
          closing_time = ""
          flag = 0
          #Find the next working day
          @@businessHash.each_with_index do |(key, value), index|
            if index > cur_index
              opening_time = value[0]
              closing_time = value[1]
              if opening_time != "0:00" && closing_time != "0:00"
                #Update the date and working hours
                submit_date = key
                flag = 1
                cur_index = index
                submit_time = opening_time
                num_seconds = diff_time
                break
              end
            end
            if cur_index == @@businessHash.length - 1
              puts "Can't schedule."
              break
            end
          end
        end
      #Update the index to start for the next iteration,
      #if the request is not processed on the current day.
      cur_index = cur_index + 1 if flag == 0
    end
    end
  end
end

#Object creation and method calls
obj = BusinessHours.new("9:00 AM", "5:00 PM" , "2016-05-12")
obj.update(:thu, "10:00 AM", "4:00 PM")
obj.update("2016-05-12", "10:00 AM", "5:00 PM")
obj.closed("2016-05-14")
obj.closed("sun")

BusinessHours.new("9:00 AM", "05:00 PM", "2016-05-13")
BusinessHours.new("9:00 AM", "10:00 AM", "2016-05-16")
BusinessHours.new("9:00 AM", "10:00 AM", "2016-05-17")

obj.calculate_deadline(2 * 60 * 60, "2016-05-13 4:30 PM")