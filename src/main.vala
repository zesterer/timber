/* Copyright (C) 2015 Barry Smith <barry.of.smith@gmail.com>
*
* This file is part of Vulcan.
*
* Vulcan is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 2 of the
* License, or (at your option) any later version.
*
* Vulcan is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Vulcan. If not, see http://www.gnu.org/licenses/.
*/

namespace Timber
{
	int main(string[] args)
	{
		Gtk.init(ref args);
		
		Application application = new Application(args);
		application.start();
		
		return 0;
	}
}
