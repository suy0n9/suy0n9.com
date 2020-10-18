---
title: "MediumからHugoに移行した"
description:
date: 2020-10-18T23:38:52+09:00
categories: []
tags: ['blog','hugo']
---

ブログをMediumからHugoに移行した．

# 動機

主に以下の理由
* Mediumの会員登録を促すポップアップが盛んになってきた
* カスタムドメインを使いたい
* 記事をGit管理したくなった

カスタムドメインはそのうち設定しようかと思ってのんびりしていたらdeprecationされていた.  
[Custom Domains service deprecation](https://help.medium.com/hc/en-us/articles/115003053487-Custom-Domains-service-deprecation)  
なお，近々復活するみたいだが，時期は未定.

Git管理に関しては，「ブログサービスに一存するよりMarkdownで手元に記事を置いといた方がいざという時にサービスの運営を気にせず制御できる|安心感がある」みたいな話は良く目にしていたので, そうだなぁと思った次第．

これらの条件をすべて満たし，巷でよく使われているHugoにすべきかしばらく検討していた. 構築が面倒だったり凝りすぎて「書く」より「作る」になってしまいそうでずっと棚上げしていたが，重い腰を上げて移行した．


# Hugoとは
Goで実装されている「Webサイト構築フレームワーク」だ．
使い方や詳細は[公式サイト](https://gohugo.io/)に詳しく書かれているし，既に色んな人が書いているので以下略．


# 移行について

移行方法は[公式ページ](https://gohugo.io/tools/migrations/#medium)で紹介されている[medium2md](https://github.com/gautamdhameja/medium-2-md)を使用した.  
Mediumからエクスポートしたデータをmedium2mdでMarkdownに変換することでほぼできた．

### 変換がうまく行かなかった箇所

#### 記事内のURLのMarkdownタイトルが長くなる
Markdown記法のURLタイトルに恐らく元のHTMLに含まれているカード型リンク内のサマリ文章までがタイトルになってしまい，とても長いリンクになっていた．長い箇所は記事数がそんなに多くなかったのであまり深く考えず気づいた箇所だけ手直しした...  

#### SNSなどのリンクの埋め込み
HugoではMarkdownの中に簡易的な記述でTwitterやYoutubeなどを埋め込める[Shortcode](https://gohugo.io/content-management/shortcodes/)という機能がある．

`medium2md`で変換されたMarkdownにはTwitterの埋め込み箇所がまるっと欠損していた．僕の場合は特定の箇所でしかTwitterを参照していなかったので，以下の様な簡易スクリプトで`Shortcode`を生成して貼り付けた.

{{< gist suy0n9 739d95242a8c0946d1f313ff1fa593a2 >}}

YouTubeの埋め込み箇所はそのままURLに展開されていた．これまた使用箇所が少なかったので気づいたところのリンクを`Shortcode`で貼り直した.


## Hosting & Deployment
構築したサイトはGithub Pagesで公開している.

基本的には以下の公式ページ通りにすればできる．

[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)

少し迷った点として，Github Pagesでのサイト公開の方式が2のタイプあり, 公開方式によってデプロイ方式が複数パターンあった.

公開方式は以下の2つのパターン
* User/Organization Pages
`(https://<USERNAME|ORGANIZATION>.github.io/)`
* Project Pages
`(https://<USERNAME|ORGANIZATION>.github.io/<PROJECT>/)`

上記の公開方式により，デプロイ方式が枝分かれする
* [GitHub User or Organization Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/#github-user-or-organization-pages)

    リポジトリを「Hugoの設定やソースコード，Markdown」と「レンダリングされたWebサイト」で分ける方式
* [GitHub Project Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/#github-project-pages)
    * [Deployment of Project Pages from /docs folder on master branch](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-docs-folder-on-master-branch)
        * Hugoの`publishDir`を`docs`に設定し，`master`ブランチで`docs`ディレクトリを公開
    * [Deployment of Project Pages From Your gh-pages branch](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch)
        * `gh-pages`ブランチで公開
    * [Deployment of Project Pages from Your master Branch](https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-master-branch)
        * `public`ディレクトリをrootとして`master`ブランチで公開

最初は`User/Organization Pages`方式でリポジトリを分けて構築した．この方式の場合，ビルドして生成される`public`ディレクトリを`submodule`化しリポジトリを分けているので，`deploy.sh`なるものを用意してデプロイする．
しかし次第にリポジトリを2つに分けている事に煩わしさを感じてリポジトリを一つにし`gh-pages`ブランチで公開する様に変更した.

### デプロイ自動化
Github Actionでデプロイを自動化した．利用したのは以下で，どちらかの`Getting Started`通りに`.github/workflows/gh-pages.yml`を作成し，`master`ブランチに`push`するだけで`gh-pages`ブランチに公開される様になった．
* [GitHub Actions for Hugo](https://github.com/peaceiris/actions-hugo)
* [GitHub Actions for GitHub Pages](https://github.com/peaceiris/actions-gh-pages)

少しハマった所として，[Managing a custom domain for your GitHub Pages site](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site)に従い設定したカスタムドメイン用の`CNAME`ファイルがデプロイ時に消えてしまい，リポジトリ -> Settings -> Custom domain の値が元に戻ってサイトが見れないようになってしまった．

[GitHub Actions for GitHub Pages](https://github.com/peaceiris/actions-gh-pages)側の `README`をよく読むと`CNAME`ファイルを追加するオプションがあった．

```yaml
- name: Deploy
  uses: peaceiris/actions-gh-pages@v3
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ./public
    cname: github.com
```
`REAMDE`をよく読む事の重要性を再認識した．

# 移行してみて
記事をMarkdownで書いてGit管理し，自分のドメインでサイトを公開し，サイトデザインは[Theme](https://themes.gohugo.io/)がたくさん公開されていて自作もできるので，トータルで満足している．

細かい設定やタグ機能，デザインなどは少しずつ修正していこうと思う．

# まとめ
いつものペースでたまに更新すると扱い方を忘れそうなので(デプロイ自動化したので大丈夫なはず)，これを機に定期的に書いていきたい．
