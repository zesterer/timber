namespace Timber
{
	public class PanelButton : Gtk.EventBox
	{
		public Gtk.Box contents;
		public Gtk.Image image;
		public Gtk.Label label;
		
		//A fake click event
		public signal void clicked();
		
		public PanelButton(string? label_text = null, string? icon_name = null)
		{
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
