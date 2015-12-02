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
dependency('gtk+-3.0')
]

#Add subdirectories
subdir('src')

#Create the executable
executable(
exec_name,
sources : srcs,
dependencies : deps
)
