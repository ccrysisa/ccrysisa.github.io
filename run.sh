#!/bin/bash

# 执行hugo命令生成网站静态文件
hugo -d docs

# 提交更改到Git仓库
git add .
git commit -m "update $(date)"

# 推送更改到远程仓库（假设远程分支为main）
git push origin main