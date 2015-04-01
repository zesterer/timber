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
	public class PanelButton : BorderlessButton
	{
		weak BasePanel panel;
		
		public PanelButton(BasePanel panel, string? label_text = null, string? icon_name = null)
		{
			base(label_text, icon_name);
			
			this.panel = panel;
			this.panel.onTickSignal.connect(this.onTickSignal);
			
			this.update();
		}
		
		public void update()
		{
			bool dark;
			Gdk.RGBA colour = this.panel.panel_tint;
			Gdk.RGBA new_colour;
			
			//Some themes don't make this default, so let's force it.
			if (colour.red + colour.green + colour.blue > 1.5) //If the colour is closer to white...
			{
				dark = true;
				new_colour = {0.2, 0.2, 0.2, 1.0};
			}
			else //The colour is closer to black
			{
				dark = false;
				new_colour = {1.0, 1.0, 1.0, 1.0};
			}
			
			if (dark) //Dark
			{
				if (this.image != null)
					this.image.override_color(Gtk.StateFlags.NORMAL, new_colour);
				if (this.label != null)
					this.label.override_color(Gtk.StateFlags.NORMAL, new_colour);
			}
			else //Light
			{
				if (this.image != null)
					this.image.override_color(Gtk.StateFlags.NORMAL, new_colour);
				if (this.label != null)
					this.label.override_color(Gtk.StateFlags.NORMAL, new_colour);
			}
		}
		
		public void onTickSignal()
		{
			this.update();
		}
	}	
	
	public class BorderlessButton : Gtk.EventBox
	{
		public Gtk.Box contents;
		public Gtk.Image image;
		public Gtk.Label label;
		
		//A fake click event
		public signal void clicked();
		
		public BorderlessButton(string? label_text = null, string? icon_name = null)
		{	
			//Align everything neatly
			this.set_valign(Gtk.Align.CENTER);
			this.button_press_event.connect(this.onButtonPressEvent);
			
			//The container for widgets
			this.contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
			this.contents.set_halign(Gtk.Align.FILL);
			this.contents.set_hexpand(true);
			this.add(this.contents);
			
			//Create an icon image
			if (icon_name != null)
			{
				this.image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.SMALL_TOOLBAR);
				this.image.set_valign(Gtk.Align.CENTER);
				this.contents.add(this.image);
			}
			
			//Create a label
			if (label_text != null)
			{
				this.label = new Gtk.Label(label_text);
				this.label.set_valign(Gtk.Align.CENTER);
				this.contents.add(this.label);
			}
		}
		
		public bool onButtonPressEvent(Gdk.EventButton event)
		{
			Gtk.Allocation alloc;
			this.get_allocation(out alloc);
			
			this.clicked();
			
			return false;
		}
	}
}
