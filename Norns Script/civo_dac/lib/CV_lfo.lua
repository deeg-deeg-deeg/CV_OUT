-- LFO VARIABLES



whereamI2 = 1

lfotype = {1,1,1,1,1,1}
period ={0,0,0,0,0,0}
period_delta ={0,0,0,0,0,0}
amplitude = {0,0,0,0,0,0}
s_h_val = {0,0,0,0,0,0}

scr3_y = {15,49,49}
scr3_x = {25,25,93}
scr3_i = {"-", "-", "o"}

menu_a = {":", ".", ".:", ":", ".", ".:"}
menu_names = {"LABEL","LABEL","LABEL","LABEL","LABEL","LABEL","LABEL","LABEL"}
lfo_labels = {"SIN", "TRI", "SQR", "S&H","TAN"}
para_labels = {"lfot1", "peri1", "ampl1",
               "lfot2", "peri2", "ampl2",
               "lfot3", "peri3", "ampl3",
               "lfot4", "peri4", "ampl4",
               "lfot5", "peri5", "ampl5",
               "lfot6", "peri6", "ampl6"}
             
lfo_val = {0,0,0,0,0,0}

lfo_mode = {"lfo_sine", "lfo_tri", "lfo_square", "lfo_snh", "lfo_tan"}

para_deltas2 = {1,0.0001,1,1,0.0001,1}

lfo_target_list = {0,0,0,0,0,0}
lfo_amnt_list = {0,0,0,0,0,0}
set_val = {0,0,0,0,0,0}


y_arr = {}

for i=1, 127 do
      y_arr[i] = 0
end

y_arr2 = {}

for j=1, 127 do
      y_arr2[j] = 0
end

seq_array = {}

for j=1, 64 do
      seq_array[j] = 0
end

-- LFO VARIABLES END





-- LFO PARAMS
function CV_lfo_params()
  
  params:add_separator("LFO SECTION")

for j=1,6 do
  params:add_separator("LFO 0"..j)
  params:add_option("lfot"..j,"LFO 0"..j.. " Type",{"SIN", "TRI", "SQR", "S&H","TAN"},1)  
  params:add_control("peri"..j, "Period 0"..j, controlspec.new(1, 10000, "lin", 1, 10, "", 0.0001, false))  
  params:add_control("ampl"..j, "Amplitude 0"..j, controlspec.new(0, 4095, "lin", 0.1, 20, "", 0.001, false))  
end
  
  params:add_separator("LFO AMOUNT")
  
  for i = 0,5 do params:add_control("CV_lfo_amnt"..i, "CV_LFO_amount"..i+1, controlspec.new(0, 100, "lin", 0.1, 0, "", 0.001, false)) end

end

  
-- LFO PARAMS END







function lfos()

for k=1,6 do

    local pc = k + 2*(k-1)
    lfotype[k] = params:get(para_labels[pc])
    period_delta[k] = params:get(para_labels[pc+1])/100000
    amplitude[k] = params:get(para_labels[pc+2])
    
    period[k] = period[k]+period_delta[k]
    
    s_h_val[k] = util.clamp(1000 - math.floor(params:get(para_labels[pc+1])), 1, 1000);
    
    _G[lfo_mode[lfotype[k]]](period[k],amplitude[k],k)
    
        
end   
  
end



function lfo_sine(p,a,i)
   lfo_val[i] = math.sin(p)*a
end

function lfo_tri(p,a,i)
   lfo_val[i] = (math.acos(math.sin(p))-math.pi/2)*a
end

function lfo_square(p,a,i)
   lfo_val[i] = (math.sin(p) >= 0 and 1 or -1)*a
end

function lfo_snh(p,a,i)
  if math.random(0,s_h_val[i]) == 1 then
    lfo_val[i] = (math.random() * (math.random(0, 1) == 0 and 1 or -1))*a
  end
end

function lfo_tan(p,a,i)
  lfo_val[i] = 10*math.log(math.abs(math.tan(p)*a)) 
end





function CV_lfo_check()
  
    CV_Send_lfo()

end



function CV_Con_lfo()
  
  for channel = 1,6 do
       
    local temp = channel-1


      lfo_amnt_list[channel] = params:get("CV_lfo_amnt"..temp)    
      
      if beats_on then
        set_val[channel] = params:get("CV_Control_"..temp) + change_val[channel] + lfo_val[channel] * lfo_amnt_list[channel]/100
      else
        set_val[channel] = params:get("CV_Control_"..temp) + lfo_val[channel] * lfo_amnt_list[channel]/100
      end
      
      set_val[channel] = util.clamp(math.floor(set_val[channel]), 0 , 4095)

--------------------------------
-- HIER MIN/MAX SCALING EINFÜGEN
--------------------------------
    
    local set_val = math.floor(set_val[channel])/128
    local setint = math.floor(set_val)

      
    send_note[channel] = setint
    send_vel[channel] = math.floor((set_val - setint) * 128)
  
  end
  
       
end





function CV_Send_lfo()
  
  
  CV_Con_lfo()

  for i = 1,6 do

    m:note_on(send_note[i],send_vel[i],i)
    
  end
    -- test_val = send_note[1] + send_vel[1] 
end
