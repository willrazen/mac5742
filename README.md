# MAC5742 - Programação Concorrente e Paralela (2022)

Para melhor visualização e acessar todos os arquivos, visite https://github.com/willrazen/mac5742 


## Índice
- [Mini EP1](#mini-ep1)
- [Mini EP2](#mini-ep2)


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
- Através de profiling com ferramentas nativas `go test -bench` e `go tool pprof`, foi identificado que ~72% do tempo foi gasto com a geração de números aleatórios (ver [call-graph](https://raw.githubusercontent.com/willrazen/mac5742/main/miniep2/out/20220404051435/cpu_graph.svg) e [flame-graph](http://htmlpreview.github.io/?https://github.com/willrazen/mac5742/blob/main/miniep2/out/20220404051435/cpu_flame.html))
- O módulo nativo `math/rand` já é especialmente [rápido](https://github.com/lukechampine/frand#benchmarks) para 1 thread, porém [outros algoritmos](https://qqq.ninja/blog/post/fast-threadsafe-randomness-in-go/) podem ser ainda mais rápidos
- Utilizando [github.com/vpxyz/xorshift](https://github.com/vpxyz/xorshift) foi possível [reduzir ~61%](miniep2/out/20220404051435/stats.txt) do tempo de processamento
  - Para discussão sobre o algoritmo ver [aqui](https://prng.di.unimi.it/)
- Outras otimizações implementadas com pequenos ganhos (~2%) foram:
  - Unroll de iterações
  - Compilação com static-linking
- No algoritmo vencedor foram combinados [splitmix.go](miniep2/pi/splitmix.go) e [unroll4.go](miniep2/pi/unroll4.go)
- Foram testados e não trouxeram ganhos:
  - Remoção de boilerplate e inlining manuais da `math/rand.Float64()`
  - Compilação e otimização com gccgo (~3x mais devagar, ver [discussão](https://meltware.com/2019/01/16/gccgo-benchmarks-2019.html))

*Gráficos:*
| Histogram                                     | Progression                             |
|-----------------------------------------------|-----------------------------------------|
| ![](miniep2/out/20220404051435/best_hist.png) | ![](miniep2/out/20220404051435/best_prog.png) |


## Mini EP3


## Mini EP4

*Problema:* Em uma linguagem da sua escolha, escreva um código que faça false 
sharing e descubra o tamanho de bloco do seu cache.

*Algoritmo implementado:*
- Go: [miniep4/fs/counters.go](miniep4/fs/counters.go)

*Resultados:*
- *Gráfico*
- *Análise do gráfico*
- Vamos que temos alta variância nas medidas, possivelmente causada por 
estarmos rodando num sistema bare metal com muitos outros processos rodando ao 
mesmo tempo
- Para efeito de comparação, a lib [sys/cpu](https://github.com/golang/sys/blob/master/cpu/cpu.go) 
fornece um padding **CacheLinePad**, cujo tamanho é hardcoded por arquitetura
- Para amd64 o cpu.CacheLinePad padrão é de 64 bytes, porém vemos no teste que 
o tamanho real é menor

*Abordagem:*
- Precisamos de uma máquina bare metal, pois a instância t3.micro que estávamos 
utilizando nos EPs anteriores é virtualizada e não apresentou efeitos de cache
- Utilizaremos um processador Intel i7 com 2.5 GHz, 4 cores (8 hyperthreads), 
e L1 de 32KB
- Código baseado em [False Sharing — An example with Go](https://dariodip.medium.com/false-sharing-an-example-with-go-bc7e90594f3f), por Dario Di Pasquale
- Criamos um tipo com dois uint64 e um método que incrementa esses uints
- O increment de cada variável é atômico, implementado pela lib sync/atomic
- Criamos um segundo tipo baseado no primeiro, porém que possui arrays de bytes 
para padding
- Para detectar false sharing, criamos uma função **ParrallelInc** que cria
múltiplas coroutines e executa os incrementos em múltiplas repetições
- Medimos e comparamos o tempo de execução de cada versão (com e sem padding) 
enquanto variamos o tamanho dos arrays de padding, para detectar quando acontece
uma descontinuidade, que marca o ponto em que o caching começa a fazer efeito
pois o padding excedeu o blocksize
- Nos testes utilizamos 4 coroutines, 100k increments, padding entre 1 e 
137 bytes e 100 runs por padding


## Mini EP5

*Problema*: Experimentar com thread contentions no caso de competição para 
entrar em seção crítica, com o [código](miniep5/src) em C fornecido, e
empregar técnicas para reduzir o problema.

1. Faça testes variando o tamanho do vetor, a quantidade de threads e a 
quantidade de ifs encadeados, mostrando medias e intervalos de confiança dos 
tempos impressos na saída.

*Resultados:*
*Abordagem:*

2. Dê um parecer do que você observou nos testes do item anterior. Porque você 
acha que ocorreu o observado?

*Resultados:*
*Abordagem:*

3. Explique porque não podemos eliminar o if de dentro da seção crítica quando adicionamos o if de fora.

*Resultados:*
*Abordagem:*


## Mini EP6

*Problema:* Aproveitar o cache para otimizar [código](miniep6/src) fornecido de multiplicação de matrizes.

**Sem blocagem**
1. Mostre, com embasamento estatístico, a variação de tempo entre matrix_dgemm_1 
e sua implementação de matrix_dgemm_0. Houve melhora no tempo de execução? 
Explique porque.

*Resultados:*
*Abordagem:*

**Com blocagem**
2. Mostre, com embasamento estatístico, a variação de tempo entre matrix_dgemm_2 
e sua implementação de matrix_dgemm_1. Houve melhora no tempo de execução? 
Explique porque.

*Resultados:*
*Abordagem:*

3. Como você usou a blocagem para melhorar a velocidade da multiplicação de 
matrizes?

*Abordagem:*


## Mini EP7


## EP1


## DeepSpeed & ZeRO

https://pitch.com/public/6eb2013a-ee70-4792-a912-cb43e0ca196b
