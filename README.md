# SignalPrinter

![](addons/signal_printer/icon.svg)

_Plugin for monitoring signals of a global EventBus singleton._

While creating Godot projects, developers often use a global signal script, a singleton, which houses only signals needed for unrelated systems to talk to each other. These scripts go by names like EventBus, MessageBus, Signalton, etc. One downside these scripts often have is the inability to see under the hood, as there isn't an easy way to monitor multiple signals being emitted. Developers often have to resort to using `print()` statements on each end of the signal path.

This plugin adds a `SignalPrinter` node, which automatically connects to all signals of your global EventBus and routes them to a method, which prints the signal's name, all arguments and (optionally) the time at which the signal was recieved.

Example output:

><u>**player_interacted**</u>
with : Node3D = Pickup:<Area3D#41657828805> _// The type is the same as was declared in the signal itself_
time (ticks msec) = 4647

><u>**inventory_item_changed**</u>
item : Item = <Resource#-9223371996253911657> _// It even recognizes custom Resource types (Item)_
index : int = 1 _// And has support for Variant types_
time (ticks msec) = 17442

![Example output screenshot](assets\OutputExample.JPG "Example output screenshot")

## Usage
You **need** to replace `global_bus` in [signal_printer.gd](addons/signal_printer/signal_printer.gd) script with your own singleton's reference. Otherwise you get an error. 

### Example
If your global bus is named `EventBus`, you simply replace null with EventBus

From:
`static var global_bus : Node = null` :x:

To:
`static var global_bus : Node = EventBus` :heavy_check_mark:

You pass the singleton in directly, not by its name.
`static var global_bus : Node = "EventBus"` :x:

After that, you can add this node anywhere in the scene and remove it, when you don't need it anymore.
![Node in scene](assets\NodeInScene.JPG) ![Node properties](assets\EditableProperties.JPG)

### Warning
As GDScript currently doesn't support variable argument count, arguments in the function are added manually. Currently, the _max argument count per signal is **10**_, but if you need more, you can add them easily. 

## Further reading
[How to create an EventBus in Godot](https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/)
[Theory behind the Observer pattern](https://gameprogrammingpatterns.com/observer.html)