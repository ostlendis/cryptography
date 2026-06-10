# Hard Problems
In a nutshell, hard problems are tasks that are easy to do/compute one way, but very difficult or infeasible to reverse. This is useful if we want to use a cryptographic scheme between two persons and it is very hard for an attacker to attack this scheme because the scheme encompasses a hard problem.
Computational problems are problems that can be solved with a program or algorithm such as sorting an array, factoring a number or finding the best route from point A to B.

There are multiple types of hard problems:
## Descision Problem
Some problems can be formulated as a yes-no question, for example "is the number 42 prime?" and some problems cannot be answered (Halting-problem).
## Functional Problem
A functional problem is a problem where the answer is a function of a given input and not a simple yes/no answer. Examples are the travelling salesman problem where the answer is the path or a factorisation problem where the answer is a list of factors.
## Optimisation/Approximation Problem
Optimisation/Approximation problems are problems where we want to find the best solution or at least an approximation. Examples are finding a timetable, maximum of a given function and machine learning.
## Running time
We want to measure running time of an algorithm to estimate how many operation it takes to calculate something. For example, a nested for-loop is of running time $O(n^2)$ where n is the input size in bits.
### Solvable problem?
If a computational problem is solvable depends on its runtime:
- $O(n)$ is feasaible to compute
- $O(2^n)$ is practially impossible to compute
- $O(n²)$ is in between
#### Polynomial Time
Problems that can be solved in polynomial time are considered "efficient" in cryptography and can be solved in a reasonable time. It would have a runtime of $O(n^k)$ for some $k$. Examples are sorting a list, multiplying numbers or database searches.
#### Super-Polynomial Time
Problems where adding few bits to the input (like key size) makes computing the solution take much longer than the heat death of the universe are in super-polynomial time. It would have a runtime that grows faster than any polynomial like $O(2^n)$. In cryptography, these problems are deemed "inefficient". Examples, as of now, are number factoring, time tables and solving sudokus.
## Complexity classes
### Time P
complexity class time P includes all problems that can be solved in $O(n^k)$ for all constant k