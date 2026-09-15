# Équilibrage — état actuel

Ce document consolide les valeurs de tuning actuellement réparties dans les
ressources `.tres` et les scripts, avec le raisonnement derrière chaque choix.
Sans playtest réel possible dans cet environnement, c'est une passe de
cohérence interne (les rapports entre valeurs) plutôt qu'un calibrage final —
à ajuster une fois le jeu réellement joué.

## Bug corrigé pendant cette passe

`TimeManager.REAL_SECONDS_PER_IN_GAME_MINUTE` valait `0.625`, ce qui donnait
**15 minutes réelles par jour** au lieu des **45 minutes** spécifiées par le
GDD (§3, « chaque journée correspond à environ 45 minutes »). Corrigé à
`1.875` (`45 min × 60 / 1440 min-jeu`), ce qui redonne une boucle de 3 jours
≈ 2h15 comme documenté.

## Armes (joueur)

| Arme | Catégorie | Dégâts | Cadence | Stamina | Portée | Poise | Parable |
|---|---|--:|--:|--:|--:|--:|:--:|
| Dague des Écarts | Rapide | 9 | 2.2/s | 12 | 1.6 | 6 | oui |
| Lame Longue du Sillon | Lourde | 22 | 0.7/s | 28 | 2.6 | 18 | oui |
| Arc des Échos | Distance | 14 | 1.1/s | 16 | 9.0 | 8 | non |

DPS résultant : Dague ≈ **19.8**, Lame ≈ **15.4**, Arc ≈ **15.4**. La dague
gagne en DPS brut mais expose le joueur (courte portée, faible poise/coup) ;
la lame sacrifie la cadence pour casser la stabilité vite (meilleur poise/s
après la dague) ; l'arc offre la même DPS que la lourde à distance de
sécurité, sans possibilité de parade en retour (cohérent avec « le parry est
réservé aux attaques suffisamment puissantes »).

## Traumatismes

| Trauma | PV | Stabilité | Dégâts | Portée att. | Détection | Comportement |
|---|--:|--:|--:|--:|--:|---|
| La Peur Muette | 55 | 40 | 9 | 2.2 | 9.0 | Skittish |
| Le Poids du Silence | 80 | 60 | 14 | 2.4 | 12.0 | Sentinel |

Temps pour tuer (joueur seul, sans esquive) : Peur Muette ≈ 2.8–3.6 s selon
l'arme ; Poids du Silence ≈ 4–5.7 s. Temps pour casser leur stabilité (le
vrai objectif du Synapse-Lien) : Peur Muette ≈ 3–4.5 s ; Poids du Silence ≈
4.5–6.8 s — toujours plus rapide que de viser les PV, ce qui récompense le
joueur qui joue la mécanique de stabilité plutôt que la course aux dégâts.

Dégâts subis par le joueur (100 PV / 50 stabilité), à raison d'une attaque
toutes les 1.6 s si le joueur ne réagit pas : Peur Muette ≈ 32 s avant la
mort, ≈ 17.6 s avant la rupture de stabilité ; Poids du Silence ≈ 11.4 s
avant la mort, ≈ 11.4 s avant la rupture — délibérément punitif si on
l'aborde sans prudence, cohérent avec sa symbolique (« jusqu'à ce qu'il soit
trop tard pour reculer »).

## Boucle / dégradation

- 1 jour = 45 min réelles, boucle de 3 jours ≈ 2h15 (corrigé ci-dessus).
- `RealityManager.CRITICAL_DEGRADATION_LEVEL = 5` : avec +1 par mort de PNJ
  (`ConsequenceManager`), il faut la mort de la moitié du casting secondaire
  environ pour atteindre la fin « Trop tard » — assez de marge pour que la
  dégradation reste une conséquence réelle des actions du joueur plutôt
  qu'un minuteur caché.
- `SynapseLink.ANTICIPATION_THRESHOLD = 3` : un Trauma « comprend » une
  habitude d'esquive après 3 répétitions dans la même direction — assez tôt
  pour être perceptible en un seul combat, sans punir la première esquive.

## Connu comme non finalisé

Ces valeurs n'ont pas pu être testées en conditions réelles de jeu (pas de
build interactif jouable dans cet environnement) : elles sont cohérentes
entre elles sur le papier, mais un vrai passage manette-en-main reste
nécessaire avant un réglage final, en particulier pour la difficulté
ressentie des Traumatismes et la régénération de stamina/stabilité.
