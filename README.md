# ISI信道下的Viterbi接收算法

## ISI信道

- ISI信道抽头延迟线模型
![figure](.\Fig\ISI信道模型.png)
$y_k = \sum^{L-1}_{i=0}{h_ix_{k-i}} + n_k$                    (1)

- 矩阵描述形式
  $$
  \bold{y} = \left\{\begin{matrix}
  y_0\\
  y_1\\
  \vdots\\
  y_{N-1}
   \end{matrix} \right\}
    = \left\{\begin{matrix}
    h_0\\
    h_1 & h_0\\
    \vdots & \ddots &\vdots\\
    h_{L-1} & h_{L-2} & \cdots & h_1 & h_0\\
    \vdots & \ddots &\vdots \\
    & & h_{L-1} & h_{L-2} & \cdots & h_1 & h_0
    \end{matrix} \right\}
    \left\{\begin{matrix}
      x_0\\
      x_1\\
      \vdots\\
      x_{N-1}
     \end{matrix} \right\}
     + \left\{\begin{matrix}
      n_0\\
      n_1\\
      \vdots\\
      n_{N-1}
     \end{matrix} \right\}
     = \bold{H}\bold{x} + \bold{n}       
  $$
  

## 最大似然检测

假设IID高斯噪声

- 似然函数

  $ p(\bold{y|x})= (\frac{1}{\pi\sigma^2})^N\exp(-\frac{||\bold{y-Hx}||}{\sigma^2})$                   (2)

- 最大似然检测准则

  $\bold{x} = argmax\ p(\bold{y/x}) = argmax\ (\frac{1}{\pi\sigma^2})^N\exp(-\frac{||\bold{y-Hx}||}{\sigma^2}) = argmin\ ||\bold{y-Hx}||$         (3)

- (3)式的含义

  最似然的发送码字为：遍历一遍所有可能的码字使得(3)式最小，即为发送端最可能发送的码字

##  Viterbi接收算法思路

- 复杂度的考虑

  直接遍历所有可能的发送端码字，复杂度为$M^N$，其中M为发送端可能发送的码字种类，N为发送端发送的码字长度

- Viterbi接收算法

  Viterbi接收算法充分利用了Trellis网格图的结构，使得解空间从$M^N$降低到$NM^{L+1}$
  $$
  ||\bold{y-Hx}|| = \sum^{N-1}_{k=0}{|y_k - \sum^{L-1}_{i=0}{h_ix_{k-i}}|^2}
  $$
  令D(T)表示第T时刻的累计度量，则
  $$
  D(T+1) = \sum^{T}_{k=0}{|y_k - \sum^{L-1}_{i=0}{h_ix_{k-i}}|^2} \\
  = \sum^{T-1}_{k=0}{|y_k - \sum^{L-1}_{i=0}{h_ix_{k-i}}|^2} + |y_T - \sum^{L-1}_{i=0}{h_ix_{T-i}}|^2 \\
  = D(T) + |y_T - \sum^{L-1}_{i=0}{h_ix_{T-i}}|^2
  $$
  因此想要取得最小的D(N)，可以采用逐时序搜索，从第0时序开始，逐时序计算每个时序的累计度量，直至第N时序，选择D(N)中最小的那个，回溯至0时序即可得到最似然码组

## 例子

​		发射端采用BPSK，则每时刻可能的码字就有两种，即M=2；发射端采用QPSK，则每时刻可能的码字有4中，M=4。

## 代码使用方法

​		运行main.m，可以得到2径ISI信道下BPSK、QPSK误码率的对比

​		运行main1.m，可以得到BPSK下2径ISI信道、3径ISI信道的误码率对比

## 误码率曲线

- 2径ISI信道下BPSK、QPSK误码率的对比

  ![figure](.\Fig\untitled.png)

- BPSK下2径ISI信道、3径ISI信道的误码率对比

  ![figure](.\Fig\untitled1.png)