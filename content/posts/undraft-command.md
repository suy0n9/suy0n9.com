---
title: "Hugoのundraftコマンドを再現する"
date: 2020-10-31T00:13:34+09:00
categories: []
tags: ['blog', 'hugo']
draft: false
---

Hugoでブログを書く際に[Archetypes](https://gohugo.io/content-management/archetypes/)を設定しdraftをtrueにしているのだが，記事を書き終わって`git push`する前にdraftをfalseにするのを毎回忘れてしまう．
更に`hugo new posts/<filename>.md`でMarkdown作成時にタイムスタンプが付与されるが，記事を書き終えた後に再度タイムスタンプを書き換えるのが面倒だったので調べた．

## 結果

どうやら`hugo undraft`コマンドがあったが，既にremoveされていた．  
[How to touch the date after `undraft` is deleted?](https://discourse.gohugo.io/t/how-to-touch-the-date-after-undraft-is-deleted/10525)

## 解決策

僕は記事を書き始めて日をまたぐ時が多々ある．そしてdraftで書きためておいて然るべきタイミングでpublishしたい時もあるので，上記にあるように簡易スクリプトで対応するようにした．

```bash
#!/bin/sh

file=$1
now="$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -e 's/00$/:00/')"

if [ -f "${file}" ]; then
    sed -i -e 's/^date: 20.*$/date: '"${now}"'/' \
           -e 's/^draft: true$/draft: false/' "${file}"
    echo "Update date: ${now}"
    echo "Update draft: false"
else
    echo "${file} not found"
    exit 1
fi
exit 0
```

`date`コマンドで取得した`%z`のタイムゾーンでは`+hhmm`(+0900)形式になっている．しかし[TOMLのoffset-date-time](https://toml.io/en/v1.0.0-rc.3#offset-date-time)では`+hh:mm`(+09:00)なので，`sed`で一度置換している．

上記をMacで実行する場合，`sed`がBSD版なのでGNU版を入れとかないと`-i`オプションがうまく動かない．

Homebrew でinstallする．
```bash
$ brew install gnu-sed
```

>If you need to use it as "sed", you can add a "gnubin" directory to your PATH from your bashrc like:

`gsed`ではなく`sed`として利用できるようにパスを通す．
```
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
```

## まとめ

しばらくこれで運用してみる．
