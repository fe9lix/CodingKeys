CodingKeys
==========

![CodingKeys](https://github.com/fe9lix/CodingKeys/blob/gh-pages/images/codingkeys-statusbar.png?raw=true)

![CodingKeys](https://github.com/fe9lix/CodingKeys/blob/gh-pages/images/codingkeys-menu.png?raw=true)

### What problem does it solve?

Nowadays, developers often work in several different development environments and text editors. 
For example, you may need Eclipse for regular Java development, Android Studio for Android development, 
Xcode for iOS development, Visual Studio for C#, Sublime Text for web development, etc..
Every tool, however, has different keyboard shortcuts. Since it is hard to remember all shortcuts, 
there's a constant loss of productivity when switching tools. If you don't want to edit all shortcut
sets in every tool, you can instead use CodingKeys as an "abstraction layer". 

CodingKeys lets you define unified shortcuts, which are dynamically re-mapped to existing shortcuts of 
other applications when you switch tools. All mappings can be conveniently edited in a single configuration 
file. The config file also gives you a nice overview over all shortcuts and grows as you add new apps to 
your coding toolbox.

### How it works

CodingKeys dynamically registers keyboard shortcuts when one of the defined applications is activated 
(and unregisters the shortcuts when the application is deactivated). It then generates keyboard 
events based on the mappings defined in a configuration file and sends those events to the active 
application. 

### Installation
CodingKeys runs on OSX (tested on OSX 10.8). Download the [latest release](https://github.com/fe9lix/CodingKeys/releases/latest). 

Unzip the file and copy the .app file into your program folder. 
When you start the app, an icon should appear in the status bar.

**Important Note**: Please make a backup of your key file before you install an updated version.
(The mapping file is currently contained in the application package.)

### How to use it

CodingKeys runs in the status bar (small keyboard icon with a "C" symbol) and currently has four menu 
options: `Launch At Startup`, `Key Mappings`, `Help` and `Quit`. All options except `Key Mappings`
(see separate section) should be self-explanatory. 

### Editing Key Mappings

Selecting `Key Mappings` from the menu opens the configuration JSON file in your default text editor. 
Each mapping has the following fields: 

- command: The name of the command
- key: The shortcut for the command
- mapping: Each application and its corresponding shortcut

#### Command
This name is just for your own information.

#### Key
The unified shortcut, consisting of unicode symbols, separated by spaces. 
You can add modifiers such as `⌃` (Control), `⌥` (Option), `⌘` (Command), `⇧` (Shift) and special keys,
such as `↑` (Arrow Up) or `↓` (Arrow Down). The full list of available options is shown at the end of this 
file. See the exisiting key file for some examples and combinations.

#### Mapping
The mapping part lists each application you want to support and the corresponding shortcuts. Use the name 
displayed in the title bar of the application. This name is used to find the active application and the 
mappings that should be registered.

#### Shortcut Sequences
You can map a shortcut to a sequence of multiple keys. For example, in Xcode there is no default shortcut
to duplicate a line. However, pressing a sequence of five different key combinations in succession 
achieves the same effect. Each part of a sequence must be separated by a `|` (pipe). The sequence for the 
`duplicate line command` in Xcode is:  
`⌃ A | ⇧ ↓ | ⌘ C | ⌘ V | ⌘ V`

When CodingKeys sees pipes, it fires those key combinations one after the other. That way, you might also 
want to add other shortcuts that trigger useful sequences (although I haven't found use cases beyond
Xcode yet...).

#### Saving Changes
Whenever you save the file, the mappings are automatically reloaded and should immediately take effect.
Please make sure to use correct JSON syntax. The app currently handles errors poorly, 
so chances are the app won't start or crash if there are errors in this file. If something goes wrong, 
make sure to copy your mappings and then re-install the app.

#### Default Mappings
The default key file contains mappings for some commands of Eclipse, Android Studio, Xcode and Sublime Text. 
You might need to change some of the mappings for Xcode (Move Line Up, Move Line Down) or add non-existing
shortcuts (for example, renaming has no default shortcut in Xcode).

| Command | Key | Android Studio | Eclipse | Sublime Text | Xcode |
| ----- | ----- | ----- | ----- | ----- | ----- |
| **Move Line Up** | **`⌃ ⌥ ↑`** | ⇧ ⌥ ↑ | ⌥ ↑ | ⌃ ⌘ ↑ | ⌃ ⌥ ↑ |
| **Move Line Down** | **`⌃ ⌥ ↓`** | ⇧ ⌥ ↓ | ⌥ ↓ | ⌃ ⌘ ↓ | ⌃ ⌥ ↓ |
| **Duplicate Line** | **`⌘ D`** | ⌘ D | ⌥ ⌘ ↓ | ⇧ ⌘ D | ⌃ A &#124; ⇧ ↓ &#124; ⌘ C &#124; ⌘ V &#124; ⌘ V |
| **Delete Line** | **`⌘ ⌫`** | ⌘ ⌫ | ⌘ D | ⌃ ⇧ K | ⌃ A &#124; ⌃ K &#124; ⌃ K |
| **Format** | **`⇧ ⌘ F`** | ⌥ ⌘ L | ⇧ ⌘ F | ⌃ ⇧ R | ⌃ I |
| **Rename** | **`⌃ ⌘ R`** | ⇧ F6 | ⌥ ⌘ R | ⌃ ⌘ G | ⌃ ⌥ R |
| **Toggle Comment** | **`⌘ ⇧ 7`** | ⌘ / | ⌘ 7 | ⌘ / | ⌘ / |
| **Quick Open** | **`⇧ ⌘ O`** | ⌘ O | ⇧ ⌘ T | ⌘ P | ⇧ ⌘ O |
| **Run** | **`⌘ R`** | ⌃ R | ⇧ ⌘ F11 | ⌘ B | ⌘ R |

#### Share Your Mappings
If you add new commands or tools and want to share them, just open an issue (tag `key file`) and paste your
config.

### Bugs and Features
Working with key codes is somewhat tricky and non-trivial, so you might discover some combinations or special 
keys that don't work. Please open an issue and describe the problem or just fix the issue yourself :) and 
send a pull request.

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
`\Ud83d\Udd0a` VolumeUp  
`\Ud83d\Udd08` VolumeDown  
`\Ud83d\Udd07` Mute  
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
