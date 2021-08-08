CFLAGS = -O3 -fPIC

LFLAGS =

SIMDIR = z80sim

OBJ =	checksort.o \
	$(SIMDIR)/sim1.o \
	$(SIMDIR)/sim1a.o \
	$(SIMDIR)/sim2.o \
	$(SIMDIR)/sim3.o \
	$(SIMDIR)/sim4.o \
	$(SIMDIR)/sim5.o \
	$(SIMDIR)/sim6.o \
	$(SIMDIR)/sim7.o \
	$(SIMDIR)/simctl.o \
	$(SIMDIR)/disas.o	\
	$(SIMDIR)/simint.o \
	$(SIMDIR)/iosim.o	\
	$(SIMDIR)/simfun.o \
	$(SIMDIR)/simglb.o

checksort : $(OBJ)
checksort.o : checksort.c $(SIMDIR)/sim.h $(SIMDIR)/simglb.h data.h
$(SIMDIR)/sim1.o : $(SIMDIR)/sim1.c $(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim1a.o : $(SIMDIR)/sim1a.c $(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim2.o : $(SIMDIR)/sim2.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim3.o : $(SIMDIR)/sim3.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim4.o : $(SIMDIR)/sim4.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim5.o : $(SIMDIR)/sim5.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim6.o : $(SIMDIR)/sim6.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/sim7.o : $(SIMDIR)/sim7.c	$(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/simctl.o : $(SIMDIR)/simctl.c $(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/disas.o	: $(SIMDIR)/disas.c
$(SIMDIR)/simint.o : $(SIMDIR)/simint.c $(SIMDIR)/sim.h $(SIMDIR)/simglb.h
$(SIMDIR)/iosim.o	: $(SIMDIR)/iosim.c $(SIMDIR)/sim.h	$(SIMDIR)/simglb.h
simfun.o : $(SIMDIR)/simfun.c $(SIMDIR)/sim.h
simglb.o : $(SIMDIR)/simglb.c $(SIMDIR)/sim.h
insertion selection shell radix8 quick:
	./compile check$@.asm
	make
	./checksort out.bin

clean:
	rm -f $(SIMDIR)/*.o *.o checksort data.h out.*

