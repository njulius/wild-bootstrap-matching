# Documentation

1. `dgpFun()` and `genData()`

Both of these functions generate fake data for simulation purposes. The difference between them is in the construction of the outcome variable, `Yi`. `dgpFun()` is the correct process in terms of matching the assumptions laid out in Abadie & Imbens (2008). `genData()` is retained for the purposes of keeping my ego under control.

In terms of use, both functions take 3 inputs - `numObs`, `treatRatio`, and `trueTau`, which respectively represent the number of observations to generate, the desired ratio between treated and untreated units, and the true underlying value of the treatment effect. Both functions return the dataset.

2. `findMatches()`

`findMatches()` produces a matching matrix for a given dataset. It takes as input an `N x 3` matrix, whose columns are (respectively) the covariate value, the treatment indicator (`0` or `1` only), and the outcome value. It outputs a spare logical matrix of dimensions `N0 x N1`, where `N0` is the number of untreated (control) units and `N1` is the number of treated units. An example matrix would look something like this:

|  | T1 | T2 | T3 |
|--|----|----|----|
|C1|    |TRUE|    |
|C2|TRUE|    |TRUE|
|C3|    |    |    |

This matrix indicates that the closest control unit to T2 is C1, and that C2 is the closest match to both T1 and T3.

3. `getATE()`

`getATE()` returns the estimated treatment effect on the treated, using nearest-neighbor matching, for a given dataset. It takes as input an `N x 3` matrix, whose columns are (respectively) the covariate value, the treatment indicator (`0` or `1` only), and the outcome value. It returns a scalar.

4. `naiveBootstrap()`

`naiveBootstrap()` takes, as should be expected by this point, an `N x 3` matrix as input, subject to the same column restrictions as everywhere else, and returns a new `N x 3` matrix constructed by sampling rows from the input matrix with replacement. The new matrix will have the same treatment ratio as the input matrix.

5. `wildBootstrap()`

`wildBootstrap()` again takes an `N x 3` matrix with the same column restrictions as input. It returns a new `N x 3` matrix, again with the treatment ratio unchanged. The difference is that this function constructs the new matrix by changing the outcome values in each row according to a rule. Among other things, this means that the matching matrix is unchanged - `findMatches(Z)` and `findMatches(wildBootstrap(Z))` *should* return the same matching matrix.
