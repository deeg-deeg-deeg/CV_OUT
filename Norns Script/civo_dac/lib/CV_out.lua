
-- Call in init(): CV_Add_Params()
-- CV_Set(n,s): Change CV Output "n" by "s"
-- CV_Send(): send CV values


change_val = {0,0,0,0,0,0}
send_note = {0,0,0,0,0,0}
send_vel = {0,0,0,0,0,0}

beats_on = false
beats2_on = false
beats = {23,12,20,7,10,9}
beats_pull = {125,10,100,200,3,40}
beats_rnd = {39,10,100,200,40,150}



function CV_add_params()
  
  for i = 0,5 do params:add_control("CV_Control_"..i, "CV_Control_0"..i+1, controlspec.new(0, 4095, "lin", 1, 0, "")) end
  for i = 1,6 do params:add_control("beats_"..i, "On Beat_0"..i+1, controlspec.new(1, 255, "lin", 1, 0, "")) end
  for i = 1,6 do params:add_control("beatsch_"..i, "Change"..i+1, controlspec.new(0, 4095, "lin", 1, 0, "")) end
  params:bang()

end



function CV_Con()
  
  for channel = 1,6 do
    
    local temp = channel-1
    local set_val = math.floor(params:get("CV_Control_"..temp))

--------------------------------
-- HIER MIN/MAX SCALING EINFÜGEN
--------------------------------
    
    set_val = set_val/128
    local setint = math.floor(set_val)

      
    send_note[channel] = setint
    send_vel[channel] = math.floor((set_val - setint) * 128)
  
  end
  
end



function CV_Send()
  
  
  CV_Con()

  for i = 1,6 do

    m:note_on(send_note[i],send_vel[i],i)
    
  end
    
end





function CV_Change(n,c_delta)
  
    if beats_on then
      change_val[n+1] = change_val[n+1] + c_delta
    else
      params:set("CV_Control_"..n, params:get("CV_Control_"..n) + c_delta )     
      CV_Send()
    end

      
end


function CV_Change_All(c_delta)

      if beats_on then
        for n = 0, 5 do
          change_val[n+1] = change_val[n+1] + c_delta
        end
      else
        for n = 0, 5 do
          params:set("CV_Control_"..n, params:get("CV_Control_"..n) + c_delta )     
          CV_Send()
        end
      end
      
end


function CV_Set(n,s)
  
      params:set("CV_Control_"..n, s )     
      CV_Send()
      
end






function CV_AllZero()
    
      if beats_on then
        for n = 1, 6 do
          change_val[n] = 0
        end
      else
        for n = 0, 5 do
          params:set("CV_Control_"..n, 0 )     
          CV_Send()
        end
      end

    
    CV_Send()  
  
end


function CV_Random()

      if beats_on then
        for n = 1, 6 do
          change_val[n] = math.random(0,100)
        end
      else
        for n = 0, 5 do
          params:set("CV_Control_"..n, math.random(0,4095) )     
          CV_Send()
        end
      end
     
    CV_Send()  
  
end


function CV_Inc()

     for i = 0, 5 do
      params:set("CV_Control_"..i, params:get("CV_Control_"..i) + 1) 
     end
    CV_Send()  
  
end

function CV_Dec()

     for i = 0, 5 do
      params:set("CV_Control_"..i, params:get("CV_Control_"..i) - 1) 
     end
    CV_Send()  
  
end



function CV_Beat_Set(n,d)
  
  if n <= 6 then
    
      params:set("beats_"..n, params:get("beats_"..n) + d)
    
    else
      local j = n-6
      params:set("beatsch_"..j, params:get("beatsch_"..j) + d)  
      
  end
    
  
  
  
end

function CV_Beat()

      
      for i = 1, 6 do
        
        beats[i] = params:get("beats_"..i)
        beats_pull[i] = params:get("beatsch_"..i)

        if  math.floor(clock.get_beats()) % beats[i] == 0 then 
         --if math.random(0,beats_rnd[i]*10) == 1 then beats[i] = beats[i] + math.random(-10,10) end
         --if beats[i] <= 0 then beats[i] = 1 end          
         -- params:set("CV_Control_"..i-1, math.random(0,255)) 
          params:set("CV_Control_"..i-1, beats_pull[i] + math.random(-5,40) + change_val[i])
        else
          params:set("CV_Control_"..i-1, change_val[i])
        end
  
      end
  
end

function CV_Beat_Toggle()
  beats_on = not beats_on
end

function CV_BeatZwo_Toggle()
  beats2_on = not beats2_on
end

  
