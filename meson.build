# Copyright (C) 2015 Joshua Barretto <joshua.s.barretto@gmail.com>
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
# with Timber. If not, see http://www.gnu.org/licenses/.

#Define the project features
project(
'timber',
['vala', 'c']
)

#Initiate variables
exec_name = 'timber'
srcs = []
deps = []

#Add dependencies
deps = [deps,
dependency('glib-2.0'),
dependency('gobject-2.0'),
dependency('gtk+-3.0'),
dependency('libwnck-3.0'),
dependency('x11')
]

#Add subdirectories
subdir('src')

#Create the executable
executable(
exec_name,
sources : srcs,
dependencies : deps,
c_args : ['-D WNCK_I_KNOW_THIS_IS_UNSTABLE']
)
