# Niwa

## Questions
- Recharging flower box at the well feels kinda weird
- How do we communicate that flower has been watered?
  - Wet ground below flower that dries up?

- _Pre-lose_ state?
- How about that wilted flowers stay wilted and hinder the players strength to fight plevel?
  - Maybe slow them down?
  - Maybe the plevel grows stronger? -> Takes more hits to destroy?
- Does destroying plevel give something to the player?
  - Maybe gives them a sazenička? -> Yes, to bedýnka
  - Maybe gives them a speed boost
- How many flowers can the player spawn?

## TODO
- Z key is not accessible for QWERTZ
- Game progression
  - Initial, only sazeničky
  - Konev comes into action
  - First plevel spawns
  - Motyka is revealed
  - The full garden is available
  - More and more plevel spawns
  - When the plevel overwhelms the garden it transforms into a colored garden
- Zooming out camera
  - Based on progression
- Player
  - Animation
- Items
  - [ ] 🐛 Dropping/swapping items messes with the collision shape of flower box. WTF?!
  - [x] Let the player drop an item anywhere
  - Flower sazeničky bedýnka
    - [x] Holds up to 4 sazaničky
    - Spawns one of _n_ plants at a time
  - Konev
    - [x] Has to be refilled at the well
    - [x] Has only _n_ charges
    - Enables the player to water the plants
  - Motyka
    - [x] Removes plevel after a ~~duration~~ `growth_stages.size()` hits
      - ~~Maybe a mini-game? 😂~~
    - [x] Enables the player to remove plevel
- Flower
  - [x] Spawn a growing plant object
  - Has to be watered
  - After watering, it grows
  - Track how many watering charges have been dispatched to the flower
  - On spawn, pick from a set of growth stages at random
  - [x] Also has a wilted stage
    - [x] Despawn -> fade out and destroy
    - [x] Activates when the plevel reaches its final growth stage
- Plevel
  - [x] Spawns ?randomly?
    - Likely nearby flowers
  - [x] Can be removed by the player
    - ~~After a timeout aka. _holding_ the motyka activated~~
  - [x] Has three stages
  - [x] When it grows to the final stage it wilts the overlapping flowers
  - [x] 🐛 Destroying plevel skips the first growth stage
  - [x] 🐛 Plevel doesn't wilt the plant
  - [ ] 🐛 Plevel seems to wilt too many plants, not just those that it overlaps
- [ ] Lantern boundaries
  - [ ] Do not let the player go outside the screen/camera boundary
- ?Meditation
  - Calls zalévací cloud
- [x] Audio
  - [x] Looping
- Overwatering a plant spawns more plevel 😈
- [x] Disallow planting overlapping flowers
- [x] Player movement
- [x] Item swapping


### Item
- The player can hold only a single item at a time
- The items are swapped

- Keep active item as a variable?
- How about reparenting the item?
- And maybe both
- Detect collision with the item

- We have three items, each gives the player a different ability
- 
