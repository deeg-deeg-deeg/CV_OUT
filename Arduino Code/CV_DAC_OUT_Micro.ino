	
	#include "MIDIUSB.h"
  #include "AH_MCP4922.h"

//define AnalogOutput (MOSI_pin, SCK_pin, CS_pin, DAC_x, GAIN) 
AH_MCP4922 AnalogOutput1(16,15,5,LOW,HIGH);    
AH_MCP4922 AnalogOutput2(16,15,5,HIGH,HIGH);  
AH_MCP4922 AnalogOutput3(16,15,3,LOW,HIGH);    
AH_MCP4922 AnalogOutput4(16,15,3,HIGH,HIGH); 
AH_MCP4922 AnalogOutput5(16,15,10,LOW,HIGH);    
AH_MCP4922 AnalogOutput6(16,15,10,HIGH,HIGH); 
	
  int CV_Out[] = {0, 0, 0, 0, 0, 0};
  int channel = 0; // channel 0 = channel 1 in MIDI

  int CV_In[] = {0, 0, 0, 0, 0, 0};
  int Pins_In[] = {"A0", "A1", "A2", "A3", "A4", "A5"};
  int Send_Val01[] = {0, 0, 0, 0, 0, 0};
  int Send_Val02[] = {0, 0, 0, 0, 0, 0};

  float temp = 0;


	void setup() {

  pinMode(10, OUTPUT);
  pinMode(3, OUTPUT); 
  pinMode(5, OUTPUT);  
  pinMode(16, OUTPUT);
  pinMode(15, OUTPUT);    

  digitalWrite(10,HIGH); 
  digitalWrite(5,HIGH);
  digitalWrite(3,HIGH);

  AnalogOutput1.setValue(0);
  AnalogOutput2.setValue(0);
  AnalogOutput3.setValue(0);
  AnalogOutput4.setValue(0);
  AnalogOutput5.setValue(0);
  AnalogOutput6.setValue(0);
  
  Serial.begin(9600);

  	for (int i = 0; i <= 5; i++) {
	      pinMode(Pins_In[i], INPUT_PULLUP);
	  }    

	}
	

	void loop() {

  midiEventPacket_t rx;
  do {
    rx = MidiUSB.read();
    if (rx.header != 0) {
     
     if (rx.header == 0x09) {

      channel = int(rx.byte1) - 144;
      //if (channel > 5) { channel = 5; } 
      CV_Out[channel] = 128 * int(rx.byte2) + int(rx.byte3); 
  
     }
      
    }
  } while (rx.header != 0);
  
  CV_Output();    
  CV_InRead(); 

	}


void CV_Output() {
	
  AnalogOutput1.setValue(CV_Out[0]);              
  AnalogOutput2.setValue(CV_Out[1]);                
  AnalogOutput3.setValue(CV_Out[2]);                 
  AnalogOutput4.setValue(CV_Out[3]); 
  AnalogOutput5.setValue(CV_Out[4]);                 
  AnalogOutput6.setValue(CV_Out[5]); 

}


void CV_InRead() {

    CV_In[0] = analogRead(A0);
    CV_In[1] = analogRead(A1);
    CV_In[2] = analogRead(A2);
    CV_In[3] = analogRead(A3);
    CV_In[4] = analogRead(A4);
    CV_In[5] = analogRead(A5);

  	for (int i = 0; i <= 5; i++) {
        temp = float(CV_In[i])/128;
        Send_Val01[i] = CV_In[i]/128;
        temp = (temp - Send_Val01[i]) * 128;
        Send_Val02[i] = temp;
        Send_Val01[i] = Send_Val01[i] + 1;

        noteOn(i, Send_Val01[i], Send_Val02[i]);
	  }

    MidiUSB.flush();


  
 

 
}


void noteOn(byte channel, byte pitch, byte velocity) {
	
	  midiEventPacket_t noteOn = {0x09, 0x90 | channel, pitch, velocity};
	  MidiUSB.sendMIDI(noteOn);

}