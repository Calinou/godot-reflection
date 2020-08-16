# Reflection for Godot 4.0

[![Screenshot of Reflection](https://raw.githubusercontent.com/Calinou/media/master/godot-reflection/screenshot-thumb.png)](https://raw.githubusercontent.com/Calinou/media/master/godot-reflection/screenshot.png)

A port of [Tesseract](http://tesseract.gg)'s Reflection map for testing Godot 4.0's new renderer.

## Try it out

### Installation

Clone the Git repository:

```bash
git clone https://github.com/Calinou/godot-reflection.git
```

You can also
[download a ZIP archive](https://github.com/Calinou/godot-reflection/archive/master.zip)
if you don't have Git installed.

**You need a development build of Godot 4.0 to run this demo.**

Once you have the project files, open the Godot Project Manager, click the
**Import** button, then select the `project.godot` file of this project.
Confirm importing, then edit the project (so that the resources are imported
by the editor). Exit the editor (go back to the project manager), then run
the project. This is to make sure the editor does not render the demo in
the background, which would slow down the running project a lot.

**Note:** If some materials don't show up, try selecting
`reflection/reflection.obj` in the FileSystem dock, go to the Import dock then
click **Reimport**.

## License

Copyright © 2020 Hugo Locurcio and contributors

- Unless otherwise specified, files in this repository are licensed under the
  MIT license, see [LICENSE.md](LICENSE.md) for more information.
- The [Reflection](reflection/reflection.txt) map is licensed under CC BY-SA 3.0.
- Textures in the `reflection/` folder are licensed under various licenses:
  - `agf81/`: CC BY 3.0 Unported
  - `cgtextures`: [Textures.com](https://www.textures.com/contact-terms-of-use.html)'s
    license, may not be redistributed separately.
  - `base/`: CC0 1.0 Universal
  - `nieb/`: CC0 1.0 Universal
  - `nobiax/`: CC0 1.0 Universal

A big thanks to the Cube 2 engine community for making and releasing all these maps
:slightly_smiling_face:
