# linux_system_usage_graph
리눅스 환경에서 RAM, CPU 사용량을 그래프로 나타냅니다.

1.CPU 사용량 그래프
--------------------
* sar 명령어로 CPU 사용량을 수집합니다.

![CPU 사용량 그래프](https://github.com/westporch/linux_system_usage_graph/blob/master/Screenshots/CPU_usage_graph.png)

2.메모리 사용량 그래프
----------------------
> **데이터 계산 방법**
> __/proc/meminfo__의 값으로 메모리 사용량을 수집합니다.
>
> **MemFree_mb** = MemFree/1024
> **Active_mb** = (Active_anon + Active_file)/1024
> **Cached_mb** = Cached/1024


![메모리 사용량 그래프](https://github.com/westporch/linux_system_usage_graph/blob/master/Screenshots/Memory_usage_graph.png)
