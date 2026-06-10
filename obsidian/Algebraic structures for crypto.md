# Groups
A group is a set of elements with an operation. For example, if we have a set $G$ and an operation $*$, they make a group $(G, *)$ together. For a group to be valid, it must satisfy these three axioms:

1. **Associativity** — For all $a, b, c \in G$: $(a * b) * c = a * (b * c)$
2. **Neutral element** — For any $a \in G$, there exists $e$: $a * e = a = e * a$
3. **Inverse element** — For any $a \in G$ there exists $\hat{a}$: $a * \hat{a} = e = \hat{a} * a$

## Group Order

The **group order** $\text{ord}(G)$ is the size of a group $G$, for example: $\text{ord}(\mathbb{Z}_m) = m$

The **order of an element** $a$ in group $G$, written $\text{ord}(a)$, is the smallest $k$ such that $a^k = e$.

A **generator** $g$ has order $\text{ord}(G)$ and every element $a \in G$ can be written as $g^k$ for some $k$.

**Example:** $G = \mathbb{Z}_{15}^*$

- $\text{ord}(G) = \varphi(15) = 4 \cdot 2 = 8$
- For $x \in G$: $\text{ord}(x) \in {1, 2, 4, 8}$
- $\text{ord}(4) = 2$ as $4 \cdot 4 = 1$

# Rings

A **ring** $(R, +, *)$ is a set $R$ with _two_ operations that satisfies:

1. $(R, +)$ is an **abelian group** — addition works as you expect, with commutativity
2. $(R, *)$ is a **monoid** — multiplication is associative and has a neutral element (1), but elements do **not** need inverses under multiplication
3. **Distributive law** — For all $a, b, c \in R$: $a * (b + c) = a_b + a_c$
4. _(Optional)_ **Commutativity** — For any $a, b \in R$: $a * b = b * a$

**Intuition:** A ring is like a group, but with two operations instead of one. The key weakening compared to a field (see below) is that not every element needs a multiplicative inverse. Division is _not_ always possible.

**Examples of rings:**

- $(\mathbb{Z}_n, +, \cdot)$ — integers mod $n$
- $(\mathbb{Z}, +, \cdot)$ — all integers
- $\mathbb{Z}[x]$ — polynomials with integer coefficients

# Fields

A **field** $(\mathbb{F}, +, *)$ is a _commutative ring_ where every non-zero element has a multiplicative inverse.

- This means $(\mathbb{F} \setminus {0}, *)$ is itself a group.
- A field = a ring where you can also always divide (except by zero).

**Examples of fields:**

- $(\mathbb{Q}, +, \cdot)$ — rationals
- $(\mathbb{R}, +, \cdot)$ — reals
- $(\mathbb{C}, +, \cdot)$ — complex numbers

## Finite Fields

A **finite field** is a field with finitely many elements. There are only two types:

- $GF(p) = \mathbb{Z}_p = \mathbb{F}_p$ for **prime** $p$ (order $p$)
- $GF(p^k)$ for prime $p$ and integer $k$ (order $p^k$)

> **Why must $p$ be prime?** If $n = p \cdot q$ is composite, then neither $p$ nor $q$ is zero, but $p \cdot q = 0 \pmod{n}$. These are called _zero divisors_, and their existence prevents multiplicative inverses from existing for all elements — breaking the field property.

# Extension Fields

**Idea:** Start with a field $\mathbb{F}$ and build a larger one that contains $\mathbb{F}$ as a subset.

**Classic example — $\mathbb{C}$ as extension of $\mathbb{R}$:**

- Define a new element $i$ such that $i^2 + 1 = 0$ (no real solution exists)
- $\mathbb{C} = {a + bi \mid a, b \in \mathbb{R}}$ — extension of degree 2

**For finite fields:** $GF(p^k)$ is built as an extension over $\mathbb{Z}_p$.

# Polynomial Rings

$\mathbb{F}[x]$ — the set of all polynomials over $\mathbb{F}$ — forms a ring.

- **Example polynomial:** $x^4 + x + 1$ over $\mathbb{Z}_2$, written as $(1, 0, 0, 1, 1)$ or `10011`
- **Addition:** component-wise using $\mathbb{F}$'s addition (XOR for $\mathbb{Z}_2$)
    - $(x + 1) + x = 2x + 1 = 1$ over $\mathbb{Z}_2$ (since $2 = 0$)
- **Multiplication:** standard polynomial multiplication, then reduce coefficients mod $p$

**Example over $\mathbb{Z}_2$:**

$(x^2 + x + 1) \cdot (x^2 + 1) = x^4 + x^3 + 2x^2 + x + 1 = x^4 + x^3 + x + 1$

(the $2x^2$ term vanishes since $2 = 0$ in $\mathbb{Z}_2$)

## Polynomial Rings Modulo $m(x)$

$\mathbb{F}[x]/m(x)$ — polynomials of degree $< \deg(m)$, also a ring.

- **Addition:** same as before
- **Multiplication:** multiply, then reduce modulo $m(x)$ (like modular arithmetic, but for polynomials)

**Example** in $\mathbb{Z}_2[x]/(x^3 + x + 1)$:

$(x^2 + x + 1) \cdot (x^2 + 1) = x^4 + x^3 + x + 1$

Now reduce mod $x^3 + x + 1$: divide $x^4 + x^3 + x + 1$ by $m(x)$, giving remainder $x^2 + x$.

## Irreducible Polynomials and Fields

When $m(x)$ is **irreducible** (cannot be factored into lower-degree polynomials over $\mathbb{F}$), then $\mathbb{F}[x]/m(x)$ is actually a **field**, not just a ring.

**The AES field:** $GF(2^8) = \mathbb{Z}_2[x]/m(x)$ where $m(x) = x^8 + x^4 + x^3 + x + 1$

This is the field used in AES encryption — elements are bytes (8 bits), and multiplication is performed modulo this irreducible polynomial.
# Summary

|Structure|Operations|Key Property|Examples|
|---|---|---|---|
|**Group**|One $(*)$|Associativity, identity, inverses|$(\mathbb{Z}_n, +)$, $(\mathbb{Z}_n^*, \cdot)$|
|**Ring**|Two $(+, *)$|Group under $+$, monoid under $*$|$(\mathbb{Z}_n, +, \cdot)$, $\mathbb{Z}[x]$|
|**Field**|Two $(+, *)$|Ring + multiplicative inverses for all $\neq 0$|$\mathbb{Z}_p$, $\mathbb{Q}$, $\mathbb{R}$, $GF(2^8)$|