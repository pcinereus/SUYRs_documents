# help:
# 	@echo "Usage: make -i SRC=<path/file> -> to make a specific file"
# 	@echo "       make -i                 -> to make all altered files"

.PHONY: ws pres tut docs

ws:
	@echo "Transfer to ws/Makefile"
	$(MAKE) -f ws/Makefile

pres:
	@echo "Transfer to pres/Makefile"
	$(MAKE) -f pres/Makefile

tut:
	@echo "Transfer to tut/Makefile"
	$(MAKE) -f tut/Makefile

docs:
	@echo "Transfer to pres/Makefile"
	$(MAKE) -f pres/Makefile

clean:
	rm -f *.log *.aux *.md *.out texput.log
