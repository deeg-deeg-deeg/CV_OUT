
gfxmode = {"gfx01", "gfx02", "gfx03", "gfx04", "gfx05"}


function CV_gfx_params()
    params:add_control("gfxmode", "GFX mode", controlspec.new(1, 4, "lin", 1, 1, ""))  
end
  
  
function gfx01()
  
  local a = (params:get("CV_Control_0") + params:get("CV_Control_2") + params:get("CV_Control_4") ) / 60 + 2 
  local b = (params:get("CV_Control_1") + params:get("CV_Control_3") + params:get("CV_Control_5") ) / 60 + 2 



  local res = 360

  screen.level(12)
  for i=1,res do
    local angle = u.degs_to_rads(i*(360/res))
    local dt = clock.get_beats()

    local x0 =(math.cos(angle*(a+(dt/20)) ) * math.cos(angle*(a+(dt/20))) ) * 40 
    local y0 = math.sin(angle*b ) * math.sin(angle*b) * 40 

    paint(x0+1,y0+18)
  end
  
end



function gfx02()
  
  local a = (params:get("CV_Control_0") + params:get("CV_Control_2") + params:get("CV_Control_4") ) / 60 + 2
  local b = (params:get("CV_Control_1") + params:get("CV_Control_3") + params:get("CV_Control_5") ) / 60 + 2
  local res = 360

  screen.level(12)
  for i=1,res do
    local angle = u.degs_to_rads(i*(360/res))
    local dt = clock.get_beats()
    
    local x0 = math.cos(angle+dt/4 ) * math.cos(a*angle ) * 20 
    local y0 = math.sin(angle) * math.sin(b*angle ) * 20 

    paint(x0+20,y0+38)
  end
  
end



function gfx03()
  
  local a = (params:get("CV_Control_0") + params:get("CV_Control_2") + params:get("CV_Control_4") ) / 60 + 2
  local b = (params:get("CV_Control_1") + params:get("CV_Control_3") + params:get("CV_Control_5") ) / 60 + 2
  local res = 360

  screen.level(12)
  for i=1,res do
    local angle = u.degs_to_rads(i*(360/res))
    local dt = clock.get_beats()
    
    local x0 = math.cos(angle* (a+(dt/1000) ) * math.sin(angle*(a+(dt/1000) ))) * 40/2
    local y0 = math.sin(angle*b ) * math.cos(angle*b ) * 40 
    
    paint(x0+21,y0+38)
  end
  
end


function gfx04()
  
  local a = (params:get("CV_Control_0") + params:get("CV_Control_2") + params:get("CV_Control_4") ) / 60 + 2 
  local b = (params:get("CV_Control_1") + params:get("CV_Control_3") + params:get("CV_Control_5") ) / 60 + 2
  local res = 360
  
  screen.level(12)
  for i=1,res do
    local angle = u.degs_to_rads(i*(360/res))
    local dt = clock.get_beats()

    local x0 = (math.cos(angle*(a+dt/10)) ) * 20
    local y0 = (math.sin(angle*(b+dt/10)) ) * 20
    
    paint(x0+21,y0+38)
  end
  
end

function gfx05()
  
  local a = (  get_sum[1] + get_sum[3] + get_sum[5] ) / 800 + 2
  local b = (  get_sum[2] + get_sum[4] + get_sum[6] ) / 800 + 2
  local res = 360

  screen.level(12)
  for i=1,res do
    local angle = u.degs_to_rads(i*(360/res))
    local dt = clock.get_beats()
    
    local x0 = math.cos(angle+dt/4 ) * math.cos(a*angle ) * 20 
    local y0 = math.sin(angle) * math.sin(b*angle ) * 20

    paint(x0+20,y0+38)
  end
  
end


function paint(a,b)

  screen.pixel(a,b)
  screen.fill()

end





function menu01()
  

  if mpos == 6 then
    
    for j=0,5 do
      screen.rect(49,17+j*8,2,2)
      screen.fill() 

    end
    
      
  else
      
    screen.move(47,20+mpos*8)
    screen.text("+")
  
  end
  
  for i=0,5 do
  
    
    local temp_val = set_val[i+1]
    
    
    local temp = u.linlin (0, 4095, 0, 50, temp_val)
    screen.rect(55,17+i*8,temp,2)
    screen.fill()  
    
    screen.rect(53,17+i*8,1,2)
    screen.fill()  
    
    screen.rect(106,17+i*8,1,2)
    screen.fill()  
    
    screen.move(112,20+i*8)
    screen.text(math.floor(set_val[i+1]))
    
  end
  
  title01()
  ftil()
  
  _G[gfxmode[1]]()
  
  
end







function menu02()
  

  
  for i=1,6 do

    local temp = u.linlin (0, 1023, 0, 50, get_sum[i])
    screen.rect(55,17+(i-1)*8,temp,2)
    screen.fill()  
    
    screen.rect(53,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.rect(106,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.move(112,20+(i-1)*8)
    screen.text(math.floor(get_sum[i]))
    
  end

  title02()
  _G[gfxmode[5]]()

  
end




function menu03()
  

  if bpos <= 6 then
    
    screen.move(-1,20+(bpos-1)*8)
    screen.text("+")
    
  else
    
    screen.move(63,20+(bpos-7)*8)
    screen.text("+")
  
  end


  
  for i=1,6 do

    local temp = u.linlin (0, 100, 0, 40, params:get("beats_"..i))
    screen.rect(5,17+(i-1)*8,temp,2)
    screen.fill()  
    
    screen.rect(3,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.rect(44,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.move(48,20+(i-1)*8)
    screen.text(math.floor(params:get("beats_"..i)))
    
  end
  
  for i=1,6 do

    local temp = u.linlin (0, 4095, 0, 40, params:get("beatsch_"..i))
    screen.rect(69,17+(i-1)*8,temp,2)
    screen.fill()  
    
    screen.rect(67,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.rect(110,17+(i-1)*8,1,2)
    screen.fill()  
    
    screen.move(114,20+(i-1)*8)
    screen.text(math.floor(params:get("beatsch_"..i)))
    
  end


  title03()
  title03_sub()


  
end




function title01()
 
  mini_C(1,3)
  mini_V(5,3)
  mini_O(10,3)
  mini_U(14,3)
  mini_T(18,3)

  screen.fill()
  
end

function title02()
  
  mini_C(1,3)
  mini_V(5,3)
  mini_I(10,3)
  mini_N(12,3)
 
  screen.fill()
  
end

function title03()
  
  mini_B(1,3)
  mini_E(5,3)
  mini_A(9,3)
  mini_T(13,3)
 
  screen.fill()
  
end

function ftil()
  
  for i=1,func_pos do
    mini_I(106+4*(i-1),3)
  end
  
end

function title03_sub()
  
  mini_O(48,3)
  mini_N(52,3)

  mini_V(115,3)
  mini_A(119,3)
  mini_L(123,3)
 
  screen.fill()
  
end
