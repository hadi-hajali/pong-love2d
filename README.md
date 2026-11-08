# Pong — LÖVE2D

**Name:** Hadi Haj Ali

## Description
A two-player Pong game built with Lua and LÖVE2D. Players move their paddles to hit the ball. The ball bounces off the top and bottom walls and both paddles. Each player earns a point when the opponent misses. Movement uses delta time, and paddle collisions use AABB rectangle overlap detection.

## How to Run
Install LÖVE2D from https://love2d.org/.
Open a terminal in the project folder and run:

    love .

On Windows, you can also drag the project folder onto love.exe.

## Controls
- W / S: Move the left paddle.
- Up / Down arrows: Move the right paddle.
- Space: Serve the ball.
- R: Reset the game and scores.
- Escape: Quit.

## My Own Change
I added Space-to-serve: the ball waits in the center until Space is pressed, including after each point. I also added a scoreboard, different paddle colors, and an R key to reset the game.


