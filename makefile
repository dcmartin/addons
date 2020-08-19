###
### TOP-LEVEL makefile
###

# hard code architecture for build environment
ARCH ?= $(if $(wildcard ARCH),$(shell cat ARCH),$(shell uname -m | sed -e 's/aarch64.*/arm64/' -e 's/x86_64.*/amd64/' -e 's/armv.*/arm/'))
NVIDIA_RUNTIME := $(shell docker info --format '{{ json . }}' | jq '.DefaultRuntime=="nvidia"')

##
## things to build
##

ALL = $(wildcard addon-*)

##
## targets
##

TARGETS = pull all tidy clean distclean build push publish verify build-service push-service start-service publish-service test-service verify-service clean-service service-build service-push service-publish service-verify service-test service-stop service-clean horizon

## actual

default: build

all: build push

## all

$(ALL):
	@echo "${MC}>>> MAKE --" $$(date +%T) "-- making $@""${NC}" &> /dev/stderr
	export TARGET=$@ && TARGET=$${TARGET#-*} && $(MAKE)  -C $@/$${TARGET} $@

$(TARGETS):
	@echo "${MC}>>> MAKE --" $$(date +%T) "-- making $@ in ${ALL}""${NC}" &> /dev/stderr
	@for dir in $(ALL); do \
	  t=$$(echo "$${dir}" | sed 's/addon-//') && $(MAKE) -C $${dir}/$${t} $@; \
	done

PHONY += ${ALL} default pull all build run check stop push publish verify clean start test sync

CLOC.md: .gitignore .
	@echo "${MC}>>> MAKE --" $$(date +%T) "-- counting source code""${NC}" &> /dev/stderr
	@cloc --md --exclude-list-file=.gitignore . > CLOC.md

.PHONY:	${BASES} ${SERVICES} ${PATTERNS} ${JETSONS} ${MISC} ${PHONY}

##
## COLORS
##
MC=${LIGHT_BLUE}
NC=${NO_COLOR}

NO_COLOR=\033[0m
BLACK=\033[0;30m
RED=\033[0;31m
GREEN=\033[0;32m
BROWN_ORANGE=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHT_GRAY=\033[0;37m

DARK_GRAY=\033[1;30m
LIGHT_RED=\033[1;31m
LIGHT_GREEN=\033[1;32m
YELLOW=\033[1;33m
LIGHT_BLUE=\033[1;34m
LIGHT_PURPLE=\033[1;35m
LIGHT_CYAN=\033[1;36m
WHITE=\034[1;37m
