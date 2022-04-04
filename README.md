# MAC5742 - Programação Concorrente e Paralela (2022)

Para melhor visualização e acessar todos os arquivos, visite https://github.com/willrazen/mac5742 


## Índice
[Mini EP1](#mini-ep1)
[Mini EP2](#mini-ep2)


## Mini EP1

*Problema:* Calcular pi através do método de Monte Carlo em duas linguagens de programação, utilizando pseudo-código fornecido.

*Algoritmos implementados:*
- Go: [miniep1/src/main.go](miniep1/src/main.go)
- CPython: [miniep1/src/main.py](miniep1/src/main.py)

*Resultados:*
| Language | Runs | Mean ± Stddev [ms] | Min [ms] | Median [ms] | Max [ms]      |
|----------|------|--------------------|----------|-------------|---------------|
| Go       | 3000 | 114 ± 8            | 109      | 112         | 321           |
| CPython  | 100  | 2892 ± 52          | 2843     | 2879        | 3188          |

- Conforme o esperado, Go é ~25 vezes mais rápido
- Tempo de execução de cada programa foi de aproximadamente 5 minutos
- Outliers não foram removidos das estatísticas, porém nota-se oportunidades (ver gráficos no fim deste readme)
- Todos os data points e gráficos estão disponíveis em json [aqui](miniep1/out/20220328033810) 

*Abordagem:*
- Ambiente escolhido foi Amazon EC2 t3.micro, com Amazon Linux 2, pela reprodutibilidade, isolamento e baixo custo (USD ~0.01/h)
- Mais informações sobre o ambiente podem ser encontradas [aqui](env_info.txt)
- Linguagens escolhidas foram Go 1.15.14 e CPython 3.7.10 (versões padrão do ambiente)
- Código elaborado com apenas standard lib de cada linguagem e seguindo pseudo-código, para uma comparação justa e idiomática
    - Também foi testada versão em CPython com gerador aleatório do Numpy, porém foi desconsiderada pela lentidão
- Mensuração de tempo realizada pelo [Hyperfine](https://github.com/sharkdp/hyperfine), ferramenta própria para benchmarking, trazendo maior confiança nos dados gerados
- Código em Go foi compilado de antemão, já em Python foi executado com interpretador (ver [aqui](miniep1/run.sh))

*Gráficos:*
| Language | Histogram                               | Progression                             |
|----------|-----------------------------------------|-----------------------------------------|
| Go       | ![](miniep1/out/20220328033810/go_hist.png) | ![](miniep1/out/20220328033810/go_prog.png) |
| CPython  | ![](miniep1/out/20220328033810/py_hist.png) | ![](miniep1/out/20220328033810/py_prog.png) |


## Mini EP2

*Problema:* Aprimorar abordagem elaborada no Mini EP1 para a linguagem mais rápida (no caso Go), mantendo a essência do algoritmo (monte carlo) e sem paralelizar.

*Algoritmos implementados:*
- Melhor performance: [miniep2/pi/best.go](miniep2/pi/best.go)
- Outros testes disponíveis em [miniep2/pi](miniep2/pi)

*Resultados:*
| Runs | Mean ± Stddev [ms] | Min [ms] | Median [ms] | Max [ms]      |
|------|--------------------|----------|-------------|---------------|
| 1000 | 44 ± 1             | 43       | 44          | 52            |

*Abordagem:*
- Através de profiling com ferramentas nativas `go test -bench` e `go tool pprof`, foi identificado que ~72% do tempo foi gasto com a geração de números aleatórios (ver [call-graph](miniep2/out/20220404051435/cpu_graph.svg) e [flame-graph](miniep2/out/20220404051435/cpu_flame.html))
- O módulo nativo `math/rand` já é especialmente [rápido](https://github.com/lukechampine/frand#benchmarks) para 1 thread, porém [outros algoritmos](https://qqq.ninja/blog/post/fast-threadsafe-randomness-in-go/) podem ser ainda mais rápidos
- Utilizando `github.com/vpxyz/xorshift` foi possível [reduzir ~61%](miniep2/out/20220404051435/stats.txt) do tempo de processamento
  - Para discussão sobre o algoritmo ver [aqui](https://prng.di.unimi.it/))
- Outras otimizações implementadas com pequenos ganhos (~2%) foram:
  - Unroll de iterações
  - Compilação com static-linking
- No algoritmo vencedor foram combinados [splitmix.go](miniep2/pi/splitmix.go) e [unroll4.go](miniep2/pi/unroll4.go)
- Foram testados e não trouxeram ganhos:
  - Remoção de boilerplate e inlining da `math/rand.Float64()`
  - Compilação e otimização com [gccgo](https://meltware.com/2019/01/16/gccgo-benchmarks-2019.html) (~3x mais devagar)

*Gráficos:*
| Histogram                                     | Progression                             |
|-----------------------------------------------|-----------------------------------------|
| ![](miniep2/out/20220404051435/best_hist.png) | ![](miniep2/out/20220404051435/best_prog.png) |
