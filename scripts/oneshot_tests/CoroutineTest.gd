extends Node


class TestGenerateNumbers: 
	extends CoroutineUtils.Generator
	
	func _impl(begin: int, end: int)->void:
		await _yield(50)
		await _yield(55)
		
		if begin < end:
			while begin <= end:
				await _yield(begin)
				begin += 1
		else:
			while begin > end:
				await _yield(begin)
				begin -= 1

func _ready():
	var tst:= TestGenerateNumbers.new([1, -15]);
	while(tst.MoveNext()):
		print("value: {0}".format([tst.Current]))
	print("finished generation!")

