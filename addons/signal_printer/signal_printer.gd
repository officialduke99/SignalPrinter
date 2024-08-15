class_name SignalPrinter
extends Node

## A node for printing all signals of a given global node.
##
## While creating Godot projects, developers often use a global
## signal script, a singleton, which houses only signals needed
## for unrelated systems to talk to each other. These scripts
## go by names like EventBus, MessageBus, Signalton, etc.
## One downside these scripts often have is the inability to see
## under the hood, as there isn't an easy way to monitor multiple
## signals being emitted. Developers often have to resort to using
## print() statements on each end of the signal path. [br][br]
##
## What this script allows is dynamically getting all signals of this
## script and connecting them to a common method, which prints out
## the signal's name, all arguments and (optionally) the time at
## which the signal was recieved. [br][br]
##
## [b]Warning:[/b] As GDScript currently doesn't support variable
## argument count, arguments in the function are added manually.
## Currently, the max argument count per signal is 10, but if you
## need more, you can add them easily.
##
## @tutorial(EventBus usage in Godot): https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/
## @tutorial(Observer pattern explanation): https://gameprogrammingpatterns.com/observer.html

## The bbcode tags to be used with the signal name when printed with
## print_rich(). By default prints the name underlined and bold.
const NAME_TAGS : String = "[u][b]"

## The reference to your global signal bus. You have to replace null
## with your own global bus.
static var global_bus : Node = null

## A property to quickly disable printing from editor, if it makes
## the output too cluttered
@export var enabled : bool = true

## If true, it will print the time the signal was recieved after
## the signal's arguments
@export var print_time : bool = true

func _ready():
	assert(global_bus != null, "SignalPrinter: No global bus was defined")
	for _signal in global_bus.get_signal_list():
		global_bus.connect(_signal["name"], _on_signal_recieved.bind(_signal["args"], _signal["name"]))

# All signals get funneled into this method. As you can see, there
# are 12 arguments, but because we are binding two of them to
# identify our signal, the signal itself can only carry 10 max.
#
# If you want to add more, just continue the argument line.
# Don't forget to also add the new arguments into the args array.
func _on_signal_recieved(arg1 = null, arg2 = null, arg3 = null, 
						arg4 = null, arg5 = null, arg6 = null, 
						arg7 = null, arg8 = null, arg9 = null, 
						arg10 = null, arg11 = null, arg12 = null):
	
	if not enabled:
		return
	
	var args : Array = [arg1, arg2, arg3, arg4, arg5, arg6, 
						arg7, arg8, arg9, arg10, arg11, arg12]
	
	# Remove unused arguments from the back
	for i in range(max(args.size() - 1, 0), -1, -1):
		if args[i] == null:
			args.remove_at(i)
		else:
			break
	
	# Gets the signal's name, which we binded in _ready()
	var signal_name : String = args.pop_back()
	
	print("")
	print_rich(NAME_TAGS, signal_name)
	
	# Gets the signal's arguments' properties, 
	# which we binded in _ready()
	var arg_properties : Array[Dictionary] = args.pop_back()
	
	# Now args only contains actual arguments passed in
	for i in args.size():
		var current_arg = arg_properties[i]
		
		# If the arg has a non-empty class name, 
		# we can even get custom class names
		var arg_type : String = current_arg["class_name"]
		
		# If not, it means that the type is a Variant type
		# That means we have to get it from elsewhere
		# Could be done with typeof(args[i]), but I decided to use
		# the signal's properties to catch potential mismatches 
		# between the expected and actual type
		if arg_type.is_empty():
			var type : int = current_arg["type"]
			arg_type = type_string(type)
		
		print(current_arg["name"] + " : " + arg_type + " = ", args[i])
	
	if print_time:
		print("time (ticks msec) = ", Time.get_ticks_msec())
