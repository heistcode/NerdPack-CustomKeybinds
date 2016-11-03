# NerdPack-CustomKeybinds
Plugin for NerdPack

Create custom keybinds for use in NerdPack CRs.

Installing:
Add NerdPack-CustomKeybinds to the Dependencies for your CR or otherwise prepare for the eventuality of loading your CR without loading NerdPack-CustomKeybinds (using the API without NerdPack-CustomKeybinds loaded may throw errors).

To do this add this line to your .toc:
```
## Dependencies: NerdPack, NerdPack-CustomKeybinds
```

API for creating a keybind is the following:
```
NeP.CustomKeybind:Add("<group name>", "<key>", <callback>)
NeP.CustomKeybind:Remove("<group name>", "<key>")
NeP.CustomKeybind:RemoveAll("<group name>")
<group name> = string identifying a group of keybinds (e.g. your CR name or some other way you wish to group the keybinds)
<key> = string of a case insensitive but otherwise a valid keybind (e.g. "Q", "SHIFT-F1", "ALT-CTRL-SHIFT-`", "s" or "shift-home"). Keys are not verified so if the key is not valid it probably will fail silently. The modifier prefix order is "ALT-CTRL-SHIFT-".
<callback> = an optional function that will fire when the button is pressed or released passing key:upper() and a BOOLEAN of whether the button was pressed down or not (e.g. callback(key, down))
```

Combat Routine condition:
```
"customkeybind(<key>)"
<key> = case insensitive key. If the keybind hasn't been added or was removed the condition will simply not fire, there won't be an error
```

Example:
```
ExampleCallback = function(key, down) print(key .. " was ".. down and "pressed down" or "released") end
CR = {
  name = "Example CR",
  ic = {
    {"Ice Barrier", "customkeybind(q)"},
    {"Blink", "customkeybind(f1)"},
    },
  ooc = {
    {"Ice Barrier", "customkeybind(q)"},
    },
  load = function()
    NeP.CustomKeybind:Add("Example", "Q")
    NeP.CustomKeybind:Add("Example", "F1", ExampleCallback)
  end,
  unload = function()
    NeP.CustomKeybind:RemoveAll("Example")
  end,
  gui = {},
}

NeP.CR:Add(63, CR)
```
