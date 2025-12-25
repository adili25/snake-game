# Snake Game on Intel 8086 Assembly

## Project Overview
This project involves the design and implementation of a fully functional **Snake Game** using **Intel 8086 assembly language**. The game operates in text mode and utilizes BIOS and DOS interrupts for display, keyboard input, and timing management. 

The primary goal is to gain hands-on experience with low-level programming, memory management, and structured program design on the 8086 architecture.

## Functional Requirements
* **Game Environment:** Uses 80x25 text mode (INT 10h).
* **Visual Boundaries:** Play area is surrounded by visible borders using ASCII characters (`|`, `-`, `J`, `L`).
* **Snake Representation:** Head is represented by `@` and the body by `0`.
* **Movement:** Automatic forward movement with steering controlled by user input (`A` for Left, `S` for Right).
* **Growth Mechanic:** Snake grows by one segment and the score increases by 1 for every food block (`*`) eaten.
* **Collision Detection:** Game ends upon collision with walls or the snake's own body.
* **Scoreboard:** Real-time score display in the top-left corner.

## Technical Constraints
* **Segmented Architecture:** Code must strictly use separate **CODE**, **DATA**, and **STACK** segments.
* **No External Libraries:** Only 8086 assembly instructions are permitted.
* **Non-Blocking Input:** Keyboard detection must not interrupt the game loop.

---

## Implementation Roadmap (To-Do List)

### Phase 1: Environment & Architecture
- [ ] Initialize `STACK`, `DATA`, and `CODE` segments.
- [ ] Set video mode to 80x25 text mode via **INT 10h**.
- [ ] Define character constants for snake head (`@`), body (`0`), food (`*`), and borders in the `DATA` segment.

### Phase 2: Rendering & Initialization
- [ ] Implement a procedure to draw the game boundaries.
- [ ] Develop a pseudo-random placement algorithm for food using system timer interrupts.
- [ ] Create a rendering routine to display characters at specific (X, Y) coordinates using **INT 10h**.

### Phase 3: Game Logic & Control
- [ ] Implement the automatic movement loop with a controlled delay for game speed.
- [ ] Write a non-blocking input handler using **INT 16h** to capture `A` and `S` keys.
- [ ] Manage the snake's body coordinates in an array or buffer to handle growth and movement.

### Phase 4: Collisions & Scoring
- [ ] Add collision detection for wall hits and self-overlaps.
- [ ] Implement food collision logic to trigger snake growth and score updates.
- [ ] Design the real-time score display routine for the top-left corner.

### Phase 5: Termination & Reset
- [ ] Create a "GAME OVER" screen with a final score display.
- [ ] Implement the 'R' key restart mechanic to re-initialize the game state.
- [ ] Ensure clean program termination using **INT 21h**.

---

## Important Deadlines
* **Deadline:** Thursday, January 8th, 2026.
* **Presentation:** Successful presentation in front of the professor is required for grading.
