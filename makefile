# Copyright (C) 2015 Barry Smith <barry.of.smith@gmail.com>
#
# This file is part of Timber.
#
# Timber is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of the
# License, or (at your option) any later version.
#
# Timber is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Vulcan. If not, see http://www.gnu.org/licenses/.

#The name of the program
NAME=timber

VALAC=valac
VALA_SOURCES=\
src/main.vala \
src/application.vala \
src/basepanel.vala \
src/panel.vala \
src/panelbutton.vala \
src/basepopover.vala \
src/testpopover.vala \
src/notificationarea.vala \

VALA_FLAGS=-X -lm -X "-D WNCK_I_KNOW_THIS_IS_UNSTABLE"

VALA_PACKAGES=--pkg gtk+-3.0 --pkg x11 --pkg libwnck-3.0
#--pkg accountsservice

default: build

build: $(VALA_SOURCES)
	@echo "Building..."
	@$(VALAC) -o $(NAME) $(VALA_FLAGS) $(VALA_PACKAGES) $(VALA_SOURCES)
	@echo "Built."

install: $(NAME)
	@echo "Adding runnable flag to executable file..."
	@chmod +x $(NAME)
	@echo "Moving to installation directory..."
	@sudo cp $(NAME) /usr/bin/$(NAME)
	@echo "Moved."

run: $(NAME)
	@echo "Running..."
	@./$(NAME)

buildrun:
	@make build
	@make run

help:
	@echo "To compile, run 'make build'"
	@echo "To install, run 'sudo make install'"
