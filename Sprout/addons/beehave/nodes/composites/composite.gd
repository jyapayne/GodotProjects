## A Composite node controls the flow of execution of its children in a specific manner.
@tool
class_name Composite extends BeehaveNode
@icon("../../icons/category_composite.svg")


var running_child: BeehaveNode = null


func _ready():
	if Engine.is_editor_hint():
		return
	
	if self.get_child_count() < 1:
		push_error("BehaviorTree Error: Composite %s should have at least one child (NodePath: %s)" % [self.name, self.get_path()])


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()
	
	if get_children().filter(func(x): return x is BeehaveNode).size() < 2:
		warnings.append("Any composite node should have at least two children. Otherwise it is not useful.")
	
	return warnings


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	if running_child != null:
		running_child.interrupt(actor, blackboard)
		running_child = null
