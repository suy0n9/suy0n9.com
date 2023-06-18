---
title: "ブログのGA4対応、ディレクトリ構成とデプロイ方法変更"
date: 2023-06-18T19:39:03+09:00
categories: []
tags: ['blog', 'hugo', 'GA4', 'GitHub Actions']
draft: false
---


<!--more-->

GA4の対応をずっと放置していてようやく対応した。そして久しぶりにブログを弄ったら`content/posts/`配下に全postがあって見ずらいなとかCIが動かなくなったり等あったので諸々修正した。


## ディレクトリ構成の変更
`content/posts/`配下に溜まっていたmdファイルをこのタイミングで年毎のディレクトリに変更した。

before
```bash
content/posts/
├── post1.md
├── post2.md
├── post3.md
...snip...
├── post-a.md
├── post-b.md
└── hoge-post
    ├── index.md
    └── hoge.png
```

after
```bash
content/posts/
...snip...
├── 2020
│   ├── post1.md
│   ├── post2.md
│   ├── post3.md
│   └── hoge-post
│       ├── index.md
│       └── hoge.png
...snip...
└── 2023
    ├── post-a.md
    └── post-b.md
```
今回は現状の更新頻度から月毎のディレクトリは無くても良いかなと判断した。

これで変更をpushしたところデプロイがコケた。

```
The ubuntu-18.04 environment is deprecated, consider switching to ubuntu-20.04(ubuntu-latest), or ubuntu-22.04 instead. For more details see https://github.com/actions/virtual-environments/issues/6002
```
暫くメンテしていなかったのでrunner imageは`ubuntu-18.04`のままだった。そして2023/04/03でunsupportedになっていた。  
https://github.com/actions/virtual-environments/issues/6002

おそらくimageのバージョンを更新すれば動くようになったがこれを機にデプロイ方法を見直すことにした。


## デプロイ方法の変更

これまで[MediumからHugoに移行した]({{< ref "medium2hugo.md" >}})で書いた様に[peaceiris/actions-gh-pages](https://github.com/peaceiris/actions-gh-pages)を使ってgh-pagesブランチにファイルを配置してデプロイする方式だった。

2022年の7月からはGithub Actionsにて直接デプロイする方式も選べるようになっていた[^1]ので、これにする。

ざっくりな内容としては[actions/upload-pages-artifact](https://github.com/actions/upload-pages-artifact)でデプロイしたいファイルをartifactとして一度uploadし、ブランチにファイルを配置せずに[actions/deploy-pages](https://github.com/actions/deploy-pages)で直接GitHub Pagesにデプロイする。

設定の仕方はHugoのドキュメントにあるのでこれの通りに設定した。  
[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)


## GA4の対応

かなり前からアナウンスされていたのでHugoのInternal Templatesでも対応している。  
[Internal Templates - Google Analytics](https://gohugo.io/templates/internal/#google-analytics)

theme側で以下のinternal templateを利用するように変更する。
```
{{ template "_internal/google_analytics.html" .  }}
```

そしてconfig.tomlで`UA-xxx`形式のIDを`G-xxx`形式のIDに変更する。
```
googleAnalytics = 'G-MEASUREMENT_ID'
```

GA4のタグIDは以下から確認。  
[[GA4] Google タグ ID を確認する](https://support.google.com/analytics/answer/9539598?hl=ja&ref_topic=9303319&sjid=2574039662851393639-AP)

[^1]: https://github.blog/changelog/2022-07-27-github-pages-custom-github-actions-workflows-beta/ 
