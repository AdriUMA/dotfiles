fg="#F1F1F1"
bg="#030303"

group3fg = "#FDF2EA"
group3bg = "#0B7A23"

group2fg = "#FFEBED"
group2bg = "#0E5E61"
group2HDD = dict(
    border_color="#0E5E61",
    fill_color=["#FF0000", "#FF8080", "#95FFB8", "#AEFFCD"],
    graph_color=["#023F30"],
)

group1fg = "#E8FCFF"
atm = "#E8FCFF"
group1bg = "#07344E"

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
    font='Noto Sans Sundanese Syriac Bold',
    fontsize=14,
    empty_group_string='Arch Linux',
    padding=10
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

