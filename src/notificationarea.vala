namespace Timber
{
	public class NotificationArea : Gtk.Box
	{
		public Gtk.Label empty_label;
		
		public NotificationArea()
		{
			this.set_orientation(Gtk.Orientation.VERTICAL);
			this.height_request = 32;
			this.set_margin_top(4);
			this.set_margin_bottom(4);
			this.set_margin_start(8);
			this.set_margin_end(8);
			
			this.show.connect(this.update);
			
			this.empty_label = new Gtk.Label("No notifications");
			this.empty_label.height_request = 32;
			//this.add(this.empty_label);
			
			for (int count = 0; count < 6; count ++)
				this.add(new NotificationBox(this, "Test Notification"));
			
			this.update();
		}
		
		public void update()
		{
			if (this.get_children().length() > 1)
				this.empty_label.set_visible(false);
			else
				this.empty_label.set_visible(true);
		}
	}
	
	public class NotificationBox : Gtk.Revealer
	{
		public weak NotificationArea mother;
		
		public NotificationCard bar_box;
		public Gtk.Box contents;
		
		public Gtk.Label label;
		public Gtk.Button close_button;
		
		public uint CLOSE_TIME = 350;
		
		public NotificationBox(NotificationArea mother, string text)
		{
			this.mother = mother;
			
			this.set_transition_duration(this.CLOSE_TIME);
			this.set_transition_type(Gtk.RevealerTransitionType.SLIDE_DOWN);
			
			this.bar_box = new NotificationCard();
			this.bar_box.set_margin_top(4);
			this.bar_box.set_margin_bottom(4);
			this.add(this.bar_box);
			
			this.contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			this.contents.set_margin_top(8);
			this.contents.set_margin_bottom(8);
			this.contents.set_margin_start(8);
			this.contents.set_margin_end(8);
			this.bar_box.add(this.contents);
			
			this.label = new Gtk.Label(text);
			this.contents.add(this.label);
			
			this.close_button = new Gtk.Button.from_icon_name("window-close-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			this.close_button.set_halign(Gtk.Align.END);
			this.close_button.set_relief(Gtk.ReliefStyle.NONE);
			this.close_button.clicked.connect(this.onCloseButtonClicked);
			this.contents.pack_end(this.close_button);
			
			//End
			this.set_reveal_child(true);
			this.mother.update();
		}
		
		public void onCloseButtonClicked()
		{
			this.set_reveal_child(false);
			Timeout.add(this.CLOSE_TIME, this.endAnimate);
		}
		
		public bool endAnimate()
		{
			this.destroy();
			this.mother.update();
			return false;
		}
	}
	
	public class NotificationCard : Gtk.Bin
	{
		public double[] TINT = {0.9, 0.9, 0.9};
		public double OPACITY = 1.0;
		
		public override bool draw(Cairo.Context context)
		{
			Gtk.Allocation size;
			this.get_allocation (out size);
			
			context.set_source_rgba (this.TINT[0], this.TINT[1], this.TINT[2], this.OPACITY);
			context.fill();
			
			context.set_source_rgba (1.0, 1.0, 1.0, 0.3);
			context.fill();
			
			context.paint();
			
			var children = this.get_children();
		
			foreach (Gtk.Widget child in children)
				this.propagate_draw(child, context);
			
			return false;
		}
	}
}
