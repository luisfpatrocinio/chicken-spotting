extends CanvasLayer

var sentInfo: bool = false;


func _ready():
	pass

func _process(delta):
	# levelRef.winners é um array[int] que guarda os indices dos jogadores vencedores.
	# Obter texto a partir do level.winners
	if len(Global.levelRef.winners) == 1:
		# Apenas um jogador venceu:
		var _winnerName = Global.levelRef.winners[0]
		$Label.text = "Player " + _winnerName + " is the winner!";
	elif len(Global.levelRef.winners) > 1:
		# Mais de um jogador venceu:
		var winners_text = "Players"
		for i in range(len(Global.levelRef.winners)):
			if i == len(Global.levelRef.winners) - 1:
				winners_text += " and %s" % Global.levelRef.winners[i]
			elif i == 0:
				winners_text += " %s" % [Global.levelRef.winners[i]]
			else:
				winners_text += ", %s" % [Global.levelRef.winners[i]]
		$Label.text = "%s are the winners!" % winners_text
	else:
		# Nenhum jogador venceu.
		$Label.text = "No winners this time."
	
	if !sentInfo:
		Connection.endGame($Label.text);
		sentInfo = true;
	
	$Label2.text = "Restarting in %s..." % floor($RestartTimer.time_left)

func _on_restart_timer_timeout():
	Global.transitionToScene("title");
