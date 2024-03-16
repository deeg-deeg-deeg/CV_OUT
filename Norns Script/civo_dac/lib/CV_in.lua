
get_note = {0,0,0,0,0,0}
get_vel = {0,0,0,0,0,0}
get_sum = {0,0,0,0,0,0}




m.event = function(data) 
 
  local mess = midi.to_msg(data)

  if mess.type == "note_on" then

    get_note[mess.ch] = mess.note - 1
    get_vel[mess.ch] = mess.vel
    get_sum[mess.ch] = get_note[mess.ch] * 128 + get_vel[mess.ch]
    
  end

end