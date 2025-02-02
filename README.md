# Tower of Power

## Overview
**Tower of Power** is a simple game built using an AT89C52 microcontroller, two 8x8 LED matrices, and a single button. The objective is to align a continuously moving bar with a randomly spawning bar to gain points. The game features a scoring system and health bars, with animations indicating success (smiley face) or failure (sad face).

## Features
- Two 8x8 LED matrix displays
- Single-button input for timing-based gameplay
- Scoring system with increasing difficulty
- Visual feedback through animations
- Assembly language implementation for efficient control

## How It Works
1. A bar continuously moves up and down on the right LED matrix.
2. A second bar appears randomly on the left LED matrix.
3. The player presses the button to align both bars.
4. If aligned correctly, the player gains a point, and a smiley face appears.
5. If not, the player loses a health bar, and a sad face appears.
6. The game ends when all health bars are depleted.

## Hardware Requirements
- **Microcontroller:** AT89C52
- **Displays:** Two 8x8 LED matrices
- **Input Device:** Single button
- **Other Components:** Resistors, wires, and a development board (Prechin)

## Software
- The game logic is implemented in **Assembly Language**.
- The system uses **MCU 8051 IDE** for simulation and development.

## Circuit Diagram
Refer to the image below for wiring and port connections:

[Screenshot 2024-06-01 000249](https://github.com/user-attachments/assets/c31ed6db-4500-480f-8630-126adea3d1bb)

## Installation and Usage
1. Flash the provided Assembly code onto the AT89C52 microcontroller.
2. Assemble the circuit as per the diagram.
3. Power up the system and start playing.

## Contributors
- **Rodulph Jake L. Cabaobao**
- **Mohammad Naim D. Mariga**
- **Edgar Jr B. Villas**

## License
This project is open-source. Feel free to modify and improve!

---
For any inquiries or improvements, open an issue or submit a pull request on GitHub!

