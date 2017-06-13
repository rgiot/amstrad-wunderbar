all: BUILD_DSK


DSK_FNAME=wunderbar.dsk
LOAD_ADDRESS=x1000
EXEC=WUNDER.BAR
#EXEC=WUNDER

vpath %.asm src/ generated/


include CPC.mk

entries.sym:test.sym
	cat $^ | grep "^start" > $@


generated/curve1.asm:
	#curves256.py '((66*sin(i)+68) + (14*sin(i*4)+14) +  (14*sin(i*2)+14))/2 ' > $@
	curves256.py '((46*sin(i)+46) +  (46*sin(i*2)+46))/2  ' > $@


generated/curve2.asm:
	#curves256.py '(50*cos(i)+50)' > $@
	curves256.py '((step+1)%2)*(48*cos(i)+48) + (step%2)*(48*sin(i*2)+48)' > $@

generated/curve3.asm:
	#curves256.py '(118 + 118*sin(i))/2 + (118 + 118*sin(3*i))/2' > $@
	#curves256.py '(150 + 150*sin(i))/2 + (118 + 118*cos(2*i))/4 +  (90 + 90*cos(3*i))/4  + (90 + 90*cos(5*i))/4 ' > $@
	curves256.py '(118 + 118*sin(i)) ' > $@


generated/crunched-curve1.asm: curve1.o
	python tools/crunch-curves.py $^ > $@
generated/crunched-curve2.asm: curve2.o
	python tools/crunch-curves.py $^ special > $@
generated/crunched-curve3.asm: curve3.o
	python tools/crunch-curves.py $^ > $@

test.o: generated/crunched-curve1.asm  $(wildcard src/*.asm)
bootstrap.o: test.exo entries.sym

$(EXEC): bootstrap.o 
	$(call SET_HEADER,$^,$@,$(AMSDOS_BINARY),$(LOAD_ADDRESS),$(LOAD_ADDRESS))
	echo $$(( 4*1024 - $$(ls -ali $@| cut -d' ' -f6))) bytes remaining

$(DSK_FNAME):
	$(call CREATE_DSK,$(DSK_FNAME))

BUILD_DSK: $(EXEC) $(DSK_FNAME)
	$(call PUT_FILE_INTO_DSK,$(DSK_FNAME), $(EXEC))


clean:
	-rm *.o
	-rm *.exo
	-rm *.NOHEADER
	-rm *.lst
	-rm BOOTSTRAP
	-rm generated/*

distclean: clean
	-rm $(DSK_FNAME)
	
launch: BUILD_DSK
	xdg-open $(DSK_FNAME)

release: wunderbar.dsk wunderbar.hfe ./data/Wunderbar.nfo 
	mkdir release
	cp ./data/Wunderbar.nfo release
	cp wunderbar.dsk release
	cp wunderbar.hfe release
	cd release && tar -cvzf ../wunderbar.tar.gz *
	rm -rf release


