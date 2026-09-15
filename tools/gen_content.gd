extends SceneTree
## Content authoring pipeline: run with
##   godot --headless --path . --script res://tools/gen_content.gd
## to (re)generate the .tres data files under narrative/, combat/, etc.
## Safe to re-run — every save overwrites its target path idempotently.
## Editing content by hand afterward directly in the .tres is also fine;
## this script is just the safest way to author nested resource arrays.

func _init() -> void:
	gen_maelle()
	gen_combat_content()
	gen_tom()
	gen_romain()
	gen_victor()
	gen_luc()
	gen_sacha()
	gen_rudric()
	gen_gaspard()
	gen_aelia()
	gen_elena()
	gen_endings()
	print("Content generation complete.")
	quit()


func gen_endings() -> void:
	var fin_veritable := EndingData.new()
	fin_veritable.id = &"fin_veritable"
	fin_veritable.title = "Fin véritable — L'Écho s'efface"
	fin_veritable.description = "L'Anomalie sauve les habitants, sauve la réalité, arrête les boucles, et accepte de disparaître. Personne ne se souvient réellement de qui elle était. Elle regarde une dernière fois le monde qu'elle a sauvé. Elle sourit. Puis disparaît. Le monde continue — et quelque part, sans savoir pourquoi, certains ressentent une impression, une habitude inexplicable, une émotion qu'ils ne comprennent pas."
	fin_veritable.required_flags = [&"ending/sacrifice_accepted"]
	fin_veritable.priority = 100
	fin_veritable.is_true_ending = true
	ResourceSaver.save(fin_veritable, "res://narrative/Endings/fin_veritable.tres")

	var fin_refus := EndingData.new()
	fin_refus.id = &"fin_refus"
	fin_refus.title = "Fin — Le refus"
	fin_refus.description = "L'Anomalie refuse de disparaître. La boucle ne se brise pas. Quelque part, un fragment de lumière continue de chercher, encore et encore, un monde qui ne finira jamais tout à fait de se souvenir de lui-même."
	fin_refus.required_flags = [&"ending/sacrifice_refused"]
	fin_refus.priority = 50
	fin_refus.is_true_ending = false
	ResourceSaver.save(fin_refus, "res://narrative/Endings/fin_refus.tres")

	var fin_degradation := EndingData.new()
	fin_degradation.id = &"fin_degradation"
	fin_degradation.title = "Fin — Trop tard"
	fin_degradation.description = "Le monde s'est effondré avant que l'Anomalie n'ait pu comprendre ce qu'elle était censée faire. La boucle recommence, mais quelque chose d'essentiel a déjà été perdu — et cette fois, il ne reste presque rien à sauver."
	fin_degradation.required_flags = [&"reality/degradation_critical"]
	fin_degradation.forbidden_flags = [&"ending/sacrifice_accepted", &"ending/sacrifice_refused"]
	fin_degradation.priority = 75
	fin_degradation.is_true_ending = false
	ResourceSaver.save(fin_degradation, "res://narrative/Endings/fin_degradation.tres")

	# The altar at the temple: a placeholder line until the player has at
	# least met Aelia, then the real final choice.
	var l_not_ready := DialogueLine.new()
	l_not_ready.line_id = &"pas_pret"
	l_not_ready.speaker = ""
	l_not_ready.text = "(L'autel est froid et silencieux. Il ne se passe rien — pas encore.)"

	var dlg_not_ready := DialogueData.new()
	dlg_not_ready.id = &"altar_pas_pret"
	dlg_not_ready.start_line_id = &"pas_pret"
	dlg_not_ready.lines = [l_not_ready]
	ResourceSaver.save(dlg_not_ready, "res://narrative/Dialogue/content/dialogue_altar_pas_pret.tres")

	var choice_accepte := DialogueChoice.new()
	choice_accepte.text = "Accepter — disparaître pour que tout le reste continue."
	choice_accepte.sets_flags = [&"ending/sacrifice_accepted"]
	choice_accepte.ends_dialogue = true

	var choice_refuse := DialogueChoice.new()
	choice_refuse.text = "Refuser. Pas comme ça. Pas encore."
	choice_refuse.sets_flags = [&"ending/sacrifice_refused"]
	choice_refuse.ends_dialogue = true

	var l_final := DialogueLine.new()
	l_final.line_id = &"choix_final"
	l_final.speaker = ""
	l_final.text = "(L'autel réagit enfin à ta présence. Tu comprends, sans qu'on te l'explique, ce qu'il attend de toi.)"
	l_final.choices = [choice_accepte, choice_refuse]

	var dlg_final := DialogueData.new()
	dlg_final.id = &"altar_choix_final"
	dlg_final.start_line_id = &"choix_final"
	dlg_final.lines = [l_final]
	dlg_final.required_flags = [&"event/aelia_devotion_revealed"]
	ResourceSaver.save(dlg_final, "res://narrative/Dialogue/content/dialogue_altar_choix_final.tres")


func _save_char(char_data: CharacterData) -> void:
	ResourceSaver.save(char_data, "res://narrative/Characters/%s.tres" % char_data.id)


func _save_dlg(dlg: DialogueData) -> void:
	ResourceSaver.save(dlg, "res://narrative/Dialogue/content/dialogue_%s.tres" % dlg.id)


func gen_tom() -> void:
	var c := CharacterData.new()
	c.id = &"tom"
	c.character_name = "Tom"
	c.age = 7
	c.personality = "extrêmement joyeux, innocent, curieux"
	c.placeholder_color = Color(0.95, 0.85, 0.3, 1.0)
	c.max_health = 15.0
	c.can_die = true
	_save_char(c)

	var choice_oui := DialogueChoice.new()
	choice_oui.text = "Parfois, oui."
	choice_oui.target_line_id = &"reponse_oui"
	var choice_non := DialogueChoice.new()
	choice_non.text = "Non, jamais."
	choice_non.target_line_id = &"reponse_non"

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Tom"
	l1.text = "Hé, toi ! Est-ce que ça t'arrive d'oublier des choses importantes, comme si elles n'avaient jamais existé ?"
	l1.sets_flags = [&"event/tom_met"]
	l1.choices = [choice_oui, choice_non]

	var l2 := DialogueLine.new()
	l2.line_id = &"reponse_oui"
	l2.speaker = "Tom"
	l2.text = "Moi aussi parfois ! Mais mes parents disent que ça revient toujours. C'est vrai, ça, dis ?"

	var l3 := DialogueLine.new()
	l3.line_id = &"reponse_non"
	l3.speaker = "Tom"
	l3.text = "Chanceux ! Moi j'ai oublié le nom de mon chat pendant toute une journée une fois. C'était horrible."

	var dlg := DialogueData.new()
	dlg.id = &"tom_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2, l3]
	_save_dlg(dlg)


func gen_romain() -> void:
	var c := CharacterData.new()
	c.id = &"romain"
	c.character_name = "Romain"
	c.age = 34
	c.personality = "chaleureux, honorable, presque rassurant — mais capable de décisions très dures"
	c.placeholder_color = Color(0.6, 0.5, 0.75, 1.0)
	c.max_health = 40.0
	c.can_die = true
	_save_char(c)

	var choice_presence := DialogueChoice.new()
	choice_presence.text = "Quelle présence ?"
	choice_presence.target_line_id = &"presence"
	var choice_ignore := DialogueChoice.new()
	choice_ignore.text = "Rien, laisse tomber."
	choice_ignore.target_line_id = &"ignore"

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Romain"
	l1.text = "Bienvenue à Boiselle, étranger. Je veille sur cette région du mieux que je peux. N'hésite pas si tu as besoin de quoi que ce soit."
	l1.sets_flags = [&"event/romain_met"]
	l1.choices = [choice_presence, choice_ignore]

	var l2 := DialogueLine.new()
	l2.line_id = &"presence"
	l2.speaker = "Romain"
	l2.text = "...Rien. Disons simplement qu'il y a des choses anciennes, du côté de la montagne, que je préfère ne pas déranger. Je ne la connais pas. Je sais seulement qu'elle existe."

	var l3 := DialogueLine.new()
	l3.line_id = &"ignore"
	l3.speaker = "Romain"
	l3.text = "Comme tu veux. Passe une bonne journée."

	var dlg := DialogueData.new()
	dlg.id = &"romain_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2, l3]
	_save_dlg(dlg)


func gen_victor() -> void:
	var c := CharacterData.new()
	c.id = &"victor"
	c.character_name = "Victor"
	c.age = 27
	c.personality = "sérieux, mais avec un vrai sens de l'humour ; protège le peuple avant de suivre les ordres"
	c.placeholder_color = Color(0.35, 0.45, 0.7, 1.0)
	c.max_health = 60.0
	c.can_die = true
	_save_char(c)

	# Variant used once Maëlle's opening event has fired — completes her quest.
	var l1a := DialogueLine.new()
	l1a.line_id = &"intro"
	l1a.speaker = "Victor"
	l1a.text = "Maëlle m'a parlé de toi — et du fragment qui s'est mis à réagir. Ce n'est pas rien. Tu m'as l'air bien calme pour quelqu'un qui vient de faire briller une relique ancienne."
	l1a.completes_quest_id = &"aider_le_chevalier"
	l1a.sets_flags = [&"event/victor_met"]
	l1a.auto_next_line_id = &"suite"

	var l2a := DialogueLine.new()
	l2a.line_id = &"suite"
	l2a.speaker = "Victor"
	l2a.text = "Je n'ai pas de réponses, seulement une lame et de la bonne volonté. Mais si les choses tournent mal, je serai là."

	var dlg_a := DialogueData.new()
	dlg_a.id = &"victor_apres_fragment"
	dlg_a.start_line_id = &"intro"
	dlg_a.lines = [l1a, l2a]
	dlg_a.required_flags = [&"event/fragment_reacts"]
	_save_dlg(dlg_a)

	# Default variant if met before the forest event.
	var l1b := DialogueLine.new()
	l1b.line_id = &"intro"
	l1b.speaker = "Victor"
	l1b.text = "Tiens, un visage que je ne connais pas. Je suis Victor — je veille sur le village, avec plus ou moins de succès selon les jours."
	l1b.sets_flags = [&"event/victor_met"]

	var dlg_b := DialogueData.new()
	dlg_b.id = &"victor_intro"
	dlg_b.start_line_id = &"intro"
	dlg_b.lines = [l1b]
	_save_dlg(dlg_b)


func gen_luc() -> void:
	var c := CharacterData.new()
	c.id = &"luc"
	c.character_name = "Luc"
	c.age = 41
	c.personality = "ancien voleur devenu quelqu'un de bien ; aide les enfants ; hanté par une possible rechute"
	c.placeholder_color = Color(0.5, 0.4, 0.3, 1.0)
	c.max_health = 45.0
	c.can_die = true
	_save_char(c)

	var choice_passe := DialogueChoice.new()
	choice_passe.text = "On m'a parlé de ton passé."
	choice_passe.target_line_id = &"passe"
	var choice_rien := DialogueChoice.new()
	choice_rien.text = "Rien de spécial, je me présentais."
	choice_rien.target_line_id = &"rien"

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Luc"
	l1.text = "Si tu cherches les enfants du village, ils ne sont pas loin. Je garde un œil sur eux, histoire de rendre un peu de ce que j'ai pris."
	l1.sets_flags = [&"event/luc_met"]
	l1.choices = [choice_passe, choice_rien]

	var l2 := DialogueLine.new()
	l2.line_id = &"passe"
	l2.speaker = "Luc"
	l2.text = "Alors tu sais. Oui, j'ai volé. Un objet sacré, même. Et j'ai eu la chance qu'on me laisse devenir autre chose. Ça ne s'oublie pas facilement, ni pour moi, ni pour les autres."

	var l3 := DialogueLine.new()
	l3.line_id = &"rien"
	l3.speaker = "Luc"
	l3.text = "Dans ce cas, bienvenue. Fais attention à toi ici."

	var dlg := DialogueData.new()
	dlg.id = &"luc_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2, l3]
	_save_dlg(dlg)


func gen_sacha() -> void:
	var c := CharacterData.new()
	c.id = &"sacha"
	c.character_name = "Sacha"
	c.age = 15
	c.personality = "en crise familiale et émotionnelle ; hostile au premier abord ; facilement manqué"
	c.placeholder_color = Color(0.4, 0.55, 0.4, 1.0)
	c.max_health = 30.0
	c.can_die = true
	_save_char(c)

	var choice_calme := DialogueChoice.new()
	choice_calme.text = "(Rester calme.)"
	choice_calme.target_line_id = &"calme"
	var choice_repond := DialogueChoice.new()
	choice_repond.text = "Je ne t'ai rien demandé."
	choice_repond.target_line_id = &"tension"

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Sacha"
	l1.text = "...Encore un étranger que tout le monde va adorer, c'est ça ? Génial."
	l1.sets_flags = [&"event/sacha_met"]
	l1.choices = [choice_calme, choice_repond]

	var l2 := DialogueLine.new()
	l2.line_id = &"calme"
	l2.speaker = "Sacha"
	l2.text = "...Ouais, bon. Désolé. C'est pas vraiment toi, le problème."
	l2.sets_flags = [&"sacha/relation/calme"]

	var l3 := DialogueLine.new()
	l3.line_id = &"tension"
	l3.speaker = "Sacha"
	l3.text = "Tant mieux, parce que je n'ai rien à dire."
	l3.sets_flags = [&"sacha/relation/tendu"]

	var dlg := DialogueData.new()
	dlg.id = &"sacha_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2, l3]
	_save_dlg(dlg)


func gen_rudric() -> void:
	var c := CharacterData.new()
	c.id = &"rudric"
	c.character_name = "Rudric"
	c.age = 38
	c.personality = "pense que tuer les personnes affectées par les glitches les empêche de souffrir ; étonnamment drôle"
	c.placeholder_color = Color(0.55, 0.15, 0.15, 1.0)
	c.max_health = 50.0
	c.can_die = true
	_save_char(c)

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Rudric"
	l1.text = "Tu sais ce qui est marrant ? Les gens me trouvent effrayant, mais je suis probablement la personne la plus honnête que tu croiseras ici."
	l1.sets_flags = [&"event/rudric_met"]
	l1.auto_next_line_id = &"suite"

	var l2 := DialogueLine.new()
	l2.line_id = &"suite"
	l2.speaker = "Rudric"
	l2.text = "Quand quelqu'un est trop touché par... tout ça, les symptômes s'arrêtent, une fois que c'est fini pour de bon. J'appelle ça de la pitié. Les autres appellent ça autre chose."

	var dlg := DialogueData.new()
	dlg.id = &"rudric_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2]
	_save_dlg(dlg)


func gen_gaspard() -> void:
	var c := CharacterData.new()
	c.id = &"gaspard"
	c.character_name = "Gaspard"
	c.age = 52
	c.personality = "solitaire ; a cru être l'Anomalie autrefois, et s'est trompé"
	c.placeholder_color = Color(0.45, 0.4, 0.35, 1.0)
	c.max_health = 40.0
	c.can_die = true
	_save_char(c)

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Gaspard"
	l1.text = "On ne vient pas jusqu'ici par hasard. Je vis seul, et ça me va très bien comme ça — la plupart du temps."
	l1.sets_flags = [&"event/gaspard_met"]
	l1.auto_next_line_id = &"suite"

	var l2 := DialogueLine.new()
	l2.line_id = &"suite"
	l2.speaker = "Gaspard"
	l2.text = "J'ai cru, il y a longtemps, que j'étais quelque chose d'important. Une erreur du monde. Je me suis trompé. Fais attention à ne pas commettre la même erreur — dans un sens ou dans l'autre."

	var dlg := DialogueData.new()
	dlg.id = &"gaspard_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2]
	_save_dlg(dlg)


func gen_aelia() -> void:
	var c := CharacterData.new()
	c.id = &"aelia"
	c.character_name = "Aelia"
	c.age = 400
	c.personality = "drôle, extrêmement puissante, solitaire, profondément marquée ; vénère l'Anomalie"
	c.placeholder_color = Color(0.75, 0.85, 0.95, 1.0)
	c.max_health = 200.0
	c.can_die = false
	_save_char(c)

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Aelia"
	l1.text = "...Enfin. Je savais que quelque chose comme toi finirait par franchir ce seuil. Quatre cents ans que j'attends, et te voilà, sans même savoir ce que tu es."
	l1.sets_flags = [&"event/aelia_met"]
	l1.auto_next_line_id = &"avertissement"

	var l2 := DialogueLine.new()
	l2.line_id = &"avertissement"
	l2.speaker = "Aelia"
	l2.text = "Ne t'inquiète pas. Je ne laisserai personne te faire de mal ici. Personne. C'est une promesse — et je tiens toujours mes promesses."
	l2.sets_flags = [&"event/aelia_devotion_revealed"]

	var dlg := DialogueData.new()
	dlg.id = &"aelia_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2]
	_save_dlg(dlg)


func gen_elena() -> void:
	var c := CharacterData.new()
	c.id = &"elena"
	c.character_name = "Eléna"
	c.age = 0 # indéterminé
	c.personality = "opportuniste, difficile à cerner, parfois manipulatrice ; connaît déjà l'Anomalie sans le révéler"
	c.placeholder_color = Color(0.6, 0.1, 0.35, 1.0)
	c.max_health = 50.0
	c.can_die = true
	_save_char(c)

	var choice_connais := DialogueChoice.new()
	choice_connais.text = "On se connaît ?"
	choice_connais.target_line_id = &"esquive"
	var choice_rien := DialogueChoice.new()
	choice_rien.text = "(Ne rien dire.)"
	choice_rien.target_line_id = &"silence"

	var l1 := DialogueLine.new()
	l1.line_id = &"intro"
	l1.speaker = "Eléna"
	l1.text = "Tiens donc. Toujours en train de te chercher, à ce que je vois."
	l1.sets_flags = [&"event/elena_met"]
	l1.choices = [choice_connais, choice_rien]

	var l2 := DialogueLine.new()
	l2.line_id = &"esquive"
	l2.speaker = "Eléna"
	l2.text = "Disons que j'ai une bonne mémoire pour les visages. Même ceux qui changent. Ne te fais pas d'idées, ce n'est pas de l'amitié."

	var l3 := DialogueLine.new()
	l3.line_id = &"silence"
	l3.speaker = "Eléna"
	l3.text = "Sage réflexe. Garde-le."

	var dlg := DialogueData.new()
	dlg.id = &"elena_intro"
	dlg.start_line_id = &"intro"
	dlg.lines = [l1, l2, l3]
	_save_dlg(dlg)


func gen_combat_content() -> void:
	var heavy := WeaponData.new()
	heavy.id = &"lame_longue_du_sillon"
	heavy.display_name = "Lame Longue du Sillon"
	heavy.category = WeaponData.Category.HEAVY
	heavy.damage = 22.0
	heavy.attack_speed = 0.7
	heavy.stamina_cost = 28.0
	heavy.range = 2.6
	heavy.poise_damage = 18.0
	heavy.can_be_parried = true
	heavy.placeholder_color = Color(0.5, 0.5, 0.55, 1.0)
	heavy.description = "Une lame lourde à deux mains. Lente, mais elle brise la stabilité en quelques coups."
	ResourceSaver.save(heavy, "res://combat/Weapons/lame_longue_du_sillon.tres")

	var ranged := WeaponData.new()
	ranged.id = &"arc_des_echos"
	ranged.display_name = "Arc des Échos"
	ranged.category = WeaponData.Category.RANGED
	ranged.damage = 14.0
	ranged.attack_speed = 1.1
	ranged.stamina_cost = 16.0
	ranged.range = 9.0
	ranged.poise_damage = 8.0
	ranged.can_be_parried = false
	ranged.placeholder_color = Color(0.6, 0.45, 0.25, 1.0)
	ranged.description = "Un arc ancien. Prototype : résolution instantanée (hit-scan), sans flèche physique animée pour l'instant."
	ResourceSaver.save(ranged, "res://combat/Weapons/arc_des_echos.tres")

	var peur_muette := TraumaData.new()
	peur_muette.id = &"peur_muette"
	peur_muette.display_name = "La Peur Muette"
	peur_muette.symbolism = "Une silhouette qui recule sans cesse mais qui frappe dès qu'on s'approche trop vite — la peur qu'on tente de fuir finit par se retourner contre soi."
	peur_muette.max_health = 55.0
	peur_muette.max_stability = 40.0
	peur_muette.move_speed = 3.2
	peur_muette.attack_damage = 9.0
	peur_muette.attack_range = 2.2
	peur_muette.detection_range = 9.0
	peur_muette.behavior = TraumaData.Behavior.SKITTISH
	peur_muette.weaknesses = [&"peur"]
	peur_muette.placeholder_color = Color(0.55, 0.2, 0.35, 1.0)
	ResourceSaver.save(peur_muette, "res://combat/Traumas/peur_muette.tres")

	var poids_silence := TraumaData.new()
	poids_silence.id = &"poids_du_silence"
	poids_silence.display_name = "Le Poids du Silence"
	poids_silence.symbolism = "Une masse immobile qui ne bouge pas tant qu'on ne l'approche pas — jusqu'à ce qu'il soit trop tard pour reculer."
	poids_silence.max_health = 80.0
	poids_silence.max_stability = 60.0
	poids_silence.move_speed = 2.2
	poids_silence.attack_damage = 14.0
	poids_silence.attack_range = 2.4
	poids_silence.detection_range = 12.0
	poids_silence.behavior = TraumaData.Behavior.SENTINEL
	poids_silence.weaknesses = []
	poids_silence.placeholder_color = Color(0.25, 0.25, 0.3, 1.0)
	ResourceSaver.save(poids_silence, "res://combat/Traumas/poids_du_silence.tres")


func gen_maelle() -> void:
	var char_data := CharacterData.new()
	char_data.id = &"maelle"
	char_data.character_name = "Maëlle"
	char_data.age = 19
	char_data.personality = "joyeuse, calme, curieuse, spontanée"
	char_data.schedule = [
		{"hour": 6, "location": "Foret_Aube - clairière", "activity": "cherche le fragment"},
		{"hour": 19, "location": "Foret_Aube - lisière", "activity": "rentre vers le village"},
	]
	char_data.dialogue_tree_path = "res://narrative/Dialogue/content/dialogue_maelle_premiere_rencontre.tres"
	char_data.quest_ids = [&"aider_le_chevalier"]
	char_data.placeholder_color = Color(0.85, 0.55, 0.75, 1.0)
	char_data.max_health = 25.0
	char_data.can_die = true
	ResourceSaver.save(char_data, "res://narrative/Characters/maelle.tres")

	var keyword := KeywordData.new()
	keyword.id = &"curiosite"
	keyword.display_name = "Curiosité"
	keyword.concept = "Ce qui pousse à comprendre plutôt qu'à fuir."
	keyword.description = "Un mot appris auprès de Maëlle. Rend certains dialogues et certaines faiblesses accessibles."
	keyword.damage_multiplier_vs_tag = 1.3
	keyword.vs_trauma_tag = &"peur"
	keyword.dialogue_tag = &"curiosite"
	ResourceSaver.save(keyword, "res://combat/Keywords/curiosite.tres")

	var quest := QuestData.new()
	quest.id = &"aider_le_chevalier"
	quest.title = "Aider le chevalier"
	quest.summary = "Maëlle veut présenter l'Anomalie à Victor, le chevalier du village, après la réaction étrange du fragment."
	quest.giver_character_id = &"maelle"
	quest.available_from_day = 1
	quest.available_until_day = 3
	quest.available_from_hour = 0
	quest.available_until_hour = 24
	ResourceSaver.save(quest, "res://narrative/Quests/aider_le_chevalier.tres")

	var choice_explique := DialogueChoice.new()
	choice_explique.text = "Un éclat de lumière ?"
	choice_explique.target_line_id = &"explique_fragment"

	var choice_pas_vu := DialogueChoice.new()
	choice_pas_vu.text = "Je viens d'arriver, désolé."
	choice_pas_vu.target_line_id = &"pas_vu"

	var line_intro := DialogueLine.new()
	line_intro.line_id = &"intro"
	line_intro.speaker = "Maëlle"
	line_intro.text = "Oh ! Je ne m'attendais pas à croiser quelqu'un ici... Tu n'as pas vu un éclat de lumière tomber par ici ? Je le cherche depuis ce matin."
	line_intro.sets_flags = [&"event/maelle_met"]
	line_intro.choices = [choice_explique, choice_pas_vu]

	var line_explique := DialogueLine.new()
	line_explique.line_id = &"explique_fragment"
	line_explique.speaker = "Maëlle"
	line_explique.text = "Oui ! Un fragment magique, il réagit à... enfin, à des choses particulières. C'est pour mon apprentissage. Attends... tu dégages quelque chose d'étrange."
	line_explique.auto_next_line_id = &"reaction_fragment"

	var line_pas_vu := DialogueLine.new()
	line_pas_vu.line_id = &"pas_vu"
	line_pas_vu.speaker = "Maëlle"
	line_pas_vu.text = "Pas grave, je vais continuer à chercher. Au fait, moi c'est Maëlle !"
	line_pas_vu.auto_next_line_id = &"reaction_fragment"

	var line_reaction := DialogueLine.new()
	line_reaction.line_id = &"reaction_fragment"
	line_reaction.speaker = "Maëlle"
	line_reaction.text = "(Le fragment dans sa poche se met à vibrer et à scintiller faiblement.) ...Tu as vu ça ?"
	line_reaction.triggers_glitch = true
	line_reaction.grants_item_id = &"fragment_de_maelle"
	line_reaction.sets_flags = [&"event/fragment_reacts"]
	line_reaction.auto_next_line_id = &"propose_village"

	var choice_accepte := DialogueChoice.new()
	choice_accepte.text = "D'accord, allons-y."
	choice_accepte.sets_flags = [&"quest/aider_le_chevalier/accepted"]
	choice_accepte.starts_quest_id = &"aider_le_chevalier"
	choice_accepte.target_line_id = &"accepte"

	var choice_refuse := DialogueChoice.new()
	choice_refuse.text = "Je préfère explorer un peu par ici d'abord."
	choice_refuse.target_line_id = &"refuse"

	var choice_curiosite := DialogueChoice.new()
	choice_curiosite.text = "Qu'est-ce que tu crains exactement ?"
	choice_curiosite.target_line_id = &"curiosite"

	var line_propose := DialogueLine.new()
	line_propose.line_id = &"propose_village"
	line_propose.speaker = "Maëlle"
	line_propose.text = "Je ne sais pas ce que c'est, mais je n'aime pas ça. Il y a un chevalier au village, Victor, il pourrait nous aider à comprendre. Tu viens avec moi ?"
	line_propose.choices = [choice_accepte, choice_refuse, choice_curiosite]

	var line_accepte := DialogueLine.new()
	line_accepte.line_id = &"accepte"
	line_accepte.speaker = "Maëlle"
	line_accepte.text = "Parfait, suis-moi quand tu veux, je ne suis pas loin."

	var line_refuse := DialogueLine.new()
	line_refuse.line_id = &"refuse"
	line_refuse.speaker = "Maëlle"
	line_refuse.text = "Comme tu veux ! Je resterai dans le coin un moment."

	var choice_accepte2 := DialogueChoice.new()
	choice_accepte2.text = "D'accord, allons-y."
	choice_accepte2.sets_flags = [&"quest/aider_le_chevalier/accepted"]
	choice_accepte2.starts_quest_id = &"aider_le_chevalier"
	choice_accepte2.target_line_id = &"accepte"

	var choice_refuse2 := DialogueChoice.new()
	choice_refuse2.text = "Pas tout de suite."
	choice_refuse2.target_line_id = &"refuse"

	var line_curiosite := DialogueLine.new()
	line_curiosite.line_id = &"curiosite"
	line_curiosite.speaker = "Maëlle"
	line_curiosite.text = "Je crains de ne jamais savoir. Comprendre vaut mieux que fuir, tu ne crois pas ?"
	line_curiosite.grants_keyword_id = &"curiosite"
	line_curiosite.auto_next_line_id = &"propose_village_2"

	var line_propose2 := DialogueLine.new()
	line_propose2.line_id = &"propose_village_2"
	line_propose2.speaker = "Maëlle"
	line_propose2.text = "Bref. Tu viens au village avec moi ?"
	line_propose2.choices = [choice_accepte2, choice_refuse2]

	var dlg := DialogueData.new()
	dlg.id = &"dialogue_maelle_premiere_rencontre"
	dlg.start_line_id = &"intro"
	dlg.lines = [line_intro, line_explique, line_pas_vu, line_reaction, line_propose, line_accepte, line_refuse, line_curiosite, line_propose2]
	ResourceSaver.save(dlg, "res://narrative/Dialogue/content/dialogue_maelle_premiere_rencontre.tres")
