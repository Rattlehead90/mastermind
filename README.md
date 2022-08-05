# mastermind
My own implementation of TOP project. A classic mastermind game with a computer. What a RIDE!

# Gist
The game is simple and centered around cracking the sequence of colors. My implementation includes 2 modes: crack the code in 12 turns or make the computer crack... your code. It is possible to choose any length of the sequence. If you sequence has the right color on a right spot, you get a 'B' feedback (meaning Bull, a.k.a. Bull's eye). If you've got the color right but in a wrong place, you get a 'C' for Cow. 'X' for a miss.

# Approach
The assignment was centered around OOP principles, so the game is summoned by a one-liner that activates the whole process spanning 3 classes: Player (for strictly human things), Sequence (either set the sequence or let it solve itself by knowing when it's Bull's eye) and Game (initialize the right mode and orchestrate the playing loop). It's possible to make the game repeatable but I've decided for a one-play implementation as it's much easier on the eye.

# What have I learned
Jesus Christ have I learned a lot. Mainly in fields of OOP, debugging a complex class structure, proofreading and sanitizing user's input and much, much more. It is redundant to use keywords here. 
