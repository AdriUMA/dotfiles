from libqtile.config import Match
from libqtile import layout

layouts = [
    layout.Columns(
        border_focus="#F07178",
        border_width=1,
        margin= 1,
    ),

    layout.MonadTall(
        border_focus="#F07178",
        border_width=1,
        margin= 1,
    ),

    layout.MonadWide(
        border_focus="#F07178",
        border_width=1,
        margin= 1,
    ),
    
    layout.Max(
        border_focus="#F07178",
        border_width=1,
        margin= 1,
    ),
    
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

follow_mouse_focus = False
bring_front_click = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True # If things like steam games want to auto-minimize themselves when losing focus, should we respect this or not?