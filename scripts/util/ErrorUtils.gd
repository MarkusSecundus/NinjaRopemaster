extends Object
class_name ErrorUtils


static func report_error(message: String)-> void:
	push_error(message);
	printerr(message);
