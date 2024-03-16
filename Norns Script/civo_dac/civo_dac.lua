--
-- CIVO - MIDI TO CV DEVICE
-- by deeg
--

--[[


IDEEN

!! DOCABLE LIB


]]--

m = midi.connect(1)


include "civo_dac/lib/CV_out"
include "civo_dac/lib/CV_in"
include "civo_dac/lib/CV_gfx"
include "civo_dac/lib/CV_lfo"
include "civo_dac/lib/mini_font"
u = require('util')


mpos = 0
gpos = 1
bpos = 1
func_pos = 1

key_two = {"CV_AllZero","CV_Random","CV_Beat_Toggle","CV_BeatZwo_Toggle"}


 
function init()

  CV_gfx_params()
  CV_add_params()
  CV_lfo_params()
  my_clock = clock.run(sys_loop)

-- Beat preset

  for i = 1,6 do 
    params:set("beats_"..i, beats[i])
    params:set("beatsch_"..i, beats_pull[i])
  end

end


function sys_loop()
    while true do
    
      clock.sync(0.01)
      lfos()
      CV_Send_lfo()
      if beats_on then CV_Beat() end

      redraw()
  end
end




function enc(n,d)
  
  if n == 1 then
     
     gpos = util.clamp(gpos + d, 1, 3) 
     
 elseif n == 2 then
  
      if gpos == 3 then
        bpos = util.clamp(bpos + d, 1, 12)  
      else
        mpos = util.clamp(mpos + d, 0, 6)  
      end
      
     
 elseif n == 3 then
  
    if gpos == 1 then
      if mpos == 6 then CV_Change_All(d)
      else CV_Change(mpos,d) end
      
    else
      
      CV_Beat_Set(bpos, d)
      
    end
  
  end
  
   redraw()
   
end



function key(n,z)
  
  if n == 3 and z == 1 then
    
      _G[key_two[func_pos]]()    
      redraw()
      
      
  end
  
  if n == 2 and z == 1 then
  
      func_pos = func_pos + 1
      if func_pos > 4 then func_pos = 1 end
      redraw()
 
  end
end




function redraw()
  
  screen.clear()
  screen.aa(0)
  screen.font_face(1)
  screen.font_size(8)
  screen.level(12)
  
  if gpos == 1 then menu01() end
  if gpos == 2 then menu02() end
  if gpos == 3 then menu03() end
    

  screen.update()
  
  
end



