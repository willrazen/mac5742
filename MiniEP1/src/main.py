from random import Random


def pi(seed: int, runs: int) -> float:
    """Estimates pi through monte carlo"""
    
    rng = Random(seed)
    hits = 0
    
    for i in range(runs):
        x, y = rng.random(), rng.random()
        if x*x + y*y <= 1.0:
            hits += 1
    
    return 4*hits/runs


if __name__ == '__main__':
    print(pi(2022, 10**7))
