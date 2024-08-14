This is the repo for the COMPSYS 305 Mini-project, group 19
Flappy Bird Replica on Altera Cyclone V FPGA
Project Overview
This project is a replica of the classic Flappy Bird game, implemented on an Altera Cyclone V FPGA device embedded into a DE0-CV development board. The game utilizes a PS2 Mouse for control and a VGA (Video Graphics Array) interface for display, with a resolution of 640x480 pixels. The objective is to navigate a bird through a series of obstacles while collecting powerups to gain extra lives. This project was a collaborative effort, and it received a grade of 98.33%.

Table of Contents
Introduction
Hardware Specifications
Game Objective
Features Implemented
Custom Pixel Graphics
Powerup and Lives Logic
Basic Text Display
Peripherals
Team Contributions
Project Results
Getting Started
Conclusion
Introduction
This project aims to replicate the popular Flappy Bird game on an FPGA platform, specifically using the Altera Cyclone V FPGA and DE0-CV development board. The game demonstrates the use of various hardware interfaces, including VGA for display and PS2 for input, along with custom logic implemented in Verilog to handle graphics, game mechanics, and user interactions.

Hardware Specifications
FPGA Device: Altera Cyclone V
Development Board: DE0-CV
Display Interface: VGA (Video Graphics Array) with 640x480 pixel resolution
Input Device: PS2 Mouse
Game Objective
The objective of the game is to control a bird, moving it up and down to navigate through obstacles (pipes) while trying to collect powerups that provide extra lives. The game continues until the player collides with an obstacle or the bird's lives run out.

Features Implemented
Custom Pixel Graphics
Custom pixel graphics were implemented by converting PNG images into RGB values. These values were then stored in Memory Initialization Files (.MIF) that were used to render the game’s sprites and backgrounds. This allowed for the creation of visually appealing and unique game elements.

Powerup and Lives Logic
The game includes a powerup system that provides the player with extra lives. The logic for powerups and lives was implemented by deleting 32 pixels from the bird's sprite each time the collision counter increased, effectively reducing the bird's lives. This adds an extra layer of strategy to the game, as players must balance collecting powerups with avoiding obstacles.

Basic Text Display
Basic text display was implemented to show the player’s score, lives remaining, and other in-game messages. This was crucial for providing feedback to the player and enhancing the overall user experience.

Peripherals
PS2 Mouse: Used for controlling the bird's movement.
VGA Interface: Used for displaying the game on a monitor with a resolution of 640x480 pixels.
Team Contributions
Sai Kiran N Kamat: Implemented custom pixel graphics, powerup and lives logic, and basic text display. Converted PNG images to RGB values and stored them in MIF files.
Teammate 1: Handled collision detection logic.
Teammate 2: Managed the implementation of text handling and other game mechanics.
Project Results
The project was evaluated based on functionality, design, and innovation. The team received a score of 98.33% for the overall project. The high grade reflects the successful implementation of the game’s mechanics, the quality of the graphics, and the seamless integration of the different hardware components.

Getting Started
To run the Flappy Bird Replica on the DE0-CV board, follow these steps:

Set up the Hardware: Connect the DE0-CV board to a monitor via the VGA port and a PS2 mouse to the PS2 interface.
Load the FPGA: Program the FPGA with the provided Verilog files and ensure that the MIF files are correctly loaded for sprite rendering.
Power On: Once everything is connected and programmed, power on the board to start the game.
Play the Game: Use the PS2 mouse to control the bird and navigate through the obstacles.
Conclusion
This project successfully replicated the Flappy Bird game on an FPGA platform, demonstrating the capability of the Altera Cyclone V FPGA in handling custom graphics, game logic, and peripheral integration. The high grade received for the project reflects the effectiveness of the team’s collaboration and the quality of the final product.
Block Diagram:
![image](https://github.com/user-attachments/assets/f628a0a5-8de8-4681-9e70-6879feb54716)

Class Diagram:
![Blank_diagram](https://github.com/user-attachments/assets/c977c4c0-8211-4319-b654-c5dce9a233a4)

Main Menu:
![IMG_1314](https://github.com/user-attachments/assets/90f9f027-e562-4156-aea1-41ade03aea27)

Game:
![IMG_1315](https://github.com/user-attachments/assets/97e92e9c-506b-4f02-a97c-387d32ec5f01)

Game Over:
![IMG_1317](https://github.com/user-attachments/assets/98e643aa-05d8-4cdc-921e-ad30bcf72761)
