namespace Timber
{
	public class Panel : BasePanel
	{
		public PanelButton menu_button;
		public PanelButton clock;
		
		public Gtk.Box status_box;
		public PanelButton brightness_button;
		public PanelButton sound_button;
		
		public Panel()
		{	
			//TODO - replace this with a proper plugin
			this.clock = new PanelButton(this, "Clock", null);
			this.contents.set_center_widget(this.clock);
			//Reset the time frequently
			this.onTickSignal.connect(this.setTime);
			
			//The menu button on the very left
			this.menu_button = new PanelButton(this, "Menu", "open-menu-symbolic");
			this.contents.add(this.menu_button);
			
			//Create a box to hold widgets on the right
			this.status_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 24);
			this.status_box.set_halign(Gtk.Align.END);
			this.contents.pack_end(this.status_box);
			
			this.brightness_button = new PanelButton(this, null, "display-brightness-symbolic");
			this.status_box.add(this.brightness_button);
			
			this.sound_button = new PanelButton(this, null, "audio-volume-medium-symbolic");
			this.status_box.add(this.sound_button);
		}
		
		public void setTime() //TODO - replace all of this with a plugin system
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
			
			this.clock.label.set_text(hour + ":" + minute + ":" + second);
		}
	}
}
