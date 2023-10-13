fg="#F1F1F1"
bg="#030303"

group3fg = "#F1F1F1"
group3bg = "#030303"

group2fg = "#F1F1F1"
group2bg = "#004158"
group2HDD = dict(
    border_color=group2bg,
    fill_color=["#FF0000", "#AEFFCD", "#AEFFCD", "#AEFFCD"],
    graph_color=["#023F30"],
)

group1fg = "#F1F1F1"
atm = "#F1F1F1"
group1bg = "#005522"

# Tema por defecto
widget_defaults = dict(
    font="UbuntuMono Nerd Font Bold",
    foreground=fg,
    background=bg,
    fontsize=14,
    padding=3,
    fontshadow=None,
)

windowName = dict(
    font='UbuntuMono Nerd Font Bold',
    fontsize=18,
    empty_group_string='Arch Linux',
    padding=10,
)

groupBox = dict(
    foreground=fg, 
    background=bg,
    active="#F1F1F1",
    inactive="#5C5C5C",
    rounded=False,
    highlight_method='block',
)

mainFocus="#22C0FF"
mainOff="#004158"
secondFocus="#00CF4F"
secondOff="#005522"

groupBoxMain = dict(
    this_current_screen_border=mainFocus,
    this_screen_border=mainOff,
    other_current_screen_border=secondFocus,
    other_screen_border=secondOff,
)

groupBoxSecondary = dict(
    this_current_screen_border=secondFocus,
    this_screen_border=secondOff,
    other_current_screen_border=mainFocus,
    other_screen_border=mainOff,
)

