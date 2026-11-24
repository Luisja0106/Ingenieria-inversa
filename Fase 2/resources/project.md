# What's the Project about?

The project is a maze where an 'agent' has to navigate through a grid-based which we will called board enviroment to reach the goal.

the board have wall box, free box start box, and goal box. The agent can't move through a wall box, but can move through free box. The agent can perfomrm bi-derectional movement, meaning it can move up, down, left, and right.

The system must have diferents types of search algorithms to find the best path to reach the goal (all the search algorithms must respect the same contract). For now the system will have this two algorithms:

- Wide First Search (BFS)
- Depth First Search (DFS)

The user can choose which algorithm want to use to find the best path to reach the goal.

Also the system must have a visual representation of the board, the agent, and the path found by the algorithm. The user can see how the agent reach the goal, using a GUI where the user can see the board, a couple of buttons like "Resolve" to start the search "Stop" to stop the search, and a "Reset" button to reset the board to its initial state, a couple of radio buttons to select the search algorithm. The GUI should also display some info for the result, like if it found the solution, the stepts that he took to found the solution (right, left, up, down), the cost (how many box take the algorithm to reach the goal), the goal position in the grid board (ex 7, 15)how many time it took, and how many nodes it generated, how many it visited, and how many are pending or not visited. the GUI info must be in spanish.

The system have a default board, but the user can create a custom board in the GUI, this is not mandatory to be persisted. The user can also modify the default board, clicking the boxes to change his state or type (wall, free, start, goal). The user can also reset the board to its default state.
