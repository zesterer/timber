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
	public class TestPopover : BasePopover
	{
		public ExpanderBar user_expander_bar;
		public ExpanderBar notification_expander_bar;
		public ExpanderBar keyboard_expander_bar;
		public ExpanderBar volume_expander_bar;
		public ExpanderBar network_expander_bar;
		
		public NotificationArea notification_area;
		
		public TestPopover(Gtk.Widget? target = null)
		{
			base(target);
			
			this.user_expander_bar = new ExpanderBar("system-users-symbolic", "User Profile");
			this.contents.add(this.user_expander_bar);
			
			this.notification_expander_bar = new ExpanderBar("preferences-system-notifications-symbolic", "Notifications");
			this.contents.add(this.notification_expander_bar);
			
			this.keyboard_expander_bar = new ExpanderBar("input-keyboard-symbolic", "Keyboard Layout");
			this.contents.add(this.keyboard_expander_bar);
			
			this.volume_expander_bar = new ExpanderBar("audio-volume-medium-symbolic", "Volume");
			this.contents.add(this.volume_expander_bar);
			
			this.network_expander_bar = new ExpanderBar("network-wireless-signal-good-symbolic", "Network Connection");
			this.contents.add(this.network_expander_bar);
			
			this.notification_area = new NotificationArea();
			this.notification_expander_bar.revealer.add(this.notification_area);
			
			this.volume_expander_bar.revealer.add(new Gtk.Label("Volume controls\nwill go here\nbut they will\nbe quite compact."));
			
			this.width_request = 200;
		}
		
		public void setUser()
		{
			/*try
			{
				AccountsService proxy = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.Accounts", "/org/freedesktop/Accounts");
				var path = proxy.FindUserById(Posix.getuid());
				user = Bus.get_proxy_sync(BusType.SYSTEM, "org.freedesktop.Accounts", path);
			}
			catch (Error e)
			{
				message("AccountsService query failed: %s", e.message);
			}*/
		}
	}
	
	public class ExpanderBar : Gtk.Box
	{
		public BorderlessButton borderless_button;
		public Gtk.Button toggle_button;
		public Gtk.Revealer revealer;
		
		public ExpanderBar(string icon_name, string text)
		{
			this.set_margin_top(8);
			this.set_margin_bottom(8);
			this.set_orientation(Gtk.Orientation.VERTICAL);
			
			this.borderless_button = new BorderlessButton(text, icon_name);
			this.borderless_button.clicked.connect(this.onToggleButtonClicked);
			this.borderless_button.set_margin_start(8);
			this.borderless_button.set_margin_end(8);
			this.add(this.borderless_button);
			
			this.toggle_button = new Gtk.Button.from_icon_name("pan-down-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			this.toggle_button.set_halign(Gtk.Align.END);
			this.toggle_button.set_relief(Gtk.ReliefStyle.NONE);
			this.toggle_button.clicked.connect(this.onToggleButtonClicked);
			this.borderless_button.contents.pack_end(this.toggle_button);
			
			this.revealer = new Gtk.Revealer();
			this.revealer.set_reveal_child(false);
			this.add(this.revealer);
			
			//End
			this.resetToggleButton(true);
		}
		
		public void onToggleButtonClicked()
		{
			this.revealer.set_reveal_child(!this.revealer.get_child_revealed());
			this.resetToggleButton(this.revealer.get_child_revealed());
		}
		
		public void resetToggleButton(bool is_revealed)
		{
			if (is_revealed)
				((Gtk.Image)this.toggle_button.image).set_from_icon_name("pan-down-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			else
				((Gtk.Image)this.toggle_button.image).set_from_icon_name("pan-start-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		}
	}
}
