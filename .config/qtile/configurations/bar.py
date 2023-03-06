from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy
from themes.theme import *

def separator(num):
    _fg="#FFFFFF"
    _bg="#000000"
    if (num==1):
        _fg=group1bg
        _bg=group2bg
    if (num==2):
        _fg=group2bg
        _bg=group3bg
    if (num==3):
        _fg=group3bg
        _bg=bg

    return widget.TextBox(
            foreground=_fg,
            background=_bg,
            text="",
            font='UbuntuMono Nerd Font',
            fontsize=44,
            padding=11,
            width=30,
        )
         

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    **groupBox,
                    **groupBoxMain,
                    font='UbuntuMono Nerd Font Mono',
                    fontsize=40,
                    margin_y=2,
                    margin_x=0,
                    padding_y=8,
                    padding_x=10,
                    borderwidth=1,
                    urgent_alert_method='none',
                    disable_drag=True,
                    toggle=False,
                ),


                widget.WindowName(
                    **windowName,
                ),

                #RIGHT SIDE
                separator(3),

                #GROUP 3 ---------------------------------------

                widget.Systray(                    
                    foreground=group3fg,
                    background=group3bg,
                ), 

                # https://docs.qtile.org/en/latest/manual/ref/widgets.html#pulsevolume
                widget.PulseVolume(
                    emoji=True,
                    foreground=group3fg,
                    background=group3bg,
                    update_interval=0.005,
                ),
                
                separator(2),
                
                #GROUP 2 ---------------------------------------
                widget.TextBox(" ", fontsize=0, padding=0, background=group2bg),
                # https://docs.qtile.org/en/latest/manual/ref/widgets.html#cpu
                widget.TextBox(
                    "󰍛",
                    padding=8, 
                    foreground="#4EAFFF", 
                    background=group2bg,
                    fontsize=22,
                ),
                widget.CPU(
                    format="{load_percent}%", 
                    foreground=group2fg,
                    background=group2bg,
                    padding=0,
                    width=35,
                ),
                widget.ThermalSensor(
                    format="{temp: .0f}º", 
                    padding=0,
                    foreground=group2fg,
                    background=group2bg,
                ),
                widget.TextBox(" ", background=group2bg),

                # https://docs.qtile.org/en/latest/manual/ref/widgets.html#cpu
                widget.TextBox(
                    "",
                    padding=6,
                    foreground="#FFF23D",
                    background=group2bg,
                    fontsize=16,
                ),
                widget.Memory(
                    format="{MemUsed: .0f}{mm}",
                    foreground=group2fg,
                    background=group2bg,
                    padding=0,
                    width=43,
                ),
                widget.TextBox(" ", background=group2bg),

                # https://docs.qtile.org/en/latest/manual/ref/widgets.html#hddbusygraph
                widget.TextBox(
                    "󰋊",
                    padding=7,
                    foreground="#51EB4C",
                    background=group2bg,
                    fontsize=22,
                ),
                widget.HDDBusyGraph(
                    **group2HDD,
                    background=group2bg,
                    line_width=1,
                    padding=0,
                    margin=0,
                    samples=30,
                    width=50,
                ),
                widget.TextBox("", background=group2bg,),
                
                separator(1),
                
                #GROUP 1 ---------------------------------------
                widget.TextBox("", background=group1bg,),

                widget.TextBox(
                    "󱑌 ", 
                    foreground=group1fg,
                    background=group1bg,
                ),
                widget.Clock(
                    format='%d/%m %H:%M',
                    width=90,
                    foreground=group1fg,
                    background=group1bg,
                ),

                widget.CurrentLayoutIcon(
                    scale=0.65, 
                    foreground=group1fg,
                    background=group1bg,
                ),
                widget.TextBox(
                    " ATM", 
                    foreground=atm,
                    background=group1bg,
                ),
                widget.Sep(
                    linewidth=0, 
                    padding=7,
                    background=group1bg,
                ),
            ],
            28,
            opacity=0.85,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    **groupBox,
                    **groupBoxSecondary,
                    font='UbuntuMono Nerd Font Mono',
                    fontsize=40,
                    margin_y=2,
                    margin_x=0,
                    padding_y=8,
                    padding_x=10,
                    borderwidth=1,
                    urgent_alert_method='none',
                    disable_drag=True,
                    toggle=False,
                ),


                widget.WindowName(
                    **windowName,
                ),

            ],
            28,
            opacity=0.85,
        ),
    ),
]

extension_defaults = widget_defaults.copy()

