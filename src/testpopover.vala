namespace Timber
{
	public class TestPopover : BasePopover
	{
		public ExpanderBar notification_expander_bar;
		public ExpanderBar keyboard_expander_bar;
		public ExpanderBar volume_expander_bar;
		public ExpanderBar network_expander_bar;
		
		public NotificationArea notification_area;
		
		public TestPopover(Gtk.Widget? target = null)
		{
			base(target);
			
			this.notification_expander_bar = new ExpanderBar("preferences-system-notifications-symbolic", "Notifications");
			this.contents.add(this.notification_expander_bar);
			
			this.keyboard_expander_bar = new ExpanderBar("input-keyboard-symbolic", "Keyboard layout");
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
	}
	
	public class ExpanderBar : Gtk.Box
	{
		public Gtk.Image image;
		public Gtk.Label label;
		public Gtk.Box bar_box;
		public Gtk.Button toggle_button;
		public Gtk.Revealer revealer;
		
		public ExpanderBar(string icon_name, string text)
		{
			this.set_margin_top(8);
			this.set_margin_bottom(8);
			this.set_orientation(Gtk.Orientation.VERTICAL);
			
			this.bar_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			this.add(this.bar_box);
			
			this.image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.LARGE_TOOLBAR);
			this.image.set_margin_start(8);
			this.image.set_margin_end(16);
			this.bar_box.add(this.image);
			
			this.label = new Gtk.Label(text);
			this.label.set_halign(Gtk.Align.START);
			this.label.set_hexpand(true);
			this.bar_box.add(this.label);
			
			this.toggle_button = new Gtk.Button.from_icon_name("pan-down-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			this.toggle_button.set_margin_start(16);
			this.toggle_button.set_margin_end(8);
			this.toggle_button.set_halign(Gtk.Align.END);
			this.toggle_button.set_relief(Gtk.ReliefStyle.NONE);
			this.toggle_button.clicked.connect(this.onToggleButtonClicked);
			this.bar_box.pack_end(this.toggle_button);
			
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
