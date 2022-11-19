class_name FairNG
extends Reference

# MIT LICENSE
#
# Copyright 2022 Gennady "Don Tnowe" Krupenyov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

var rng : RandomNumberGenerator

var _numbers_available := []

# Create a FairNG object. Optionally, pass a RandomNumberGenerator - if not, new one is created.
# `max_int` defines number of non-repeating integers in generated sequences.
# If you only generate integers, set this equal to or a multiple of the results' max value.
func _init(max_int : int = 200, random_number_generator : RandomNumberGenerator = null):
	rng = random_number_generator
	if random_number_generator == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()

	_numbers_available.resize(max_int)
	for i in max_int:
		_numbers_available[i] = true


func get_max():
	return _numbers_available.size()


# Returns a random number between 0 and 1, inclusive.
# Set `inverted_benevolence` to `true` when a high number would be harmful for the player.
func randf(inverted_benevolence = false):
	var value = (self.randi(inverted_benevolence) + rng.randf()) / _numbers_available.size()
	return 1.0 - value if inverted_benevolence else value

# Returns a random number between 0 and its own set limit set at creation.
# Result never equals to the limit.
# If generation with a variable maximum boundary are needed, consider using `randf()`.
# Set `inverted_benevolence` to `true` when a high number would be harmful for the player.
func randi(inverted_benevolence = false):
	var count := 0
	for i in _numbers_available.size():
		if _numbers_available[i]:
			count += 1

	if count == 0:
		reset_state()
		return self.randi(inverted_benevolence)
	
	var pos := rng.randi() % count
	for i in _numbers_available.size():
		if _numbers_available[i]:
			if pos == 0:
				_numbers_available[i] = false
				return count - i - 1 if inverted_benevolence else i

			pos -= 1

	return 0

# Clear all blocked values. After you call this, any number in range can drop.
func reset_state():
	for i in _numbers_available.size():
		_numbers_available[i] = true
