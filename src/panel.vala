/* Copyright (C) 2015 Barry Smith <barry.of.smith@gmail.com>
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
	public class Panel : BasePanel
	{
		public PanelButton menu_button;
		public PanelButton clock;
		
		public Gtk.Box status_box;
		public PanelButton brightness_button;
		public PanelButton sound_button;
		
		public TestPopover test;
		
		public string[] current_time;
		
		public Panel()
		{	
			//TODO - replace this with a proper plugin
			this.clock = new PanelButton(this, "Clock", null);
			this.contents.set_center_widget(this.clock);
			//Reset the time frequently
			this.onTickSignal.connect(this.setTime);
			
			//The current clock time
			this.current_time = {"0", "0", "0"};
			//And do it now
			this.setTime();
			
			//The menu button on the very left
			this.menu_button = new PanelButton(this, "Applications", "open-menu-symbolic");
			this.contents.add(this.menu_button);
			
			//Create a box to hold widgets on the right
			this.status_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 24);
			this.status_box.set_halign(Gtk.Align.END);
			this.contents.pack_end(this.status_box);
			
			this.brightness_button = new PanelButton(this, null, "display-brightness-symbolic");
			this.status_box.add(this.brightness_button);
			
			this.sound_button = new PanelButton(this, null, "audio-volume-medium-symbolic");
			this.sound_button.clicked.connect(() => {this.test.toggleReveal();});
			this.status_box.add(this.sound_button);
			
			this.test = new TestPopover(this.sound_button);
		}
		
		public void setTime() //TODO - replace all of this with a plugin system
		{
			if (this.tick % 25 == 0) //Every half-second - don't try to do it TOO often
			{
				string hour = new DateTime.now_local().get_hour().to_string();
				string minute = new DateTime.now_local().get_minute().to_string();
				string second = new DateTime.now_local().get_second().to_string();
			
				while (hour.length < 2)
					hour = "0" + hour;
				while (minute.length < 2)
					minute = "0" + minute;
				while (second.length < 2)
					second = "0" + second;
			
				if (!(this.current_time[0] == hour && this.current_time[1] == minute && this.current_time[2] == second))
				{
					this.current_time = {hour, minute, second};
					this.clock.label.set_text(hour + ":" + minute + ":" + second);
				}
			}
		}
	}
}
