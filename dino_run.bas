 rem Generated 12-Mar-22 17:57:42 by Visual bB Version 1.0.0.548
 rem **********************************
 rem *<dino_run.bas>                      *
 rem *<Dino run for Atari 2600>                   *
 rem *<Petar Krstevski>                        *
 rem *<krstevski1petar@gmail.com>                  *
 rem *<MIT License>                       *
 rem **********************************

 set kernel_options playercolors player1colors pfcolors
 set romsize 16kSC
__Reset
 dim _Bit1_Sound_On=k:_Bit1_Sound_On=0
 AUDV1=0
 goto __BG_Music_Setup_01
_SoundReturn
 _Bit1_Sound_On{1}=1
 score=0
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 pfcolors:
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
end

 COLUBK = $44
 playfield:
 ................................
 .....XX..XXX.X..X..XX......XX...
 .....X.X..X..XX.X.X..X....XX.XX.
 .....X.X..X..X.XX.X..X....XXXXX.
 .....XX..XXX.X..X..XX....XXXX...
 ........................XXXXXX..
 .....XX..X..X.X..X.X...XXXXX....
 .....X.X.X..X.XX.X.XXXXXXXX.....
 .....XX..X..X.X.XX..XXXXXX......
 .....X.X..XX..X..X.....XX.......
 ................................
end



 rem Loop the screen until the spacebar is pressed

title
 AUDV1=0
 COLUPF =$0E
 drawscreen
 if joy0fire || joy1fire then goto skiptitle
 goto title
skiptitle
 rem This function displays after the title is skipped



 playfield:
 ................................
 ...XXX..........................
 ..XXXXX...................XXX...
 .......................XXXXXXXX.
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 pfcolors:
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $1A
end




 rem variable initialization
 rem 26 general purpose variables in batari Basic, fixed as a-z. Although they are fixed, you can use the dim command to map an alias to any of these variables.
 player0x=20:player0y=80
 player1x=80:player1y=80
 dim jumpTimeout=a
 dim playfieldCtr=b
 dim went=c
 dim sprite=d
 dim _Bit1_FireB_Restrainer = y
 dim _Ch0_Sound = e
 dim _Ch0_Duration = f
 dim _C0 = g
 dim _V0 = h
 dim _F0 = i
 dim _Ch0_Counter =j
 dim _Ch1_Duration = t
 dim crouched=l
 dim birds=m
 birds=0
 crouched=0
 z=0
 sprite=1
 went=1
 jumpTimeout=0
 playfieldCtr=0

 rem sprites


 player0:
 %00110000
 %01110000
 %10111110
 %00011100
 %00001100
 %00000110
 %00000110
 %00001111
 %00000110
end
 player0color:
 $D4
 $D4
 $D4
 $D4
 $D4
 $D4
 $D4 
 $F8
 $F8
 $F8
end
 player1color:
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
end

 player1:
 %00011000
 %00011000
 %00011000
 %00011000
 %00011110
 %01111010
 %01011000
 %00011000
 %00011000
end

 rem main game code, game loop

 goto play1


main
 score=score+1
 if switchreset then goto __Reset
 if joy0down then crouched=1
 if !joy0down then crouched=0
 if playfieldCtr=50&&went then goto play1
 if playfieldCtr=100&&went then goto play2
 if playfieldCtr=150&&went then goto play3
 if playfieldCtr>150&&went then playfieldCtr=0:goto main
 if sprite<20&&!crouched then player0:
 %00110000
 %01110000
 %10111110
 %00011100
 %00001100
 %00000110
 %00000110
 %00001111
 %00000110
end
 if sprite>20&&!crouched then player0:
 %01010000
 %01111000
 %10111110
 %00011100
 %00001100
 %00000110
 %00000110
 %00001111
 %00000110
end
 if crouched then player0:
 %00110100
 %01111100
 %11111110
 %10000110
 %00001111
 %00000110
end
 if crouched then  player0color:
 $D4
 $D4
 $D4
 $D4
 $F8
 $F8
 $F8
 $F8
 $F8
 $F8
end
 if !crouched then   player0color:
 $D4
 $D4
 $D4
 $D4
 $D4
 $D4
 $D4 
 $F8
 $F8
 $F8
end
 if sprite>=40 then sprite=0
 if player0y<80&&jumpTimeout=0 then player0y=80
   if !joy0fire then _Bit1_FireB_Restrainer{1} = 0 : goto __Skip_Fire
    
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if button hasn't been released after
   ;  being pressed.
   ;
   if _Bit1_FireB_Restrainer{1} then goto __Skip_Fire
   if jumpTimeout<>0 then goto __Skip_Fire

   ;```````````````````````````````````````````````````````````````
   ;  Turns on restrainer bit for fire button and turns on
   ;  missile movement bit.
   ;
    _Bit1_FireB_Restrainer{1} = 1 : jumpTimeout=20


   ;***************************************************************
   ;
   ;  Fire button check.
   ;
   ;  Turns on channel 0 sound effect 1 if fire button is pressed.
    if w then goto __Skip_Ch0_Sound_001
    if !_Ch0_Sound then _Ch0_Sound = 1 : _Ch0_Duration = 5

   
__Skip_Fire

   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1
   ;  Turns off sound if channel 0 duration counter is zero.
   ;
   if !_Ch0_Duration then goto __Clear_Ch_0
   ;***************************************************************
   ;
   ;  Channel 0 sound effect 001.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> 1 then goto __Skip_Ch0_Sound_001
   ;```````````````````````````````````````````````````````````````
   ;  Sets the tone, volume and frequency.
   ;
   AUDC0 = 4 : AUDV0 = 5 : AUDF0 = 30
   ;  Jumps to end of channel 0 area.
   ;
   goto __Skip_Ch_0

__Skip_Ch0_Sound_001
   ;***************************************************************
   ;
   ;  Jumps to end of channel 0 area. (Catches any mistakes.)
   ;

 if !w then goto __Skip_Ch_0
__playJumpSound
      if !_Ch0_Sound then _Ch0_Sound = 2 : _Ch0_Duration = 2

	   temp4 = _SD_Score[_Ch0_Counter]

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __Clear_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 0 data.
   ;
   _Ch0_Counter = _Ch0_Counter + 1
   temp5 = _SD_Score[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1
   temp6 = _SD_Score[_Ch0_Counter] : _Ch0_Counter = _Ch0_Counter + 1

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 0.
   ;
   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if !_Ch0_Sound then goto __Skip_Ch_0

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.
   ;
   _Ch0_Duration = _Ch0_Duration - 1
   ;  Turns off sound if channel 0 duration counter is zero.
   ;
   if _Ch0_Duration=0 then goto __Clear_Ch_0
   ;***************************************************************
   ;
   ;  Channel 0 sound effect 001.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 001 isn't on.
   ;
   if _Ch0_Sound <> 2 then goto __Skip_Ch0_Sound_002
   ;```````````````````````````````````````````````````````````````
   ;  Sets the tone, volume and frequency.
   ;
   
   AUDV0 = 3
   AUDC0 = temp5
   AUDF0 = temp6
   ;  Jumps to end of channel 0 area.
   ;
   goto __jumpDown

__Skip_Ch0_Sound_002

   ;***************************************************************
   ;
   ;  Clears channel 0.
   ;
__Clear_Ch_0
   _Ch0_Sound = 0 : AUDV0 = 0:_Ch0_Counter =0
__Skip_Ch_0
 if _Ch0_Duration=0 then  w=0
;*********channel 1 music
 ;***************************************************************
   ;
   ;  Channel 1 background music check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips music if left difficulty switch is set to A.
   ;

   ;```````````````````````````````````````````````````````````````
   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 1 duration counter.
   ;
   _Ch1_Duration = _Ch1_Duration - 1

   ;```````````````````````````````````````````````````````````````
   ;  Skips channel 1 if duration counter is greater than zero.
   ;
   if _Ch1_Duration then goto __Skip_Ch_1



   ;***************************************************************
   ;
   ;  Channel 1 background music.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Retrieves first part of channel 1 data.
   ;
   temp4 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Checks for end of data.
   ;
   if temp4 = 255 then goto __BG_Music_Setup_01

   ;```````````````````````````````````````````````````````````````
   ;  Retrieves more channel 1 data.
   ;
   temp5 = sread(_SD_Music01)
   temp6 = sread(_SD_Music01)

   ;```````````````````````````````````````````````````````````````
   ;  Plays channel 1.
   ;
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6

   ;```````````````````````````````````````````````````````````````
   ;  Sets duration.
   ;
   _Ch1_Duration = sread(_SD_Music01)



   ;***************************************************************
   ;
   ;  End of channel 1 area.
   ;
__Skip_Ch_1


 rem if player holds down left direction, stay in place, if right, move right
 if joy0left&&!jumpTimeout then player0x=player0x+1
 if joy0right&&!jumpTimeout then player0x=player0x+2
 rem move up&right for first half of jumpTimeout, down&right for second half, simulate gravity
 if jumpTimeout>=9 then jumpTimeout=jumpTimeout-1:player0x=player0x+2:player0y=player0y-1
 if jumpTimeout<9&&jumpTimeout>0 then jumpTimeout=jumpTimeout-1:player0x=player0x+2:player0y=player0y+1
 rem move cactus towards player
 player1x=player1x-1
 rem generate random num (range 0-3 )
 x = (rand&3) 
 rem code to decide when to change cactus, and what cactus should be displayed 
 if player1x<=0 then player1x=150:z=1:birds=0
 if x=1&&z then z=0:birds=0:player1:
 %00011000
 %00011000
 %00011000
 %00011000
 %00011110
 %01111010
 %01011000
 %00011000
 %00011000
end
 if x=0&&z then z=0:birds=0:player1:
 %00111100
 %00111100
 %00111100
 %00111111
 %00111101
 %00111101
 %11111100
 %10111100
 %10111100
 %00111100
end
 if x=2&&z then z=0:birds=1
 playfieldCtr=playfieldCtr+1
 sprite=sprite+1
 rem flag to see if playfield has been updated accordingly
 went=1

 if collision(player0,player1) then _Ch0_Sound = 3 : AUDV0 = 0: _Ch0_Counter =0 : goto gameover
 rem if player has moved too far to right, slide him back
 if player0x>20 then player0x=player0x-1
 rem if player has jumped over cactus, increment his score, the closer he gets to the cactus the larger score he'll receive 
 rem because there will be more iterations of the game loop until the cactus leaves the screen
 if player0x=player1x||player0x>player1x then score=score+10:w=1:goto __playJumpSound
__jumpDown
 if sprite<20&&birds then player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000010
 %00000111
 %00100000
 %01110000
 %00000000
 %00000000
 %00001110
 %00000100
 %00000000
 %00100000
 %01110000
end
 if sprite>20&&birds then player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000111
 %00000010
 %01110000
 %00100000
 %00000000
 %00000100
 %00001110
 %00000000
 %01110000
 %00100000
end
 if birds then player1color:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
end
 if !birds then  player1color:
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
 $C0
end

 drawscreen

 goto main





 rem code for changing playfields


play1
 playfield:
 ................................
 ...XXX..........................
 ..XXXXX...................XXX...
 .......................XXXXXXXX.
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end


 went=0
 goto main

play2
 playfield:
 ................................
 ...............................X
 ............XXX...............XX
 .........XXXXXXXX...............
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 went=0
 goto main
play3
 playfield:
 ................................
 .......................XXXX.....
 ..XXX................XXXXXXXX...
 XXXXXXX.........................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end
 went=0
 goto main


 rem gameover screen
gameover

 AUDV1= 0 : _Ch0_Duration = 0
 rem gameover sound *******************************************************************


 
 score=0
 pfcolors:
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
end
 
 playfield:
 .....XX...XXX..XXXXXXX.XXXXX....
 ....X....X...X.X..X..X.X........
 ....X.XX.XXXXX.X..X..X.XXXXX....
 ....X..X.X...X.X..X..X.X........
 .....XX..X...X.X..X..X.XXXXX....
 ................................
 .....XXX...X.....X.XXXXX.XXX....
 ....X...X..X.....X.X.....X.X....
 ....X...X...X...X..XXXX..XX.....
 ....X...X....X.X...X.....X.X....
 .....XXX......X....XXXXX.X..X...
end
    _Ch0_Duration = 2

deadLoop
    if _Ch0_Sound<>3 then _Ch0_Sound = 3 
   ;***************************************************************
   ;
   ;  Channel 0 sound effect check.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips all channel 0 sounds if sounds are off.
   ;
   if _Ch0_Sound<>3 then goto __skipGameOverSnd

   ;```````````````````````````````````````````````````````````````
   ;  Decreases the channel 0 duration counter.

   _Ch0_Duration = _Ch0_Duration - 1

   ;  Turns off sound if channel 0 duration counter is zero.
   ;
   if !_Ch0_Duration then _Ch0_Sound = 0 : AUDV0 = 0:_Ch0_Counter =0:goto __skipGameOverSnd
   ;***************************************************************
   ;
   ;  Channel 0 sound effect 003.
   ;
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if sound 003 isn't on.
   ;
   if _Ch0_Sound <> 3 then goto __skipGameOverSnd
   ;```````````````````````````````````````````````````````````````
   ;  Sets the tone, volume and frequency.
   ;
   AUDC0 = 8 : AUDV0 = 1 : AUDF0 = 30
   ;

 rem //gameover sound ******************************************************************
__skipGameOverSnd


 if switchreset then goto __Reset
 drawscreen
    if !joy0fire then _Bit1_FireB_Restrainer{1} = 0     
   ;```````````````````````````````````````````````````````````````
   ;  Skips this section if button hasn't been released after
   ;  being pressed.
     if _Ch0_Duration<=0  then AUDV0=0:l
   ;
   if _Bit1_FireB_Restrainer{1} then goto deadLoop

   ;```````````````````````````````````````````````````````````````
   ;  Turns on restrainer bit for fire button and turns on
   ;  missile movement bit.
   ;
   _Bit1_FireB_Restrainer{1} = 1 : goto title

  goto deadLoop





__BG_Music_Setup_01
   sdata _SD_Music01 = u
   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,26
   11

   8,12,23
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,26
   8
   2,8,2
   1
   2,12,26
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,26
   8
   2,8,2
   1
   3,12,26
   8

   4,8,2
   1
   2,12,26
   8
   2,8,2
   1
   1,12,26
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   8,12,23
   8
   2,8,2
   1
   2,12,23
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,24
   8
   2,8,2
   1
   2,12,24
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   3,12,31
   8

   4,8,2
   1
   2,12,31
   8
   2,8,2
   1
   1,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,19
   8
   2,8,2
   1
   2,12,19
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   3,12,15
   8
   
   4,8,2
   1
   2,12,15
   8
   2,8,2
   1
   1,12,15
   8


   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8

   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8


   4,8,2
   1
   8,12,31
   8
   2,8,2
   1
   2,12,31
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,29
   8
   2,8,2
   1
   2,12,29
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   2,12,17
   8



   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,20
   8
   2,8,2
   1
   3,12,20
   8


   4,8,2
   1
   2,12,20
   8
   2,8,2
   1
   2,12,20
   8

   4,8,2
   1
   8,12,15
   8
   2,8,2
   1
   2,12,15
   8

   4,8,2
   1
   8,12,17
   8
   2,8,2
   1
   3,12,17
   8

   4,8,2
   1
   2,12,17
   8
   2,8,2
   1
   1,12,17
   8

   4,8,2
   1
   8,12,14
   8
   2,8,2
   1
   3,12,14
   8

   4,8,2
   1
   2,12,14
   8
   2,8,2
   1
   1,12,14
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8

   4,8,2
   1
   0,0,0
   8
   2,8,2
   1
   0,0,0
   8
   255
end

   _Ch1_Duration = 1
   if !_Bit1_Sound_On{1} then goto _SoundReturn
   goto __Skip_Ch_1


   data _SD_Score
  8,4,21
  0,0,0
  11
  8,4,21
  0,0,0
  11
  8,4,21
  0,0,0
  11
  8,4,13
  0,0,0
  11
  8,4,13
  0,0,0
  6

end















