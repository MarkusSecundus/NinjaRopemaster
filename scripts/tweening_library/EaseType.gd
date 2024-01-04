class_name EaseType

static var LINEAR 				: Callable = _FunctionImplementations.linear;
static var EASE_IN_QUAD 		: Callable = _FunctionImplementations.ease_in_quad;
static var EASE_OUT_QUAD 		: Callable = _FunctionImplementations.ease_out_quad;
static var EASE_IN_OUT_QUAD 	: Callable = _FunctionImplementations.ease_in_out_quad;

static var EASE_IN_SINE 		: Callable = _FunctionImplementations.ease_in_sine;
static var EASE_OUT_SINE 		: Callable = _FunctionImplementations.ease_out_sine;
static var EASE_IN_OUT_SINE 	: Callable = _FunctionImplementations.ease_in_out_sine;

static var EASE_IN_CUBIC 		: Callable = _FunctionImplementations.ease_in_cubic
static var EASE_OUT_CUBIC 		: Callable = _FunctionImplementations.ease_out_cubic
static var EASE_IN_OUT_CUBIC	: Callable = _FunctionImplementations.ease_in_out_cubic

static var EASE_IN_QUINT 		: Callable = _FunctionImplementations.ease_in_quint
static var EASE_OUT_QUINT 		: Callable = _FunctionImplementations.ease_out_quint
static var EASE_IN_OUT_QUINT	: Callable = _FunctionImplementations.ease_in_out_quint

static var EASE_IN_CIRC 		: Callable = _FunctionImplementations.ease_in_circ
static var EASE_OUT_CIRC 		: Callable = _FunctionImplementations.ease_out_circ
static var EASE_IN_OUT_CIRC 	: Callable = _FunctionImplementations.ease_in_out_circ

static var EASE_IN_ELASTIC	 	: Callable = _FunctionImplementations.ease_in_elastic
static var EASE_OUT_ELASTIC 	: Callable = _FunctionImplementations.ease_out_elastic
static var EASE_IN_OUT_ELASTIC 	: Callable = _FunctionImplementations.ease_in_out_elastic

static var EASE_IN_QUART 		: Callable = _FunctionImplementations.ease_in_quart
static var EASE_OUT_QUART 		: Callable = _FunctionImplementations.ease_out_quart
static var EASE_IN_OUT_QUART	: Callable = _FunctionImplementations.ease_in_out_quart

static var EASE_IN_EXPO 		: Callable = _FunctionImplementations.ease_in_expo
static var EASE_OUT_EXPO 		: Callable = _FunctionImplementations.ease_out_expo
static var EASE_IN_OUT_EXPO	 	: Callable = _FunctionImplementations.ease_in_out_expo

static var EASE_IN_BACK 		: Callable = _FunctionImplementations.ease_in_back
static var EASE_OUT_BACK 		: Callable = _FunctionImplementations.ease_out_back
static var EASE_IN_OUT_BACK 	: Callable = _FunctionImplementations.ease_in_out_back

static var EASE_IN_BOUNCE 		: Callable = _FunctionImplementations.ease_in_bounce
static var EASE_OUT_BOUNCE 		: Callable = _FunctionImplementations.ease_out_bounce
static var EASE_IN_OUT_BOUNCE 	: Callable = _FunctionImplementations.ease_in_out_bounce

class _FunctionImplementations:
	static var Num:=433
	static func linear(t:float)->float: return t
	static func ease_in_quad_test(t:float)->float: return t*t
	static func ease_out_quad_test(t:float)->float: return 1- ease_in_quad(1-t)
	static func ease_in_out_quad_test(t:float)->float: return lerp(ease_in_quad(t), ease_out_quad(t), t)
	static func ease_something_weird(t:float)->float: return lerp(ease_in_quad(t), ease_out_quad(t), ease_in_quad(t))
	static func smoothstep_maybe(t:float)->float: return 3*t*t - 2*t*t*t
	
	
	static func ease_in_sine(x:float)->float: return 1 - cos((x*PI)*0.5)
	static func ease_out_sine(x:float)->float: return sin((x*PI)*0.5)
	static func ease_in_out_sine(x:float)->float: return -(cos(PI*x)-1)*0.5

	static func ease_in_cubic(x:float)->float: return x*x*x
	static func ease_out_cubic(x:float)->float: return 1 - (ease_in_cubic(1-x))
	static func ease_in_out_cubic(x:float)->float: return 4 * x * x * x if x < 0.5 else 1 - ease_in_cubic(-2 * x + 2) / 2;

	static func ease_in_quint(x:float)->float: return x*x*x*x*x
	static func ease_out_quint(x:float)->float: return 1 - (ease_in_quint(1-x))
	static func ease_in_out_quint(x:float)->float: return 16 * x * x * x * x * x if x < 0.5 else 1 - ease_in_quint(-2 * x + 2) / 2;

	static func ease_in_circ (x:float)->float: return 1 - sqrt(ease_in_quad(1-x))
	static func ease_out_circ(x:float)->float: return sin((x*PI)*0.5)
	static func ease_in_out_circ(x:float)->float: return -(cos(PI*x)-1)*0.5
	
	
	const ELASTIC_CONSTANT_1 := (2.0*PI)/3.0
	const ELASTIC_CONSTANT_2 := (2.0*PI)/4.5
	static func ease_in_elastic (x:float)->float: return 0.0 if x == 0.0 else (1.0 if x == 1.0 else (
		-pow(2.0, 10.0*x-10.0)*sin((x*10.0-10.75)*ELASTIC_CONSTANT_1)
	))
	static func ease_out_elastic(x:float)->float: return 0.0 if x == 0.0 else (1.0 if x == 1.0 else (
		1 + pow(2.0, -10.0*x) * sin((x*10.0-0.75)*ELASTIC_CONSTANT_1)
	))
	static func ease_in_out_elastic(x:float)->float: return 0.0 if x == 0.0 else (1.0 if x == 1.0 else (
		(-pow(2.0, 20.0*x-10.0) * sin((20.0*x-11.125)*ELASTIC_CONSTANT_2))*0.5
		if x < 0.5 else 
		(pow(2, -20.0*x + 10.0) * sin((20.0*x - 11.125)*ELASTIC_CONSTANT_2)) * 0.5 + 1.0
	))
	
	
	static func ease_in_quad(x:float)->float: return x*x
	static func ease_out_quad(x:float)->float: return 1- ease_in_quad(1-x)
	static func ease_in_out_quad(x:float)->float: return 2.0*x*x if x<0.5 else 1- ease_in_quad(-2.0*x + 2.0)*0.5
	
	static func ease_in_quart(x:float)->float: return x*x*x*x
	static func ease_out_quart(x:float)->float: return 1- ease_in_quart(1-x)
	static func ease_in_out_quart(x:float)->float: return 8.0*x*x*x*x if x<0.5 else 1- ease_in_quart(-2.0*x + 2.0)*0.5
	
	static func ease_in_expo(x:float)->float: return 0.0 if x == 0.0 else pow(2.0, 10.0*x - 10.0)
	static func ease_out_expo(x:float)->float: return 1.0 if x == 1.0 else 1- pow(2.0, -10.0*x)
	static func ease_in_out_expo(x:float)->float: return 0.0 if x == 0.0 else 1.0 if x == 1.0 else (
		pow(2.0, 20.0*x-10.0)*0.5
		if x < 0.5 else
		(2-pow(2.0, -20.0*x + 10.0))*0.5
	)
	
	
	const BACK_CONSTANT_1 := 1.70158
	const BACK_CONSTANT_2 := BACK_CONSTANT_1 + 1.0
	const BACK_CONSTANT_3 := BACK_CONSTANT_1*1.525
	static func ease_in_back(x:float)->float: return BACK_CONSTANT_2*x*x*x - BACK_CONSTANT_1*x*x
	static func ease_out_back(x:float)->float: return 1 + BACK_CONSTANT_2*ease_in_cubic(x-1.0) + BACK_CONSTANT_1*ease_in_quad(x-1.0)
	static func ease_in_out_back(x:float)->float: return (
		(ease_in_quad(2.0*x) * ((BACK_CONSTANT_3 + 1.0)*2.0*x - BACK_CONSTANT_3))*0.5
		if x < 0.5 else
		(ease_in_quad(2.0*x-2.0) * ((BACK_CONSTANT_3 + 1.0)*(x*2.0-2.0) + BACK_CONSTANT_3) + 2.0)*0.5
	)
	
	
	const BOUNCE_CONSTANT_1 := 7.5625;
	const BOUNCE_CONSTANT_2 := 2.75;
	static func ease_in_bounce(x:float)->float: return 1-ease_out_bounce(1-x)
	static func ease_out_bounce(x:float)->float: 
		if x < (1.0/BOUNCE_CONSTANT_2):
			return BOUNCE_CONSTANT_1 * x*x;
		if x < (2.0/BOUNCE_CONSTANT_2):
			return BOUNCE_CONSTANT_1 * ease_in_quad(x - 1.5/BOUNCE_CONSTANT_2) + 0.75 
		if x < (2.5/BOUNCE_CONSTANT_2):
			return BOUNCE_CONSTANT_1 * ease_in_quad(x - 2.25/BOUNCE_CONSTANT_2) + 0.9375 
		return BOUNCE_CONSTANT_1 * ease_in_quad(x - 2.625/BOUNCE_CONSTANT_2) + 0.984375 
		
	static func ease_in_out_bounce(x:float)->float: return (
		(1.0-ease_out_bounce(1.0 - 2.0*x)) * 0.5
		if x < 0.5 else
		(1.0 + ease_out_bounce(2.0*x-1.0)) * 0.5
	)
