# M.I.D.N.I.G.H.T

Private Matrix of Infinite Death Nightfall Iteration Generation Host Terminal

- 这个repo是`DejaVu`和`Terminal`两个模块的整合。维持MIT开源。`AGENTS.md`、`.vscode`等和项目本身无关的文件，做了删除。

## 基本介绍

本项目是[EZWowX2](https://github.com/liantian-cn/EZWowX2)项目的后续新坑，有诸多优势。

- 作者还在维护、更多的手写代码：为了去掉AI屎山，本项目代码手写量>95%，作者维护意愿更强。
- 使用兼容性更好的GDI截图：优化了算法，在Ryzen 9700X下能实现100fps。性能测试见`notes`目录。
- 游戏内设置：动态变量设置由游戏内插件完成。
- 循环热加载：在ide里编辑代码，保存后，rotation会自动重载。

## 截图


### DejaVu

![DejaVu.png](https://github.com/user-attachments/assets/23188976-473f-48fc-9b74-72ce0002f29f)

### Terminal

![Terminal.png](https://github.com/user-attachments/assets/a6bb4d44-ac5f-4af1-b51d-a0ccbea0f89b)

## 安装

- 下载[QClaw](https://qclaw.qq.com/)
- 发送指令`请根据 https://github.com/liantian-cn/M.I.D.N.I.G.H.T/blob/main/INSTALL.md 为我安装MIDNIGHT`

## 进阶逻辑

访问[repo wiki](https://github.com/liantian-cn/M.I.D.N.I.G.H.T/wiki)会缓慢更新。

## 意见建议

访问[repo discussions](https://github.com/liantian-cn/M.I.D.N.I.G.H.T/discussions)

## 当前repo专精支持情况

- **血DK**：比较OK，可以用在13层及以下的大米，需要自行开冰刃和吸血鬼、符文剑简易手动开或爆发模式。
```
CoPASnrjTdwaLTX9NnLQoJJXfwMz2MzwMmZmhZbmZmmZxMjZmxAAAAAmxMzMzMDzYMAYMzMzAAAYmZbMMmxySjltlhJbDDLAmxMAAMzAAGA
```
- **熊德**：相对OK，可以用在13层及以下的大米，需要自行提前开爆发、本能。
```
CgGA8cL7tpvige+kkmGM9zUPWDAAAAAAAAAAAgZmxswMjZWmZZeAmZZZgZzwoJamZWYmZmlxMAAAAAAMjtZAAAAomZZWmZmBAwCzMPAwy2MDDYxiBAzsBD
```
- **奶德**：相对OK。

PS：目前熊T和血DK还是下水道难兄难弟，还是需要有点副本理解才能玩的。

### 爆发宏
```
/burst x.x
```
在x.x秒内处于爆发状态。
血DK的符文剑会开启。熊的化身会开启。奶德会预铺5人双回春。

### 延迟宏
```
/delay x.x
```
在x.x秒内处于暂停状态。
0.4秒就可以有效插入技能了。

### 打断黑名单

T不断小条
```
1254669
1258436
1248327
1262510
468962
1262526
```
节点尾王： `1257613`
熊不断执政老2：`248831`


   

