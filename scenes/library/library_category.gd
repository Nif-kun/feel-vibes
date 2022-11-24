extends HFlowContainer
class_name LibraryCategory

# Signals
signal card_pressed(item)

# Private
var _item_card_scene = preload("res://scenes/library/ItemCard.tscn")
var _built := false
var _thread : Thread

# Public
var item_list := [] # an array of Objects (depending on use)
var card_list := [] # an array of ItemCard


func _ready():
	# warning-ignore:return_value_discarded
	connect("visibility_changed", self, "_visibility_changed")


func setup(items:Array):
	item_list = items


func load_items(): # Interface
	pass


func refresh_items():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	card_list.clear()
	load_items()


func add_card(title:String, cover_art:Texture, object):
	var item_card = _item_card_scene.instance()
	if item_card is ItemCard:
		item_card.set_item(title, cover_art, object)
		# warning-ignore:return_value_discarded
		item_card.connect("pressed", self, "_on_ItemCard_pressed")
	card_list.append(item_card)
	add_child(item_card)


func remove_card(item_card): #might be string or object itself
	card_list.erase(item_card)
	remove_child(item_card)


func _visibility_changed():
	if visible and !_built:
		load_items()


func _on_ItemCard_pressed(item_card):
	emit_signal("card_pressed", item_card)
