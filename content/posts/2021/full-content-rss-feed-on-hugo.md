---
title: "HugoのRSS FeedをFull-textにする"
date: 2021-02-23T22:56:26+09:00
categories: []
tags: ['blog','hugo','rss']
draft: false
---

このサイトのRSS FeedをFull-textにしたのでメモ．

<!--more-->

## 背景
ふと自分のブログをRSSリーダーに登録してみたら記事の本文が最初だけしか表示されていなかった．

調べてみると，どうやらHugoの[default RSS template](https://gohugo.io/templates/rss/#the-embedded-rssxml)では`<description>{{ .Summary | html  }}</description>`のみで`.Content`が定義されていない模様．


## 解決策
関連記事を漁っていると`description`の`.Summary`を`.Content`に変更する方法がいくつか見つかった．
ただ`description`は短めの要約を定義するのが推奨っぽいので`content:encoded`を追加する方式にした．


#### rss.xmlを用意
`layouts/_default/rss.xml`を配置してデフォルトのtemplateを上書きする．[default RSS template](https://gohugo.io/templates/rss/#the-embedded-rssxml)に記載されている[Githubのリンク](https://github.com/gohugoio/hugo/blob/master/tpl/tplimpl/embedded/templates/_default/rss.xml)からダウンロードする．

```bash
curl "https://raw.githubusercontent.com/gohugoio/hugo/master/tpl/tplimpl/embedded/templates/_default/rss.xml" > layouts/_default/rss.xml
```

#### rss.xmlを修正
以下で元のrss.xmlと変更を加えた`layouts/_default/rss.xml`のdiffを取る．
```bash
diff --label default --label custom <(curl "https://raw.githubusercontent.com/gohugoio/hugo/master/tpl/tplimpl/embedded/templates/_default/rss.xml") <(cat layouts/_default/rss.xml)
```
```diff
--- default
+++ custom
@@ -11,7 +11,7 @@
 {{- $pages = $pages | first $limit -}}
 {{- end -}}
 {{- printf "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>" | safeHTML }}
-<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
+<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/">
   <channel>
     <title>{{ if eq  .Title  .Site.Title }}{{ .Site.Title }}{{ else }}{{ with .Title }}{{.}} on {{ end }}{{ .Site.Title }}{{ end }}</title>
     <link>{{ .Permalink }}</link>
@@ -33,6 +33,11 @@
       {{ with .Site.Author.email }}<author>{{.}}{{ with $.Site.Author.name }} ({{.}}){{end}}</author>{{end}}
       <guid>{{ .Permalink }}</guid>
       <description>{{ .Summary | html }}</description>
+      <content:encoded>
+              {{ `<![CDATA[` | safeHTML }}
+              {{ .Content  }}
+              {{ `]]>` | safeHTML  }}
+      </content:encoded>
     </item>
     {{ end }}
   </channel>
```
* `<rss>`に`xmlns:content="http://purl.org/rss/1.0/modules/content/"`を追加
  * これが無いと`Namespace prefix content on encoded is not defined`でエラーになる
* `<content:encoded>`を追加
  * `<content:encoded>{{ .Content | html }}`でも良さそう

ひとまずこれでFeedlyではうまく表示出来てそう．Inoreader側ではキャッシュが保持されて過去記事には適用され無さそうなのでしばらくこれで運用してみて様子をみる．

# 参考
---
* [Full-text RSS feed](https://discourse.gohugo.io/t/full-text-rss-feed/8368)
* [Displaying the Full Content in Hugo's RSS feed](https://blog.eternalrecurrence.space/posts/displaying-the-full-content-in-hugo-rss-feed/#bonus-the-difference-between--and---in-hugo)
* [Full Content RSS Feeds With Hugo](https://unusually.pink/full-content-rss-feeds-with-hugo/)
* [HugoでFull Text RSSを有効化する](https://blog.karashi.org/posts/fulltext-rss-with-hugo/)
