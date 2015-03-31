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
	public class BasePopover : Gtk.Window
	{
		public double BORDER_RADIUS = 6;
		public double TAIL_HEIGHT = 8;
		public int SCREEN_EDGE = 8;
		public double border_size = 1;
		public double tail_position;
		public int click = 0; //The number of times clicked since last revealed (avoid insta-close)
		
		public Gtk.Box contents;
		
		public Gtk.Widget? target_widget = null;
		
		public BasePopover(Gtk.Widget? target_widget = null)
		{
			this.decorated = false;
			this.resizable = false;
			this.skip_taskbar_hint = true;
			this.skip_pager_hint = true;
			this.app_paintable = true;
			this.set_border_width(0);
			this.set_keep_above(true);
			this.set_modal(true);
			this.set_role("popover");
			
			//Set the target
			this.target_widget = target_widget;
			this.set_attached_to(this.target_widget.get_parent_window() as Gtk.Widget);
			
			//So that it's clickable
			this.set_events(Gdk.EventMask.BUTTON_PRESS_MASK);
			
			//Yes, we are a popup
			var style_context = this.get_style_context ();
			style_context.add_class(Gtk.STYLE_CLASS_POPUP);
			
			//Transparency
			this.set_visual(this.get_screen().get_rgba_visual());
			this.set_type_hint(Gdk.WindowTypeHint.MENU);
			
			//And the widgets that can go inside us
			this.contents = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			this.contents.set_hexpand(true);
			this.contents.set_vexpand(true);
			this.contents.set_margin_start((int)this.BORDER_RADIUS + (int)this.border_size);
			this.contents.set_margin_end((int)this.BORDER_RADIUS + (int)this.border_size);
			this.contents.set_margin_top((int)this.TAIL_HEIGHT + (int)this.BORDER_RADIUS + (int)this.border_size);
			this.contents.set_margin_bottom((int)this.BORDER_RADIUS + (int)this.border_size);
			this.add(this.contents);
			
			this.focus_out_event.connect(this.onFocusOut);
			this.grab_broken_event.connect(() => {this.hide; return false;});
			
			//Set the thing's position
			this.queue_resize_no_redraw();
			this.adjust();
		}
		
		public override bool map_event (Gdk.EventAny event)
		{
			var pointer = Gdk.Display.get_default().get_device_manager().get_client_pointer();
			pointer.grab(get_window(), Gdk.GrabOwnership.NONE, true, Gdk.EventMask.SMOOTH_SCROLL_MASK | 
				Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | 
				Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK | 
				Gdk.EventMask.POINTER_MOTION_MASK, null, Gdk.CURRENT_TIME);
			Gtk.device_grab_add(this, pointer, false);

			return false;
		}
		
		public override bool button_press_event(Gdk.EventButton event)
		{
			this.click ++;
			
			//make sure the click was inside this thing
			if (this.eventInWindow(event))
				return true;
			
			return base.button_press_event(event);
		}
		
		public override bool button_release_event (Gdk.EventButton event)
		{
			if (this.eventInWindow(event) || this.click < 1)
				return true;
		
			this.hide();
			return false;
		}
	
		public bool eventInWindow (Gdk.EventButton event)
		{
			int x, y, w, h;
			this.get_position(out x, out y);
			this.get_size(out w, out h);
			
			if (event.x_root >= x && event.x_root <= x + w && event.y_root >= y && event.y_root <= y + h)
				return true;
			
			return false;
		}
		
		public void ungrabAll()
		{
			var manager = this.get_screen().get_display().get_device_manager();
			Gtk.device_grab_remove(this, manager.get_client_pointer());
			manager.get_client_pointer().ungrab(Gdk.CURRENT_TIME);
		}
		
		public override void hide()
		{
			base.hide();
			this.ungrabAll();
		}
		
		public bool onFocusOut(Gdk.EventFocus event)
		{
			this.hide();
			return false;
		}
		
		public override bool draw(Cairo.Context context)
		{
			Gtk.Allocation size;
			this.get_allocation (out size);

			var window_context = Gdk.cairo_create(this.get_window());
		
			window_context.set_source_rgba (0.0, 0.0, 0.0, 0.0);
			window_context.set_operator(Cairo.Operator.SOURCE);
			window_context.paint();
			
			this.drawShape(window_context);
			window_context.clip();
			//Use a box to get the foreground colour
			Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			var background = box.get_style_context().get_color(Gtk.StateFlags.NORMAL);
			window_context.set_source_rgba(background.red - 0.03, background.green - 0.03, background.blue - 0.03, 1.0);
			window_context.paint();
			
			window_context.reset_clip();
			
			this.drawShape(window_context);
			
			window_context.set_line_width(0.5); //Forced. Probably should change this, but not now.
			var border = this.get_style_context().get_border_color(Gtk.StateFlags.ACTIVE);
			//Bias the colour a little closer to grey. May be a problem on some themes, but fixes many more so meh.
			window_context.set_source_rgba((border.red - 0.5) / 1.4 + 0.5, (border.green - 0.5) / 1.4 + 0.5, (border.blue - 0.5) / 1.4 + 0.5, 1.0);
			window_context.stroke ();
			
			window_context.fill();
		
			var child = this.get_child();
		
			if (child != null)
				this.propagate_draw(child, context);
			
			this.show_all();
		
			return false;
		}
		
		public void reveal()
		{
			this.click = 0;
			this.adjust();
			this.grab_focus();
			this.present();
		}
		
		public void toggleReveal()
		{
			if (this.visible)
				this.hide();
			else
				this.reveal();
		}
		
		public void adjust()
		{
			//What's the tail position?
			if (this.target_widget == null)
				this.tail_position = 64; //Some arbitrary number - in theory, this should never happen
			else
			{
				//Find our allocation
				Gtk.Allocation alloc;
				this.get_allocation(out alloc);
				
				//Find the relative window position of the target widget
				Gtk.Allocation target_alloc;
				this.target_widget.get_allocation(out target_alloc);
				
				//Find the absolute position of the targets window
				int target_root_y;
				int target_root_x = 0;
				if (target_widget.get_parent_window() != null)
					this.target_widget.get_parent_window().get_position(out target_root_x, out target_root_y);
				
				//From both of the above, now find the absolute screen position of the target
				double ideal_pos = target_root_x + target_alloc.x + target_alloc.width / 2;
				
				int pos_x; //The position we're about to move to
				//Adjust the position so that it's within the limits of the screen
				pos_x = (int)Math.fmin(this.get_screen().get_width() - alloc.width - this.SCREEN_EDGE, Math.fmax(this.SCREEN_EDGE, ideal_pos - alloc.width / 2.0));
				
				//Doesn't need explaining
				this.move(pos_x, 0);
				
				//Change the tail position according to the DIFFERENCE between the 'ideal' position and the position after limiting, then limit it within the popup
				this.tail_position = Math.fmin(alloc.width - this.TAIL_HEIGHT, Math.fmax(this.TAIL_HEIGHT, ideal_pos - pos_x));
			}
		}
		
		public void drawShape(Cairo.Context window_context)
		{
			Gtk.Allocation alloc;
			this.get_allocation(out alloc);
			
			this.adjust();
			
			//If the tail overlaps the arcs, they arcs should adjust to reflect this
			double border_radius_left = Math.fmin(this.BORDER_RADIUS, (this.tail_position - this.TAIL_HEIGHT) / 2.0);
			double border_radius_right = Math.fmin(this.BORDER_RADIUS, (alloc.width - this.tail_position - this.TAIL_HEIGHT) / 2.0);
			
			//Top-left corner
			window_context.arc(border_radius_left + this.border_size, this.TAIL_HEIGHT + border_radius_left + this.border_size, border_radius_left, Math.PI, Math.PI * 1.5);
			
			//The tail
			window_context.line_to(this.tail_position - this.TAIL_HEIGHT, this.TAIL_HEIGHT + this.border_size);
			window_context.line_to(this.tail_position, 0.0);
			window_context.line_to(this.tail_position + this.TAIL_HEIGHT, this.TAIL_HEIGHT + this.border_size);
			
			//Top-right corner
			window_context.arc(alloc.width - border_radius_right - this.border_size, this.TAIL_HEIGHT + border_radius_right + this.border_size, border_radius_right, Math.PI * 1.5, Math.PI * 2.0);
			
			//Bottom-right corner
			window_context.arc(alloc.width - this.BORDER_RADIUS - this.border_size, alloc.height - this.BORDER_RADIUS - this.border_size, this.BORDER_RADIUS, Math.PI * 2.0, Math.PI * 2.5);
			
			//Bottom-left corner
			window_context.arc(this.BORDER_RADIUS + this.border_size, alloc.height - this.BORDER_RADIUS - this.border_size, this.BORDER_RADIUS, Math.PI * 2.5, Math.PI * 3.0);
			
			window_context.close_path();
		}
	}
}
