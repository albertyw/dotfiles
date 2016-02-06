#!/bin/bash

# Video Encoding
cat INPUTDIR | mencoder -aid 128 -oac mp3lame -lameopts abr:br=160:vol=3 -ovc xvid -xvidencopts fixed_quant=2 -vf scale -zoom -o OUTPUTFILE -
mencoder -oac copy -ovc copy -idx -o output.avi video1.avi video2.avi video3.avi
mencoder INPUTFILE -of rawaudio -oac mp3lame -ovc copy -o OUTPUTFILE

last
chkrootkit