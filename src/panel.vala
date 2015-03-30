namespace Timber
{
	public class Panel : BasePanel
	{
		public Gtk.Label clock;
		
		public Panel()
		{	
			//TODO - replace this with a proper plugin
			this.clock = new Gtk.Label("Clock");
			this.contents.set_center_widget(this.clock);
			//Reset the time frequently
			this.onTickSignal.connect(this.setTime);
			
			this.contents.add(new Gtk.Image.from_icon_name("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
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
			
			this.clock.set_markup("<span font=\"10\" weight=\"bold\" foreground=\"white\">" + hour + ":" + minute + ":" + second + "</span>");
		}
	}
}
