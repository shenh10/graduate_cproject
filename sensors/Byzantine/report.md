## Byzantine Problem 实验报告

本实验实现了教材11章的算例1, 分别使用了Dolev算法，快速收敛算法(FCA)，传感器融合算法以及混合算法。

重要概念：
Agreement: 所有non-faulty PE都收敛到彼此之间epsilon范围内(即| max(V) - min(V）| < epsilon)
Validity: 迭代过程中的值必须始终在non-faulty PE初始值的范围内
Accuracy: 系统结果与期望结果的距离
Precision: 系统返回结果的范围大小
Accuracy(Mahaney):与被估计的abstract value的距离 
Accuracy(Dolev): 任意两个PE的初始精确值最大距离

要求：
Precision < epsilon
Accuracy < delta

目标是在不损害accuracy的前提下尽可能提升精度的大小, 返回结果的accuracy不能比正确PE的初始值中最差的accuracy还差
Byzantine将军问题中，我们希望最多容忍t个fault PE，则PE总数至少为3t+1,从accuracy角度说，至多有 t个PE返回值超出了delta

Dolev的思路即是，至多有t个低于delta下界，至多有t个高于delta上界，则去头去尾至少有t+1个在delta accuracy范围内,取其子集求平均得到新值。给定任意小的精度范围，该算法都能收敛。

在Inexact agreement的Mahaney算法中，一个重要的概念是acceptable。 一个值是否acceptable取决于它是否在其他N-t个值的delta范围内。此算法也在给定任意小的精度范围都收敛，不过可能造成accuracy的损失。FCA是Mahaney给出的算法之一。

sensor fusion解决的基本问题是：给定N个传感器，所有都有有限的准确度，至多t个传感器是坏的，在多小的一个范围内我们一定可以找到正确值？整个问题和上述Byzantine Generals based 算法不一样，整个不需要定义个具体的Precision(epsilon)要求。每个传感器给定一个upper bound 和lower bound, 这个范围的大小即为accuracy delta。因此我们希望找到个足够小的范围，传感器的估计值才有意义。明显的，这个范围的大小要比任意一个PE的范围小。算法实现通过找到至少由N-t个传感器读数范围的交集，correct range则是这些交集的最宽上下界。


Hybrid 算法结合了FCA 算法和sensor fusion算法，使得提供了最好的Accuracy(由sensor fusion算法带来)
，同时提升了Precision.

该算法适用于三种数据
1.实数值，所有PE有一样的隐含Accuracy; 
2.实数值，有显示accuracy但随着value而改变
3.一个包含上下界的范围

比较几种算法:
1. Approximate agreement 和 Inexact agreement 都强调精度而不考虑accuracy, 使得迭代过程中accuracy还可能下降，所以这个算法更适用于需要所有PE同步的应用中，比如时钟同步——时间绝对值不那么重要，关键是分布式节点要一致。
2. Sensor fusion则只考虑 accuracy, Approximate agreement可以达到任意precison要求，可是inexact agreement 对accuracy的要求使得迭代在某个阶段进行不下去，故无法收敛到任意小的precison。
3. 没有加Byzantine Agreement步骤所需的带宽与processor数成正比， 加上Byzantine O(n**(S+1)), S是Byzantine Agreement迭代次数
4. FCA 和 sensor fusion 都是O(nlgn)时间复杂度


#### 实验结果:
##### Dolev:
收敛条件: 两次迭代值变化小于0.001, 迭代过程的PE值变化如下：

Dolev Algorithm
    2.6000    2.1333    2.4333    2.1333    2.1333

Accuracy: 3.100000, Precesion: 0.466667 
    2.3889    2.2333    2.3556    2.2333    2.2333

Accuracy: 3.100000, Precesion: 0.155556 
    2.3259    2.2741    2.3259    2.2741    2.2741

Accuracy: 3.100000, Precesion: 0.051852 
    2.3086    2.2914    2.3086    2.2914    2.2914

Accuracy: 3.100000, Precesion: 0.017284 
    2.3029    2.2971    2.3029    2.2971    2.2971

Accuracy: 3.100000, Precesion: 0.005761 
    2.3010    2.2990    2.3010    2.2990    2.2990

Accuracy: 3.100000, Precesion: 0.001920 
    2.3003    2.2997    2.3003    2.2997    2.2997

Accuracy: 3.100000, Precesion: 0.000640 

如上所述，Accuracy定义为初始PE值的距离最大值，因此一直为4.7-1.6=3.1。 然而，精度随着迭代过程逐渐减小，最后收敛时（定义的收敛条件为该轮新值与旧值相差不超过0.001，此时精度到了0.00064，迭代次数为6），当把收敛条件进一步加强，到10^(-10)次方时，迭代结果为：

2.3000    2.3000    2.3000    2.3000    2.3000

Accuracy: 3.100000, Precesion: 0.000000 

所有PE最终收敛到了同一个实数值2.3， 此时精度为0, 迭代次数21次。可见Dolev算法可以实现任意精度的一致收敛，且效率较高。


##### FCA
FCA的本质在与如何设定acceptable的阈值，当delta比较大时，迭代两三轮之后便所有值都在acceptable的阈值之内了，从而直接是5个PE值取平均。当设定收敛阈值为0.001, delta为初始值的最大距离时，FCA迭代过程如下:

FCA Algorithm
    2.3500    2.1333    2.2250    2.1333    2.1333

Precesion: 0.216667 
    2.3683    1.9683    2.2683    1.9483    2.2104

Precesion: 0.420000 
    2.3107    1.9107    2.2107    1.8907    2.1383

Precesion: 0.420000 
    2.2645    1.8645    2.1645    1.8445    2.0807
.
.
.
Precesion: 0.420000 
    2.0804    1.6804    1.9804    1.6604    1.8506

Precesion: 0.420000 
    2.0804    1.6804    1.9804    1.6604    1.8504

Precesion: 0.420000 
    2.0803    1.6803    1.9803    1.6603    1.8504

Precesion: 0.420000 

最终所有PE收敛值并不一致！这里有个问题，程序假设所有错误PE在不停广播自己的初始错误值，因此无论收敛到哪个阶段，新加入的错误值总会干扰最后的平均结果，使得最终收敛值向不同方向倾斜。Dolev算法不受影响，因为被“去头去尾”去掉了。 假设错误PE只在第一轮传播自己的初始错误值，以后迭代过程使用新值，则收敛如下：
FCA Algorithm
    2.3500    2.1333    2.1333    2.1333    2.1333

Precesion: 0.216667 
    2.3500    2.1767    2.1767    2.1767    2.1767

Precesion: 0.173333 
    2.3760    2.2113    2.2113    2.2113    2.2113

Precesion: 0.164667 
    2.4020    2.2443    2.2443    2.2443    2.2443

Precesion: 0.157733 
    2.4270    2.2758    2.2758    2.2758    2.2758

Precesion: 0.151147 
    2.4509    2.3060    2.3060    2.3060    2.3060

Precesion: 0.144837 
.
.
.
    2.9811    2.9761    2.9761    2.9761    2.9761

Precesion: 0.004989 
    2.9819    2.9771    2.9771    2.9771    2.9771

Precesion: 0.004780 
FCA确实收敛，且一致收敛到2.977~2.981.精度为0.00478，迭代了85次，远远慢于dolev算法。改变delta的值，观察对程序的影响：

| delta | Iterations| Precision | Output |
| --- | --- | --- | --- |
| 0.01 | 5 |  0.195130 | 2.22 ~  2.4151 |
| 0.1 | 5 |  0.195130 | 2.22 ~  2.4151 |
| 0.2 | 6 |  0.000025 | 2.2617~2.2618 |
| 0.3~0.65 | 4 | 0.000034 | 2.2781 |
| 0.7 | 81 |  0.004708 | 2.9774~2.9821 |
| 1 | 80 |  0.004716 | 2.9774~2.9821 |

由此可见，FCA对delta的值非常敏感，若太大会造成收敛效率急剧下降，若太小，则无法一致收敛（所有值都不是acceptable的，算法失效）。当设置合适的delta时，发现FCA收敛效率很高。同样的，设置收敛条件为10^(-10)，经过10轮迭代, FCA一致收敛到2.2781。可见FCA确实是一个快速收敛算法，然而需要较小心的设置delta的值，否则会造成精度下降。

2.2781    2.2781    2.2781    2.2781    2.2781
Precesion: 0.000000 


##### Sensor Fusion
本实验的实现思路并没有采用官方算法O(nlgn),而是简单取了线段区间的交集，复杂度对每个PE为O(n^2)。基本思路为，遍历每个传感器accuracy区间的最大最小值，如果它是超过N-t个线段的交集的端点，则它必定在其他N-t-1个线段的内部。于是可以得到超过N-t次被覆盖的端点。分析其被cover的次数，便可以得到不同个数传感器的交集.

结果：
PE1: 4[1.5,2.7];5[2.7,2.8];4[2.8,3.2]
PE2: 4[1.5,2.6];4[2.7,2.8]
PE3: 4[1.5,2.7];5[2.7,2.8];4[2.8,3.2]
PE4: 4[1.5,2.5];4[2.7,2.8]

Final accuracy range:
PE1: [1.5, 3.2]; PE2: [1.5, 2.8]; PE3: [1.5, 3.2]; PE4: [1.5, 2.8]

##### Hybrid Fusion
结合了FCA算法与sensor fusion算法，实验收敛条件0.001

Hybrid Algorithm
most accurate answer for PE 1: [ 1.500000, 3.200000 ]
most accurate answer for PE 2: [ 1.500000, 2.800000 ]
most accurate answer for PE 3: [ 1.500000, 3.200000 ]
most accurate answer for PE 4: [ 1.500000, 2.800000 ]
most accurate answer for PE 5: [ 1.500000, 2.800000 ]
    2.6269    2.4000    2.6269    2.3750    2.1500

Precesion: 0.476923 
most accurate answer for PE 1: [ 1.776923, 3.025000 ]
most accurate answer for PE 2: [ 2.002885, 2.999038 ]
most accurate answer for PE 3: [ 2.128846, 2.873077 ]
most accurate answer for PE 4: [ 2.254808, 2.747115 ]
most accurate answer for PE 5: [ 2.380769, 2.621154 ]
    2.2816    2.3956    2.4096    2.4236    2.4376

Precesion: 0.155983 
most accurate answer for PE 1: [ 2.303419, 2.515812 ]
most accurate answer for PE 2: [ 2.317415, 2.501816 ]
most accurate answer for PE 3: [ 2.331410, 2.487821 ]
most accurate answer for PE 4: [ 2.345406, 2.473825 ]
most accurate answer for PE 5: [ 2.373397, 2.459829 ]
    2.3750    2.3750    2.3750    2.3750    2.4166

Precesion: 0.041613 
most accurate answer for PE 1: [ 2.331784, 2.418216 ]
most accurate answer for PE 2: [ 2.331784, 2.418216 ]
most accurate answer for PE 3: [ 2.331784, 2.418216 ]
most accurate answer for PE 4: [ 2.331784, 2.418216 ]
most accurate answer for PE 5: [ 2.331784, 2.418216 ]
    2.3915    2.3915    2.3915    2.3698    2.3915

Precesion: 0.021701 
most accurate answer for PE 1: [ 2.348247, 2.434678 ]
most accurate answer for PE 2: [ 2.348247, 2.434678 ]
most accurate answer for PE 3: [ 2.348247, 2.434678 ]
most accurate answer for PE 4: [ 2.348247, 2.434678 ]
most accurate answer for PE 5: [ 2.348247, 2.434678 ]
    2.3934    2.3934    2.3934    2.3934    2.3934

Precesion: 0.000000 
most accurate answer for PE 1: [ 2.350203, 2.436634 ]
most accurate answer for PE 2: [ 2.350203, 2.436634 ]
most accurate answer for PE 3: [ 2.350203, 2.436634 ]
most accurate answer for PE 4: [ 2.350203, 2.436634 ]
most accurate answer for PE 5: [ 2.350203, 2.436634 ]
    2.3934    2.3934    2.3934    2.3934    2.3934

Precesion: 0.000000 
Iteration num: 5

最终精度达到0，只需要5轮迭代，验证了Hybrid算法结合了sensor fusion的最佳accuracy优势([2.35~2.43]),FCA的 最佳精度收敛(0),同时迭代次数非常少。
