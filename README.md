CodingKeys
==========

### What problem does it solve?

Nowadays, developers often work in several different development environments and text editors. 
For example, you may need Eclipse for regular Java development, Android Studio for Android development, 
Xcode for iOS development, Visual Studio for C#, Sublime Text for web development, etc.
Every tool, however, has different keyboard shortcuts. Since it is hard to remember all shortcuts, 
there's a constant loss of productivity when switching tools. If you don't want to edit all shortcut
sets in every tool, you can instead use CodingKeys as an "abstraction layer". 

CodingKeys lets you define global shortcuts, which are dynamically remapped to existing shortcuts of 
other applications. All mappings can be conveniently edited in a single configuration file. The config 
file also gives you a nice overview over all shortcuts and grows as you add new apps to your coding toolbox.

### How it works

CodingKeys dynamically registers keyboard shortcuts when one of the defined applications is activated 
(and unregisters the shortcuts when the application is deactivated). It then generates mapped keyboard 
events based on global shortcuts defined in a configuration file and sends those events to the active 
application. 

### Installation
tbd

### How to use it

CodingKeys runs in the StatusBar (small keyboard icon with a "C" symbol) and currently has four menu 
options: `Launch At Startup`, `Keyboard Mappings`, `Help` and `Quit`. All options except `Keyboard Mappings`
(see separate section) should be self-explanatory. 

### Editing Keyboard Mappings

Selecting `Keyboard Mappings` from the menu opens a configuration JSON file. Each mapping has the 
following fields: 

- command: The name of the command
- key: The global shortcut for the command
- mapping: Lists each application and the corresponding shortcut

#### Command
This name is just for your own information.

#### Key
The global shortcut, consisting of unicode symbols, separated by spaces. 
You can use symbols such as `⌃` (Control), `⌥` (Option), `⌘` (Command), `⇧` (Shift), `↑` (Arrow Up), 
`↓` (Arrow Down). The full list of available options is shown at the end of this file.

#### Mapping
The mapping part lists each application you want to support and the corresponding shortcuts. Use the name 
displayed in the title bar of the application. This name is used to find the active application and the 
mappings that must be applied.

#### Shortcut Sequences
You can map a shortcut to a sequence of multiple keys. For example, in Xcode there are no default shortcut
to duplicate a line. However, pressing a sequence of five different key combinations in succession 
achieves the same effect. Each part of a sequence must be separated by a `|` (pipe). The sequence for the 
duplicate line command in Xcode is: `⌃ A | ⇧ ↓ | ⌘ C | ⌘ V | ⌘ V`

When CodingKeys sees a pipe, it fires those key combinations one after the other.

#### Saving config changes
Whenever you save the file, the mappings are automatically reloaded and should immediately take effect.
**Important Note**: Please make sure to use correct JSON syntax. The app currently handles errors poorly, 
so chances are the app won't start or crash if there are errors in this file. If something goes wrong, 
make sure to copy your mappings and the re-install the app.

### Symbols

`↩` Return  
`⇥` Tab  
`⎵` Space  
`⌫` Delete  
`⎋` Escape  
`⌘` Command  
`⇧` Shift  
`⇪` CapsLock  
`⌥` Option  
`⌃` Control  
`⇧` RightShift  
`⌥` RightOption  
`⌃` RightControl  
`🔊` VolumeUp  
`🔈` VolumeDown  
`🔇` Mute  
`F1`  
`F2`  
`F3`  
`F4`  
`F5`  
`F6`  
`F7`  
`F8`  
`F9`  
`F10`  
`F11`  
`F12`  
`F13`  
`F14`  
`F15`  
`F16`  
`F17`  
`F18`  
`F19`  
`F20`  
`⌦` ForwardDelete  
`↖` Home  
`↘` End  
`⇞` PageUp  
`⇟` PageDown  
`←` LeftArrow  
`→` RightArrow  
`↓` DownArrow  
`↑` UpArrow  