
# Game.gd
# Responsible for game state items like whether or not the player is player1 or player2

extends Node

var cardSelected
var mouseOnPlacement = false

# Flags that indicate current state of the game
var cardActive = true
var PLayer1 = true
var Player2 = false
