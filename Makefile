#
# Makefile for managing Ollama Docker Compose services.
# This Makefile includes targets for starting, stopping, logging, and cleaning up services.
#

#
# Makefile target names
#
ALL=all
DOWN=down
CLEAN=clean
BUILD_DEPENDS=build-depends
UP=up
LOGS=logs
OPEN=open
HELP=help
START=start
RUN=run

#
# Docker Compose options
#
COMPOSE_PROJECT_NAME ?= ollama
COMPOSE_DOWN_TIMEOUT ?= 30
COMPOSE_DOWN_OPTIONS ?= --timeout $(COMPOSE_DOWN_TIMEOUT) --volumes
COMPOSE_UP_OPTIONS   ?= --detach
COMPOSE_LOGS_OPTIONS ?= --follow

#
# Build dependencies
#
DEPENDENCIES=docker docker-compose

#
# Targets that are not files (i.e. never up-to-date); these will run every
# time the target is called or required.
#
.PHONY: $(ALL) $(DOWN) $(CLEAN) $(BUILD_DEPENDS) $(UP) $(LOGS) $(OPEN) $(HELP) $(START) $(RUN)

#
# $(ALL): Default makefile target. Starts the service stack.
#
$(ALL): $(UP)

#
# $(BUILD_DEPENDS): Ensure build dependencies are installed.
#
$(BUILD_DEPENDS):
	$(foreach exe,$(DEPENDENCIES),
			$(if $(shell which $(exe) 2> /dev/null),,$(error "No $(exe) in PATH")))

#
# $(DOWN): Stops containers and removes containers, networks, and volumes.
#
$(DOWN): $(BUILD_DEPENDS)
	@echo "\nStopping service $(COMPOSE_PROJECT_NAME)"
	docker-compose down $(COMPOSE_DOWN_OPTIONS)

#
# $(UP): Starts containers for Ollama services.
#
$(UP): $(BUILD_DEPENDS)
	@echo "\nStarting service $(COMPOSE_PROJECT_NAME)"
	docker-compose up $(COMPOSE_UP_OPTIONS)

#
# $(LOGS): View output from containers.
#
$(LOGS):
	@echo "\nGetting logs for service $(COMPOSE_PROJECT_NAME)"
	docker-compose logs $(COMPOSE_LOGS_OPTIONS)

#
# $(OPEN): Opens the Ollama WebUI in the default web browser.
#
$(OPEN):
	@echo "\nOpening $(COMPOSE_PROJECT_NAME) WebUI in default browser"
	open "http://localhost:`docker-compose port $(COMPOSE_PROJECT_NAME)-webui 8080 | cut -d: -f2`"

#
# $(HELP): Print help information.
#
$(HELP):
	@echo "Usage: make [TARGET]"
	@echo ""
	@echo "Targets:"
	@echo "  $(ALL)             - Starts the Ollama service stack."
	@echo "  $(BUILD_DEPENDS)   - Ensures build dependencies are installed."
	@echo "  $(DOWN)            - Stops and removes containers, networks, and volumes."
	@echo "  $(CLEAN)           - Alias for $(DOWN)."
	@echo "  $(UP)              - Starts containers for Ollama services."
	@echo "  $(START)           - Alias for $(UP)."
	@echo "  $(LOGS)            - Shows logs for the service."
	@echo "  $(OPEN)            - Opens the Ollama WebUI in the default web browser."
	@echo "  $(RUN)             - Alias for $(UP), $(OPEN), $(LOGS)."
	@echo "  $(HELP)            - Displays this help message."

#
# Alias for down
#
$(CLEAN): $(DOWN)

#
# Alias for up
#
$(START): $(UP)

#
# $(RUN): Alias for up, open, logs
#
$(RUN): $(UP)
	@$(MAKE) $(OPEN)
	@$(MAKE) $(LOGS)
