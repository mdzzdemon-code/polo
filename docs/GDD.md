# Le Paradoxe de l'Écho — Game Design Document

Ce document verrouille l'état actuel du GDD. Il sert de référence unique pour le
scénario, les personnages, le monde et les systèmes de jeu. Les décisions ici
sont considérées comme stables ; toute évolution majeure doit être répercutée
dans ce fichier.

## Feuille de route de production

```
1. Projet Godot        →  8. Temps / 3 jours     → 15. Ennemis / Traumatismes → 22. Sauvegarde
2. Architecture         →  9. Boucles              → 16. Quêtes                 → 23. Audio / VFX
3. Personnage            → 10. Mémoire              → 17. Conséquences           → 24. Équilibrage
4. Première map          → 11. Inventaire           → 18. Dégradation            → 25. Build final
5. Interaction            → 12. Mots-clés
6. Dialogue                 → 13. Combat
7. PNJ                       → 14. Synapse-Lien
                                                    → 19. Monde complet
                                                    → 20. Histoire
                                                    → 21. Fins
```

---

## 1. Identité de l'Anomalie

L'Anomalie :

- connaît parfaitement le monde au début ;
- ne connaît pas son véritable passé ;
- sait dès le départ qu'elle est une Anomalie ;
- possède des souvenirs artificiellement fournis par la réalité ;
- ces souvenirs sont en réalité faux ;
- son véritable passé n'est révélé que très tard ;
- son apparence est volontairement difficile à identifier ;
- son visage est presque toujours dissimulé ou impossible à distinguer clairement ;
- sa voix peut être altérée par les glitches ;
- peut oublier : des personnes, des connaissances, des relations, ses pouvoirs,
  comment utiliser certains objets, certains mots, des éléments de son propre passé ;
- peut volontairement sacrifier une mémoire sans savoir exactement laquelle ;
- peut récupérer une mémoire en retrouvant sa véritable source.

**Une mémoire n'est pas simplement une information.** Elle a une valeur émotionnelle,
narrative et mécanique. C'est une partie extrêmement importante du jeu.

## 2. Les deux carnets

### Carnet de l'Anomalie

Évolue avec les souvenirs. Il peut :

- contenir des informations fausses ou des erreurs ;
- devenir incomplet ou illisible ;
- remplacer une information par une autre ;
- perdre certaines informations ;
- refléter l'état mental actuel de l'Anomalie.

Le joueur devra parfois comprendre : *« Ce que mon carnet me dit n'est peut-être
plus vrai. »*

### Carnet du Jeu / de la Réalité

Disponible dès le début mais quasiment vide. Après une fin, il commence à se
remplir : boucles, personnages, événements, mécaniques découvertes, informations
oubliées, indices sur certaines fins, anomalies précédemment rencontrées.

Il donne des indices, **jamais directement la solution**. Cela permet au jeu de
devenir plus profond lors des parties suivantes sans donner de soluce au joueur.

## 3. Temps

- Une boucle = 3 jours.
- Chaque journée ≈ 45 minutes de temps de jeu effectif.
- Une boucle complète ≈ 2h15, selon le rythme du joueur.
- Jouer les trois jours intégralement n'est pas obligatoire : certaines actions
  provoquent une transition ou une fin prématurée.

Le monde fonctionne en **temps continu** : les PNJ ont des routines, des
déplacements, des horaires, des événements dépendant de l'heure. Certains
événements sont impossibles à voir si le joueur arrive trop tard, mais une autre
boucle permet généralement de les rencontrer à nouveau.

Pas d'horloge omniprésente. Elle peut être visible dans certains endroits, via
certains objets, dans certaines interfaces — et peut parfois glitcher.

## 4. La jeune femme (Maëlle)

Elle possède une zone précise dans laquelle elle se trouve selon l'heure. Le
joueur peut la rencontrer naturellement, arriver trop tôt ou trop tard, la
suivre, l'ignorer, découvrir ce qu'elle faisait avant de la rencontrer.

**Le joueur n'est jamais obligé de la suivre** — il peut immédiatement partir
explorer le monde. Cela évite le « Bonjour joueur, voici ta quête principale,
suis-moi. »

## 5. Ouverture

Le jeu commence dans la forêt, pas dans le village. La forêt est belle,
lumineuse, vivante, normale, agréable. Puis apparaissent progressivement de
petits éléments incohérents — pas de jumpscare, pas de grosse horreur :

- un son qui se répète ;
- quelque chose qui n'est plus exactement au même endroit ;
- une petite incohérence ;
- un élément qui semble avoir changé ;
- une géométrie étrange ;
- un détail que le joueur peut prendre pour une erreur.

Puis la jeune femme apparaît avec le fragment. Elle le cherche pour son
apprentissage. Le fragment reconnaît l'Anomalie, attire les glitches, n'est pas
immédiatement dangereux, peut être volé, est lié aux anciennes civilisations —
il n'est pas présenté comme « l'artefact légendaire ultime ».

## 6. Dialogue

Système volontairement simple : peu de choix, mais chaque choix important
compte. Pas de choix A/B/C/D creux toutes les deux minutes. Les choix
apparaissent principalement lorsqu'ils peuvent réellement modifier une
relation, une information, une quête, une conséquence, un souvenir, un
événement, éventuellement une fin.

Les mots-clés sont présents dans le dialogue mais pas de manière trop
explicite ; le joueur comprend progressivement leur importance.

## 7. PNJ secondaires

Ils ne sont pas là uniquement pour remplir la carte. Le monde doit donner
l'impression que les habitants avaient une vie avant l'arrivée du joueur.
Certains peuvent avoir des routines, discuter entre eux, disparaître
temporairement, être impliqués dans des événements, mourir, changer selon les
actions du joueur. Cela renforce l'idée que les boucles concernent un monde
réel, pas une carte remplie de distributeurs de quêtes.

## 8. Inventaire

Volontairement simple (armes, objets, fragments, objets de quête, éléments
liés aux souvenirs, éventuellement objets temporaires). **Les objets ne sont
pas nécessairement conservés entre les boucles** — ce sont principalement les
souvenirs de l'Anomalie qui persistent. Cela évite le problème du joueur qui
recommence une boucle avec tout son équipement et devient progressivement
surpuissant.

## 9. Fragments de mémoire

Vraie ressource narrative : récupérer une information, comprendre un
personnage, retrouver une capacité, comprendre un mot, retrouver une relation,
comprendre une ancienne situation. Jamais un simple « +10 XP ». Pas de farming.

## 10. Mots-clés

Maximum : **3 mots-clés équipés**. Proviennent notamment des dialogues.
Peuvent influencer les combats, certaines interactions, certaines quêtes,
certains Traumatismes, certaines situations particulières. Pas de simples bonus
statistiques — un mot peut avoir une signification conceptuelle, importante
pour l'identité du jeu.

## 11. Combat

Combat en temps réel, troisième personne, pas de tour par tour.

Trois grands styles :

- **Armes rapides** — courte portée, rapides, mobilité.
- **Armes lourdes / longues** — grande portée, attaques lentes, puissance élevée.
- **Armes à distance** — précision, positionnement, gestion des ouvertures.

Dans chaque catégorie, beaucoup d'armes différentes visuellement et
statistiquement (pas juste Épée +1 / +2 / +3).

## 12. Défense

Le joueur peut esquiver. Le parry/counter est réservé aux attaques
suffisamment puissantes, pour éviter le spam parry → gagner. Le timing reste
important.

## 13. Lock-on

Système de lock-on non obligatoire en permanence : combat rapproché précis,
gestion des ennemis rapides, attaques ciblées — mais exploration et certaines
situations restent entièrement libres.

## 14. Friendly fire

Conséquences liées aux attaques : les combats peuvent devenir dangereux
lorsque plusieurs personnes sont présentes. Le joueur doit faire attention à
son placement, ses attaques, les PNJ autour, les capacités utilisées.

## 15. Traumatismes

Les ennemis sont les manifestations physiques des Traumatismes — pas une armée
infinie. Peu d'ennemis différents, mais très travaillés. Chaque Trauma a une
identité, un comportement, une mécanique, une symbolique, des faiblesses,
éventuellement un rapport avec les glitches. Leur apparition dépend de l'état
du monde, d'un événement, d'une zone, de la dégradation, des actions du
joueur — pas d'apparition arbitraire.

## 16. Adaptation des ennemis

Les ennemis apprennent les habitudes du joueur à l'intérieur des boucles.

```
attaque → esquive gauche → réussite
                ↓ (répétition)
attaque → esquive gauche → le Trauma anticipe → contre
```

Plus le joueur répète certaines habitudes, plus certaines réactions peuvent
être anticipées rapidement. Intérêt mécanique réel donné aux boucles.

## 17. Synapse-Lien

Système psychologique/tactique reliant l'Anomalie aux Traumatismes. Interagit
avec les mots-clés, les points de stabilité, certaines attaques, certaines
faiblesses, la compréhension du Trauma. Objectif : le joueur peut gagner parce
qu'il **comprend** l'ennemi plutôt que simplement parce qu'il a de meilleures
statistiques.

## 18. Quêtes

Peuvent être ratées, devenir indisponibles, apparaître à certaines heures,
dépendre d'autres personnages, avoir plusieurs solutions (parfois non
évidentes), être résolues sans combat dans certains cas. Le jeu ne dit pas
forcément au joueur qu'il vient de rater quelque chose, pour préserver la
sensation « le monde continue sans moi ». À la fin d'une boucle, le joueur
peut consulter les quêtes précédemment découvertes.

## 19. Dégradation du monde

N'arrive pas immédiatement. Le monde doit d'abord être beau et heureux : le
joueur doit avoir le temps de s'attacher au village, aux personnages, aux
paysages, aux petites habitudes, aux musiques, aux moments humoristiques. Puis
progressivement, quelque chose ne va plus. La dégradation est liée aux
événements et aux actions du joueur — pas « Jour 2 = tout devient sombre
parce que le scénario le veut » : elle doit avoir une causalité.

## 20. Narration

Progressive. Pas d'exposition frontale (« Il y a 5000 ans, les Anciens... »).
Le joueur découvre les informations par les personnages, les lieux, les
objets, les souvenirs, les glitches, les dialogues, les ruines, les
comportements, les incohérences. Certaines informations peuvent sembler
contradictoires avant que le joueur comprenne pourquoi.

## 21. Révélation de la boucle

Le problème n'est pas uniquement que le monde est coincé dans une boucle : le
problème est l'existence même de l'Anomalie. Tant que l'Anomalie existe,
quelque chose empêche la réalité de revenir à un état cohérent, et la boucle
continue. Cela donne énormément de poids au sacrifice final.

## 22. Fin véritable

L'Anomalie sauve les habitants, sauve la réalité, arrête les boucles, accepte
de disparaître. Puis personne ne se souvient réellement de qui elle était.
Elle regarde une dernière fois le monde qu'elle a sauvé, sourit, puis
disparaît — et le monde continue. Certaines personnes ressentent une
impression, une habitude inexplicable, un souvenir sans image, une émotion
qu'elles ne comprennent pas. Pas de « Merci, joueur ! », pas de quatrième mur.

## 23. Technique

- Godot, 3D
- PC en priorité, Windows
- Objectif ~60 FPS
- Qualité graphique suffisamment élevée pour distinguer clairement objets et
  personnages, sans recherche du photoréalisme
- Optimisation pensée dès l'architecture

---

# Personnages principaux

| Nom     | Rôle                        | Importance |
|---------|------------------------------|:----------:|
| Maëlle  | Jeune mage — personnage de départ | ★★★★★ |
| Tom     | Enfant                       | ★★★★★ |
| Romain  | Gouverneur                   | ★★★★☆ |
| Victor  | Chevalier                    | ★★★★☆ |
| Eléna   | Femme mystérieuse            | ★★★★★ |
| Luc     | Ancien voleur                | ★★★★★ |
| Sacha   | Adolescent                   | ★★★☆☆ |
| Rudric  | Personne aux idées tordues   | ★★★★☆ |
| Gaspard | Homme solitaire              | ★★★★☆ |
| Aelia   | Gardienne du temple          | ★★★★★ |

### Maëlle — jeune mage (personnage de départ)

Âge ~18–20 ans, apprentie mage / aventurière, joyeuse, calme, curieuse,
spontanée. Probablement le premier personnage important rencontré. Explore la
forêt pour retrouver un fragment magique nécessaire à son apprentissage —
**elle n'est pas à la recherche de l'Anomalie**, elle tombe simplement dessus.
Le fragment réagit en présence de l'Anomalie et provoque des phénomènes
étranges. Elle propose d'amener l'Anomalie au village pour aider le chevalier,
mais le joueur peut accepter, refuser, l'ignorer, partir ailleurs, revenir plus
tard. Ne doit jamais donner l'impression d'être une « PNJ tutoriel ».
Chaleureuse et amusante au début, elle devient progressivement l'un des
personnages permettant de comprendre que les événements dépassent les simples
glitches. Fait partie des trois personnages auxquels le joueur doit le plus
s'attacher.

### Tom — l'enfant

Garçon, ~6–8 ans, extrêmement joyeux, innocent, curieux. Vit au village avec
ses parents, sans frère ni sœur ; ses parents le laissent circuler librement
car le village est considéré sûr. Pose des questions parfois naïves mais
étonnamment profondes, touchant directement à la philosophie du jeu.
Représente ce que le monde était avant que le joueur comprenne qu'il est
brisé — présence particulièrement importante émotionnellement. Peut faire des
erreurs, être influencé, être impliqué dans des événements, provoquer
involontairement des conséquences graves, **et mourir** : aucune protection
scénaristique. Sa mort doit être l'une des choses les plus difficiles
émotionnellement du jeu.

### Romain — le gouverneur

Homme, jeune adulte/adulte, gouverneur/noble, véritable autorité politique
mais pas un tyran caricatural. Chaleureux, honorable, presque rassurant au
début — gentil, compétent, protecteur, raisonnable, parfois adorable. Puis
certaines décisions deviennent inquiétantes : il peut être très dur lorsqu'il
pense que c'est nécessaire. **Seul personnage qui sait que la gardienne du
temple existe**, sans la connaître personnellement — il sait seulement
qu'une présence ancienne existe dans la région. Point de jonction potentiel
majeur entre les deux intrigues.

### Victor — le chevalier

Homme, jeune adulte, soldat/protecteur. Sérieux, avec un véritable sens de
l'humour. Appartient à l'armée, pas directement sous les ordres du gouverneur,
mais peut travailler dans la même région. Représente la protection concrète
du peuple ; suit les ordres mais garde son jugement moral — peut désobéir,
protéger quelqu'un, se sacrifier, faire confiance à la mauvaise personne,
mourir de différentes manières. Relation importante avec Luc, l'ancien voleur.

### Eléna — la femme mystérieuse

Femme, âge indéterminé, opportuniste, difficile à cerner, parfois
manipulatrice. Humaine en apparence, extrêmement belle, très difficile à
comprendre : capable de mentir, d'aider, de trahir, d'exploiter une
situation. **Elle connaît déjà l'Anomalie mais ne le révèle pas** — sa
relation avec l'Anomalie est personnelle et porte probablement l'un des
secrets narratifs les plus importants du jeu. Le joueur doit progressivement
se demander : « Depuis combien de temps me connaît-elle réellement ? » Ne
doit pas être simplement « la méchante mystérieuse » — ses motivations
doivent être compréhensibles une fois le joueur suffisamment informé.

### Luc — l'ancien voleur

Homme, autrefois voleur (a dérobé un objet sacré), a eu plusieurs occasions de
changer et a réellement essayé de devenir meilleur ; aide aujourd'hui les
enfants. Les glitches peuvent provoquer une rechute — possibilité extrêmement
importante : certains pourraient alors dire « Il recommence à voler, il faut
le punir » alors que le joueur sait potentiellement que le problème vient des
anomalies. **Tragédie potentielle** : il peut être exécuté pour quelque chose
qu'il n'était plus réellement en train de choisir — quelqu'un qui avait
réussi à devenir meilleur, condamné malgré tout. Lien important avec Victor.

### Sacha — l'adolescent

Garçon, 14–15 ans, en crise familiale et émotionnelle. Hostile envers
l'Anomalie au début : peut provoquer, mentir, prendre de mauvaises décisions,
faire quelque chose de très grave. Peut devenir antagoniste selon les
circonstances, mais n'est pas simplement « méchant » : une partie de son arc
consiste à passer de « Je déteste ce personnage » à « Je comprends pourquoi
il a fait ça ». Facilement manquable — un joueur focalisé sur l'intrigue
principale peut complètement passer à côté de son histoire.

### Rudric — la personne aux idées tordues

Âge/sexe à définir. Pense que tuer les personnes affectées par les glitches
les empêche de souffrir — et son raisonnement n'est pas totalement faux :
lorsqu'une personne fortement affectée est tuée, certains symptômes et
souvenirs disparaissent. Il en conclut : tuer = sauver. Le joueur le déteste
probablement d'abord, puis comprend progressivement pourquoi cette personne
en est arrivée là. Peut devenir antagoniste, provoquer des morts, aider
l'Anomalie, avoir des conversations très étranges, être étonnamment drôle.
Rapport avec l'Anomalie particulièrement important.

### Gaspard — l'homme solitaire

~50 ans, vit volontairement à l'écart. A autrefois pensé être lui-même
l'Anomalie, mais s'est trompé ; avait un compagnon resté au village. Histoire
ambiguë : peut être une source d'informations, un avertissement, un miroir de
l'Anomalie, quelqu'un ayant déjà vécu une partie du même chemin. Ne connaît
pas nécessairement toute la vérité, mais certaines de ses paroles peuvent
prendre un sens complètement différent après plusieurs boucles.

### Aelia — la gardienne du temple

Femme, ~400 ans (apparence ~20 ans), autre peuple humanoïde. Drôle,
extrêmement puissante, solitaire, profondément marquée. Garde le temple
ancien, possède une magie extrêmement puissante, reconnaît immédiatement
quelque chose chez l'Anomalie — et contrairement à la plupart des autres,
**elle la vénère**, la considère comme importante, voire sacrée. Sa dévotion
devient dangereuse : si elle pense que quelqu'un menace ou dérange
l'Anomalie, elle peut tenter de le tuer. Pas mauvaise en soi — le problème est
qu'elle veut protéger l'Anomalie à n'importe quel prix. Peut aussi perdre des
souvenirs à cause des glitches. Elle attend quelqu'un et protège quelque
chose ; ces deux éléments seront liés au lore ancien.

---

# Le monde

## Carte générale

```
                         +-----------------+
                         |    MONTAGNE     |
                         |                 |
                         |     TEMPLE      |
                         +--------+--------+
                                  |
                    +-------------+-------------+
                    |                           |
              +-----+------+             +------+------+
              |   RUINES   |             |     LAC     |
              |  ANCIENNES |             |             |
              +-----+------+             +------+------+
                    |                            |
                    +------------+---------------+
                                 |
                       +---------+---------+
                       |      PLAINES      |
                       +---------+---------+
                                 |
                       +---------+---------+
                       |      VILLAGE      |
                       +---------+---------+
                                 |
                       +---------+---------+
                       |       FORÊT       |
                       |  POINT DE DÉPART  |
                       +-------------------+
```

Ce n'est pas encore la carte technique définitive, mais c'est la structure de
base retenue. Régions (noms internes, dossier `world/Solenne/`) :
`Foret_Aube` (forêt), `Boiselle` (village), `Campi_Lucis` (plaines),
`Lac_Lune` (lac), `Cite_Caelum` (ruines anciennes), `Mont_Cieux` (montagne),
`Sanctuaire_Seuil` (temple).

### La forêt — zone de départ

Volontairement la zone la plus chaleureuse au début : arbres, petites
clairières, ruisseaux, animaux, chemins naturels, végétation dense, quelques
endroits cachés. Doit donner envie de se promener sans quête. Les premiers
glitches apparaissent ici, très subtilement — le joueur doit pouvoir se
demander « Est-ce que j'ai vraiment vu ça ? »

### Le village

Style médiéval français, petite communauté chaleureuse : maisons, place
centrale, commerces, habitants, bâtiments administratifs, zones
résidentielles, éventuellement une petite infrastructure militaire.
Important mais pas le monde entier — le joueur comprend progressivement que
les choses les plus importantes se trouvent ailleurs.

### Les plaines

Grande région ouverte, magnifique au début : herbe, fleurs, animaux, vent,
grands espaces. Zone parfaite pour l'exploration, les déplacements rapides,
les combats, les événements dynamiques. Puis les anomalies modifient certains
éléments : végétation qui change, chemins incohérents, éléments qui
apparaissent, sons ne correspondant pas au paysage, portions de terrain
incohérentes.

### Le lac

Normal en apparence au début, magnifique, sans gros mystère apparent. Bien
plus tard, le joueur comprend son rôle important : l'un des lieux où des
informations sur l'ancienne civilisation deviennent compréhensibles.

### Les ruines anciennes

Vestiges d'une civilisation extrêmement ancienne : ancienne ville détruite,
complexe religieux, vestiges dont la fonction est aujourd'hui incompréhensible.
Pas simplement trois donjons — le joueur doit se demander « Pourquoi ont-ils
construit ça ? », puis « Pourquoi ont-ils disparu ? », puis « Quel était leur
rapport avec l'Anomalie ? »

### La montagne

Domine une partie du monde, sert de repère visuel visible depuis plusieurs
régions (géographie cohérente). Devient progressivement plus importante à
mesure que les vérités anciennes sont découvertes.

### Le temple

Aperçu depuis certaines zones — doit donner l'impression « Ça fait partie du
paysage depuis toujours », pas « Voici le donjon final ! » Lieu ancien où
réside la gardienne (Aelia), lié aux anciennes civilisations, à l'ancienne
magie, à la réalité, à l'Anomalie — sans que le joueur comprenne tout cela
immédiatement.
