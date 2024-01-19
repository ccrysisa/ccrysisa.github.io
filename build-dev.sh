#!/bin/bash

# 执行hugo命令生成网站静态文件
hugo -d docs -F --cleanDestinationDir

# 提交更改到Git仓库
git add .
git commit -m "update $(date)"
