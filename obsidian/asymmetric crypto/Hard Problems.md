In a nutshell, hard problems are tasks that are easy to do/compute one way, but very difficult or infeasible to reverse. This is useful if we want to use a cryptographic scheme between two persons and it is very hard for an attacker to attack this scheme because the scheme encompasses a hard problem.
Computational problems are problems that can be solved with a program or algorithm such as sorting an array, factoring a number or finding the best route from point A to B.

There are multiple types of hard problems:
# Descision Problem
Some problems can be formulated as a yes-no question, for example "is the number 42 prime?" and some problems cannot be answered (Halting-problem).
# Functional Problem
A functional problem is a problem where the answer is a function of a given input and not a simple yes/no answer. Examples are the travelling salesman problem where the answer is the path or a factorisation problem where the answer is a list of factors.
# Optimisation/Approximation Problem
Optimisation/Approximation problems are problems where we want to find the best solution or at least an approximation. Examples are finding a timetable, maximum of a given function and machine learning.
# Running time
We want to measure running time of an algorithm to estimate how many operation it takes to calculate something. For example, a nested for-loop is of running time $O(n^2)$ where n is the input size in bits.
## Solvable problem?
If a computational problem is solvable depends on its runtime:
- $O(n)$ is feasaible to compute
- $O(2^n)$ is practially impossible to compute
- $O(n²)$ is in between
### Polynomial Time
Problems that can be solved in polynomial time are considered "efficient" in cryptography and can be solved in a reasonable time. It would have a runtime of $O(n^k)$ for some $k$. Examples are sorting a list, multiplying numbers or database searches.
### Super-Polynomial Time
Problems where adding few bits to the input (like key size) makes computing the solution take much longer than the heat death of the universe are in super-polynomial time. It would have a runtime that grows faster than any polynomial like $O(2^n)$. In cryptography, these problems are deemed "inefficient". Examples, as of now, are number factoring, time tables and solving sudokus.
# Complexity classes
## P
complexity class P includes all problems that can be solved in $O(n^k)$ running time for all constant k. This means that P contains problems that can be solved in polynomial time.
## PSPACE
Complexity calls PSPACE contains all problems that can be solved in $O(n^k)$ memory size. This means that PSPACE contains all problems that can be solved with a polynomial amount of memory.
## NP
Non-deterministic polynomial time includes problems where a solution can be verified efficiently, but finding the solution may still be hard, for example: does there exist $K$ such that $C=AES(K,P)$ for a given $C,P$?
## NP-Completeness
NP-Complete problems include problems that are harder than NP-Problems. If we can find a solution to solve a NP-complete problem, we have solved all NP problems in polynomial time.
# Important hard problems
These problems are used in cryptography
## Factoring
Given a number n, provide a decomposition into prime factors. There is only one solution.
The naïve algorithm(N) is to test for x in 2..sqrt(N) if x is dividable by N. This results in a runtime of $O(n^{n/2})$. While there are algorithms to make it more efficient, the time is still exponential.
Since we assume that factoring is a hard problem, we can build cryptographic schemes:
$N = p*q$ for primes p and q. Our public key is N and our secret is p and q. This scheme is used in RSA
## Discrete Logarithm
Discrete logarithm uses [[Algebraic structures for crypto#Groups|Groups]]. Groups have operations that are closed, meaning that an operation on an element of a group results in that group again.
A generator is an element $g$ in group $G$ where $ord(g)=ord(G)$. This means that every element in the group $G$ can be written as a multiple of $g$.

The problem goes as follows: given a group $G=(\mathbb{Z}_p^*, *)$ and a generator $g$ and an input y, find k such that $g^k=y$ 
As we assume that finding $k$ is a hard problem, we can build cryptographic schemes with it. If we have a generator $g$ we can use $y=g^k$ where y is our public key and k our secret key. This is used in elliptic curve cryptography. It is important to note that you have to use specific large subgroups for $G$ as others may be trivially to solve.