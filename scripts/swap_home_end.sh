
xmodmap -e "keycode 112 = Home"
xmodmap -e "keycode 110 = Prior"
xmodmap -e "keycode 115 = Next"
xmodmap -e "keycode 117 = End"
xmodmap -e "keycode 107 = Super_L" # Menu"

xmodmap -e "clear lock"
xmodmap -e "clear control"
xmodmap -e "keycode 66 = Control_L"
xmodmap -e "add control = Control_L Control_R"
