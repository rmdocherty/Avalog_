# Used hiulit's work from https://github.com/hiulit/Godot-3-2D-Fake-Confetti-Particles
# Updated to Godot 4


@tool
extends Node2D
## Draw-based 2D confetti particles emitter.
class_name FakeConfettiParticles

## If `true`, particles are being emitted.
@export var emitting: bool = false : set = _set_emitting
## The type of particles:
##
## - `0 (Square)`.
## - `1 (Circle)`.
@export var type: int = 0
## The number of particles.
@export var amount: int = 150
## If `true`, the number of particles can be a
## random number between `amount / 2` and `amount * 2`.
##
## If `false`, the number of particles will be the exact number in @link_name {amount}.
@export var random_amount: bool = true
## The size of the particles.
##
## If the particles are squares, `size` is the length of their sides.
## If the particles are circles, `size` is their radius.
@export var size: float = 3.0
## If `true`, the size of the particles can be a
## random number between `size / 2` and `size * 2`.
##
## If `false`, the size of the particles will be the exact number in @link_name {size}.
@export var random_size: bool = true
## Controls the visibility of the particles.
@export var visibility_rect: Rect2 = Rect2(0.0, 0.0, 1024.0, 600.0)
## The color/s of the particles.
# TODO: customise these to be the shader colours, and display the winning player's palette
@export var colors: Array = [
	Color("#008751"),
	Color("#00e436"),
	Color("#29adff"),
	Color("#7e2553"),
	Color("#83769c"),
	Color("#ff004d"),
	Color("#ff77a8"),
	Color("#ffa300"),
	Color("#ffec27")
]

var albion_colours: Array = [
	Color("#3978a8"),
	Color("#394778"),
	Color("#2e3d70"),
	Color("#4784b2"),
	Color("#323cad"),
	Color("#4a51a0"),
	Color("#32398a"),
	Color("#2e3d70"),
]

var rome_colours: Array = [
	Color("#c23131"),
	Color("#ba3939"),
	Color("#931515"),
	Color("#e13939"),
	Color("#b12c2c"),
	Color("#a03f3f"),
	Color("#ad1818"),
	Color("#a03f3f"),
]

var bretagne_colours: Array = [
	Color("#4a791f"),
	Color("#455f2d"),
	Color("#315134"),
	Color("#5c922a"),
	Color("#428207"),
	Color("#4b692f"),
	Color("#3c6814"),
	Color("#1d3820"),
]

var turkiye_colours: Array = [
	Color("#fbeb34"),
	Color("#bfb333"),
	Color("#bfb333"),
	Color("#e0d342"),
	Color("#89811f"),
	Color("#a09f4a"),
	Color("#e9bc18"),
	Color("#b1a94e"),
]

var morgana_colours: Array = [
	Color("#414040"),
	Color("#1f2123"),
	Color("#1d1c27"),
	Color("#7e7782"),
	Color("#261730"),
	Color("#1f2123"),
	Color("#160a1e"),
	Color("#272020"),
]

var colours_list = [albion_colours, rome_colours, bretagne_colours, turkiye_colours, morgana_colours]

## If `true`, the initial position of the particles
## can be a random position in @link_name {visibility_rect}.
##
## If `false`, the initial position of the particles will be `Vector(0, 0)`.
@export var random_position: bool = true
## If `true`, only one emission cycle occurs.
@export var one_shot: bool = false
## If `true`, the particles will gradually fade.
##
## If `false`, the particles will end abruptly.
@export var fade: bool = true
## The duration (in seconds) of the emission cycle.
@export var timer_wait_time: float = 1.0

var particles: Array = []
var particles_amount: int
var particles_position: Vector2
var timer: float = 0.0


func _ready() -> void:
	set_process(false)
	self.emitting = not Engine.is_editor_hint()


func _process(delta: float) -> void:
	timer += delta

	if timer > timer_wait_time:
		timer = 0.0

		if one_shot:
			self.emitting = false
			if not Engine.is_editor_hint():
				queue_free()
		else:
			_create_particles()

	_particles_explode(delta)

	queue_redraw()


func _draw() -> void:
	for particle in particles:
		if type == 0:
			draw_rect(Rect2(particle.position, particle.size), particle.color)
		elif type == 1:
			draw_circle(
				particle.position, ((particle.size.x + particle.size.y) / 2) / 2, particle.color
			)


func _create_particles() -> void:
	particles.clear()

	if random_amount:
		particles_amount = _get_random_amount()
	else:
		particles_amount = amount

	if random_position:
		particles_position = _get_random_position()
	else:
		particles_position = Vector2.ZERO

	for _i in particles_amount:
		var particle = {
			color = _get_random_color(),
			gravity = _get_random_gravity(),
			position = particles_position,
			size = _get_random_size(),
			velocity = _get_random_velocity()
		}

		if not random_size:
			particle.size = size

		particles.append(particle)


func _particles_explode(delta: float) -> void:
	for particle in particles:
		if fade:
			particle.color.a -= 0.6 * delta

		particle.velocity.x *= .999
		particle.velocity.y *= .991

		particle.position += (particle.velocity + particle.gravity) * delta


func _get_random_color() -> Color:
	return colors[randi() % colors.size()]


func _get_random_gravity() -> Vector2:
	return Vector2(randf_range(-200, 200), randf_range(400, 800))


func _get_random_amount() -> int:
	return round(randf_range(amount / 2.0, amount * 2.0))


func _get_random_position() -> Vector2:
	var x := randf_range(0, visibility_rect.size.x)
	var y := randf_range(0, visibility_rect.size.y)

	return Vector2(x, y)


func _get_random_size() -> Vector2:
	var min_size := int(ceil(size / 2.0))
	var max_size := int(ceil(size * 2.0))
	var random_min_max_size := randi() % (max_size - min_size + 1) + min_size

	return Vector2(random_min_max_size, random_min_max_size)


func _get_random_velocity() -> Vector2:
	return Vector2(randf_range(-200, 200), randf_range(-600, -800))


func _set_emitting(new_value: bool) -> void:
	if new_value != emitting:
		emitting = new_value

		if emitting:
			set_process(true)
			_create_particles()
		else:
			set_process(false)
			particles.clear()
			timer = 0.0
			queue_redraw()
			property_list_changed.emit()
			#property_list_changed_notify()
