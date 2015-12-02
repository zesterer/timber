/*
* Copyright (C) 2015 Joshua Barretto <joshua.s.barretto@gmail.com>
*
* This file is part of Timber.
*
* Timber is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 2 of the
* License, or (at your option) any later version.
*
* Timber is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Timber. If not, see http://www.gnu.org/licenses/.
*/

namespace Timber
{
	class Panel : Gtk.ApplicationWindow
	{
		private float target_opacity = 1.0f;
		private float opacity_rate = 0.1f;
		
		public Panel(Gtk.Application app, AppSettings app_settings)
		{
			this.set_application(app);
			
			this.initiate();
		}
		
		void initiate()
		{
			this.set_decorated(false);
			this.set_resizable(false);
			this.set_skip_taskbar_hint(true);
			this.set_app_paintable(true);
			this.set_keep_above(true);
			
			this.set_size_request(1024, 32);
			
			Timeout.add(20, this.tick);
		}
		
		public void set_active(bool active)
		{
			this.show_all();
		}
		
		public bool tick()
		{
			bool redraw = false;
			
			stdout.printf("Testing\n");
			
			if (redraw)
				this.queue_draw();
			
			return true;
		}
	}
}
