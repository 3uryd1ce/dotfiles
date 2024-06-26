# Shell variables

color0='#174956'
color1='#fa5750'
color2='#75b938'
color3='#dbb32d'
color4='#4695f7'
color5='#f275be'
color6='#41c7b9'
color7='#72898f'
color8='#325b66'
color9='#ff665c'
color10='#84c747'
color11='#ebc13d'
color12='#58a3ff'
color13='#ff84cd'
color14='#53d6c7'
color15='#cad8d9'
background='#103c48'
foreground='#adbcbc'

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"

# Fix LS_COLORS being unreadable.
export LS_COLORS="${LS_COLORS}:su=30;41:ow=30;42:st=30;44:"
