# 域名列表
搜集的一些网站地址，可用于自定义路由。

# 工具

## 从Charles的csv文件导入

```
./convert.sh charles_csv target_csv
```
注意导入和导出的csv文件必须要存在，导出的结果去除了重复

## 检测域名是否有正确解析
```
./check.sh csv [update]
```
指定`update`可以直接更新输入的`csv`，目前是通过`114.114.114.114`查询解析记录