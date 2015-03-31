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
	public class BasePanel : Gtk.Window
	{
		private enum Struts
		{
			LEFT, RIGHT, TOP, BOTTOM, LEFT_START, LEFT_END, RIGHT_START,
			RIGHT_END, TOP_START, TOP_END, BOTTOM_START, BOTTOM_END, N_VALUES
		}
		
		public Wnck.Screen wnck_screen;

		//Shadows and spacing
		public int shadow_size = 4;
		public int side_margin = 16;
		public int vertical_margin = 4;
		public int content_spacing = 32;
		
		//Opacities
		public bool _maximised_mode = false;
		public double normal_opacity = 0.0;
		public double maximised_opacity = 1.0;
		public double* target_opacity; //Pointer to a target
		public double current_opacity = 0.2;
		
		//The animation speed
		public double animation_speed = 0.15;
		
		//Called every time the panel ticks
		public signal void onTickSignal();
		
		//The panel colour
		public Gdk.RGBA panel_tint;
		
		//The position & size
		private int x;
		private int y;
		private int width;
		public int height = 34;
		private double offset; //Used for hiding
		
		//The panel tick
		public int64 tick = 0;
		
		//The panel's child
		public Gtk.Box contents;
		
		//Some types
		public string STYLE_PANEL = "panel";
		public string STYLE_SHADOW = "panel-shadow";
		public string STYLE_APP_BUTTON = "panel-app-button";
		public string STYLE_COMPOSITED_INDICATOR = "composited-indicator";
		
		public BasePanel()
		{
			this.decorated = false;
			this.resizable = false;
			this.skip_taskbar_hint = true;
			this.skip_pager_hint = true;
			this.app_paintable = true;
			this.set_keep_below(true);
			
			//Set the opacity & panel tint to default
			this.target_opacity = &this.normal_opacity;
			this.panel_tint = {0.1, 0.1, 0.1, 1.0};
			
			//Set up Wnck as needed
			Wnck.set_client_type(Wnck.ClientType.PAGER);
			wnck_screen = Wnck.Screen.get_default();
			
			//Define the style class based on the fact that this is a panel
			var style_context = this.get_style_context ();
			style_context.add_class(this.STYLE_PANEL);
			style_context.add_class(Gtk.STYLE_CLASS_MENUBAR);
		
			//RGBA and dock hinting
			this.set_visual(this.get_screen().get_rgba_visual());
			this.set_type_hint(Gdk.WindowTypeHint.DOCK);
			
			//Make sure it responds to screen / monitor updates
			this.screen.size_changed.connect(this.doResize);
			this.screen.monitors_changed.connect(this.doResize);
			
			//The container box used to store stuff
			this.contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, this.content_spacing);
			this.contents.set_margin_start(this.side_margin);
			this.contents.set_margin_end(this.side_margin);
			this.contents.set_margin_top(this.vertical_margin);
			this.contents.set_margin_bottom(this.shadow_size + this.vertical_margin);
			this.contents.set_hexpand(true);
			this.add(this.contents);
			
			//Make it slide in
			this.offset = -(double)(this.height + this.shadow_size);
			
			//Start the panel timer going
			Timeout.add(10, this.onTick);
			
			//Initialise everything with a resize and a checking of window viewports
			this.onViewportsChanged();
			this.doResize();
		}
		
		public bool maximised_mode
		{
			get {return this._maximised_mode;}
			set
			{
				this._maximised_mode = value;
				this.queue_draw();
				
				//We're maximised, so change the opacity
				if (this._maximised_mode)
					this.target_opacity = &this.maximised_opacity;
				else
					this.target_opacity = &this.normal_opacity;
			}
		}
	
		public override bool draw(Cairo.Context context)
		{
			Gtk.Allocation alloc;
			this.get_allocation (out alloc);

			//It's important to use window_context to avoid weird transparency issues!
			var window_context = Gdk.cairo_create(this.get_window());
			window_context.set_operator(Cairo.Operator.SOURCE);
			
			//Grab a headerbar's colour to use
			Gtk.HeaderBar header = new Gtk.HeaderBar();
			Gdk.RGBA col = header.get_style_context().get_background_color(Gtk.StateFlags.ACTIVE);
			this.panel_tint = {col.red, col.green, col.blue};
		
			//The gradient panel background
			Cairo.Pattern pat = new Cairo.Pattern.linear (0, 0, 0, alloc.height);
			pat.add_color_stop_rgba (0.0, this.panel_tint.red, this.panel_tint.green, this.panel_tint.blue, this.current_opacity);
			pat.add_color_stop_rgba (1.0 - ((double)this.shadow_size / alloc.height), this.panel_tint.red, this.panel_tint.green, this.panel_tint.blue, this.current_opacity);
			pat.add_color_stop_rgba (1.0, 0.0, 0.0, 0.0, 0.0);
			window_context.set_source(pat);
			window_context.fill();
			window_context.paint();
			
			//Redraw the child
			weak Gtk.Widget child = this.get_child();
			if (child != null)
				this.propagate_draw(child, context);
		
			return false;
		}
		
		public void onViewportsChanged()
		{
			unowned List<Wnck.Window> windows = this.wnck_screen.get_windows();
			Wnck.Workspace? workspace = this.wnck_screen.get_active_workspace();
			
			//Check to see if any windows on this workspace are maximised
			bool maximised = false;
			foreach (Wnck.Window window in windows)
			{
				if (window.is_maximized_vertically() && window.is_visible_on_workspace(workspace))
				{
					maximised = true;
					break;
				}
			}
			this.maximised_mode = maximised;
			
			this.queue_draw();
		}
		
		public void doResize()
		{
			Gdk.Rectangle monitor_dimensions;
			this.screen.get_monitor_geometry(this.screen.get_primary_monitor(), out monitor_dimensions);
			
			this.x = monitor_dimensions.x;
			this.y = monitor_dimensions.y;
			this.width = monitor_dimensions.width;
			
			//Position it and resize it
			this.move(this.x, this.y + (int)this.offset);
			this.set_size_request(this.width, this.height + this.shadow_size);
			
			this.structs();
			
			this.queue_draw();
		}
		
		public bool onTick() //Called on timer
		{
			//TODO - Sorry. There's gotta be a less performance-intensive way than this...
			//Update regularly-ish
			if (this.tick % 15 == 0)
				this.onViewportsChanged();
			
			//Make it slide down from the top
			if (this.offset < 0.5)
			{
				this.doResize();
				this.offset /= 1.0 + this.animation_speed;
			}
			
			//If the current opacity needs adjusting towards the target opacity
			if (Math.fabs(this.current_opacity - *this.target_opacity) > 0.001)
			{
				this.current_opacity += Math.fmin(this.animation_speed / 5, Math.fmax(-this.animation_speed / 5, *this.target_opacity - this.current_opacity));
				this.queue_draw();
			}
			
			this.tick ++;
			
			this.onTickSignal();
			
			//Restart the timer
			return true;
		}
		
		private void structs()
		{
			if (!get_realized ())
				return;
			
			// Since uchar is 8 bits in vala but the struts are 32 bits
			// we have to allocate 4 times as much and do bit-masking
			var struts = new ulong[Struts.N_VALUES];
			
			struts[Struts.TOP] = (ulong)(this.height + this.y + this.offset);
			struts[Struts.TOP_START] = this.x;
			struts[Struts.TOP_END] = this.x + this.width;
			
			var first_struts = new ulong[Struts.BOTTOM + 1];
			
			for (var i = 0; i < first_struts.length; i++)
				first_struts[i] = struts[i];
				
			Gdk.Atom atom = Gdk.Atom.intern("_NET_WM_STRUT_PARTIAL", false);
			Gdk.property_change(this.get_window(), atom, Gdk.Atom.intern("CARDINAL", false), 32, Gdk.PropMode.REPLACE, (uint8[])struts, 12);
		}
	}
}
