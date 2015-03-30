namespace Timber
{
	public class PanelButton : Gtk.EventBox
	{
		weak BasePanel panel;
		
		public Gtk.Box contents;
		public Gtk.Image image;
		public Gtk.Label label;
		
		//A fake click event
		public signal void clicked();
		
		public PanelButton(BasePanel panel, string? label_text = null, string? icon_name = null)
		{
			this.panel = panel;
			this.panel.onTickSignal.connect(this.onTickSignal);
			
			//Align everything neatly
			this.set_valign(Gtk.Align.CENTER);
			this.button_press_event.connect(this.onButtonPressEvent);
			
			//The container for widgets
			this.contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
			this.contents.set_halign(Gtk.Align.CENTER);
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
			
			this.update();
		}
		
		public bool onButtonPressEvent(Gdk.EventButton event)
		{
			Gtk.Allocation alloc;
			this.get_allocation(out alloc);
			
			this.clicked();
			
			return false;
		}
		
		public void update()
		{
			bool dark;
			weak Gdk.RGBA colour = this.panel.panel_tint;
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
				this.image.override_color(Gtk.StateFlags.NORMAL, new_colour);
				this.label.override_color(Gtk.StateFlags.NORMAL, new_colour);
			}
			else //Light
			{
				this.image.override_color(Gtk.StateFlags.NORMAL, new_colour);
				this.label.override_color(Gtk.StateFlags.NORMAL, new_colour);
			}
		}
		
		public void onTickSignal()
		{
			this.update();
		}
	}
}
