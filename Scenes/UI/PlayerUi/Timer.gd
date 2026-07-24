extends Label

signal timer_finished

@export var start_time_seconds: float = 120
var time_left: float = 0.0
var is_running: bool = true

func _ready() -> void:
    time_left = start_time_seconds

func _process(delta: float) -> void:
    if not is_running:
        return
        
    if time_left > 0:
        time_left -= delta
        if time_left < 0:
            time_left = 0
        text = format_time(time_left)
    else:
        is_running = false
        emit_signal("timer_finished")
        on_timeout()

func format_time(seconds: float) -> String:
    var mins: int = int(seconds) / 60
    var secs: int = int(seconds) % 60
    return "%02d:%02d" % [mins, secs]

func on_timeout() -> void:
    print("Time is up! Game over.")

