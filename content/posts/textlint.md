---
title: "textlintで日本語をチェックする"
date: 2020-10-21T20:17:02+09:00
categories: []
tags: ['textlint','vim']
draft: true
---

Markdownでブログを書く際に日本語の間違いやtypoをチェックできるようにtextlintを導入した．

## textlintとは
テキストやMarkdownに書かれた自然言語文章をルールに従ってチェックしてくれるツール．

[textlint/textlint](https://github.com/textlint/textlint)


##  インストールと設定

textlintとルールプリセットをglobalオプションでインストール．
```bash
$ npm install -g \
textlint \
textlint-rule-preset-ja-technical-writing \
textlint-rule-spellcheck-tech-word
```

そのままだとルールが適用されないので`.textlintrc`を用意する．今回使用したプリセットルールは以下．

* [preset-ja-technical-writing](https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing)
* [textlint-rule-spellcheck-tech-word](https://github.com/azu/textlint-rule-spellcheck-tech-word)

```bash
$ cat ~/.textlintrc
{
    "rules": {
        "preset-ja-technical-writing": {
            "sentence-length": {
                max: 140
            },
            "ja-no-mixed-period": {
                "allowPeriodMarks": ["．"]
            }
        },
        "textlint-rule-spellcheck-tech-word": true
    }
}
```
`preset-ja-technical-writing`では技術文書向けのルールが複数内包されている．
READMEにも書いてあるがデフォルトでは厳しめのルールになっているため，個別に`sentence-length`を140文字まで許容，`ja-no-mixed-period`での文末の句読点を`。`に加えて`．`も許容する設定にした。


## Vimで非同期にtextlintする
Vim プラグインマネージャーは[junegunn/vim-plug](https://github.com/junegunn/vim-plug)を，Lint エンジンに[dense-analysis/ale](https://github.com/dense-analysis/ale)を使用している．

```.vimrc
".vimrcから抜粋

" vim-plugでのインストール 
Plug 'w0rp/ale'

" ale linterの設定
let g:ale_linters = {
\   'markdown': ['textlint']
\}
```

これでMarkdownの文章を非同期チェックできるようになった．

