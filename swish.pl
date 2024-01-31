% Define the initial and goal state
initialState(state(3, 3, 0, 0)). % Initializes the initial state with 3 missionaries and 3 cannibals on the left bank and none on the right.
goalState(state(0, 0, 3, 3)). % Defines the goal state as having all missionaries and cannibals safely across to the right bank.

% Define what a safe state is
isSafe(state(M, C, MR, CR)) :- % Checks if a state is safe.
    (M >= C ; M = 0), % A state is safe if missionaries are not outnumbered by cannibals on the left bank or there are no missionaries.
    (MR >= CR ; MR = 0). % And also safe if missionaries are not outnumbered on the right bank or there are no missionaries.

% Define possible moves, including return trips
possibleMoves(state(M, C, MR, CR), state(M1, C1, MR1, CR1)) :- % Defines possible moves from one state to another.
    % Possible combinations of M and C to move or return
    (move(1, 0, M, C, MR, CR, M1, C1, MR1, CR1) ; % Move one missionary to the right
     move(2, 0, M, C, MR, CR, M1, C1, MR1, CR1) ; % Move two missionaries to the right
     move(0, 1, M, C, MR, CR, M1, C1, MR1, CR1) ; % Move one cannibal to the right
     move(0, 2, M, C, MR, CR, M1, C1, MR1, CR1) ; % Move two cannibals to the right
     move(1, 1, M, C, MR, CR, M1, C1, MR1, CR1) ; % Move one missionary and one cannibal to the right
     move(-1, 0, M, C, MR, CR, M1, C1, MR1, CR1) ; % Return one missionary to the left
     move(-2, 0, M, C, MR, CR, M1, C1, MR1, CR1) ; % Return two missionaries to the left
     move(0, -1, M, C, MR, CR, M1, C1, MR1, CR1) ; % Return one cannibal to the left
     move(0, -2, M, C, MR, CR, M1, C1, MR1, CR1) ; % Return two cannibals to the left
     move(-1, -1, M, C, MR, CR, M1, C1, MR1, CR1)), % Return one missionary and one cannibal to the left
    isSafe(state(M1, C1, MR1, CR1)). % Ensure the move is safe by checking the resulting state.

% Helper predicate for moving people
move(DM, DC, M, C, MR, CR, M1, C1, MR1, CR1) :- % Defines the logic to update the state based on a move.
    M1 is M - DM, C1 is C - DC, % Calculates the new number of missionaries and cannibals on the left bank.
    MR1 is MR + DM, CR1 is CR + DC, % Calculates the new number on the right bank.
    M1 >= 0, C1 >= 0, MR1 >= 0, CR1 >= 0, % Ensure that the numbers don't go below 0 (valid state).
    M1 =< 3, C1 =< 3, MR1 =< 3, CR1 =< 3. % Ensure that the numbers don't exceed 3 (the total number).

% Search for a solution, ensuring the solution path is accumulated and returned
solve(State, Solution, Visited) :- % Tries to find a solution from the current state to the goal.
    goalState(State), % If the current state is the goal state,
    reverse([State|Visited], Solution). % reverse the visited states to get the solution path.
solve(State, Solution, Visited) :- % If not at the goal state,
    possibleMoves(State, NextState), % find a possible move to a safe state,
    not(member(NextState, Visited)), % that has not been visited yet to avoid cycles,
    solve(NextState, Solution, [State|Visited]). % and continue the search from that new state.

% Find a solution with an empty visited list initially
findSolution(Solution) :- % Wrapper predicate to start the solution search.
    initialState(InitialState), % Get the initial state,
    solve(InitialState, Solution, []). % and solve for the solution starting with an empty visited list.

