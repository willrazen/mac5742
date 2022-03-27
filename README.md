# MAC0219/5742 - Programação Concorrente e Paralela (2022)

## EP1

*Problema:* Calcular pi através do método de Monte Carlo em duas linguagens de programação, utilizando pseudo-código fornecido.

*Abordagem:*
- Ambiente escolhido foi Amazon EC2 t2.micro (free tier), com Amazon Linux 2, pela reprodutibilidade e isolamento
- Linguagens escolhidas foram Go 1.15.14 e CPython 3.7.10 (versões são padrão do ambiente)
- Código elaborado com apenas standard lib de cada linguagem e seguindo pseudo-código, para uma comparação justa e idiomática
- Código em Go foi compilado de antemão, já em Python foi executado com interpretador
- Mensuração realizada pelo [Hyperfine](https://github.com/sharkdp/hyperfine), ferramenta própria para benchmarking, trazendo maior confiança nos dados gerados
- Execução de cada programa por pelo menos 5 minutos

*Resultados (tempos em ms):*
| Language | Runs | Min  | Max  | Median | Mean ± Stddev |
|----------|------|------|------|--------|---------------|
| Go       | 2000 | 156  | 263  | 158    | 160 ± 5       |
| CPython  | 100  | 3593 | 4713 | 3649   | 3673 ± 118    |
Conforme o esperado, Go é ~23 vezes mais rápido.

*Fig 1.* Histograma para Go
[go_hist.png](EP1/out/go_hist.png)

*Fig 2.* Progressão para Go
[go_prog.png](EP1/out/go_prog.png)

*Fig 3.* Histograma para CPython
[py_hist.png](EP1/out/py_hist.png)

*Fig 4.* Progressão para CPython
[py_prog.png](EP1/out/py_prog.png)
