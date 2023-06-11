---
title: "1PasswordのプランをFamiliesへ変更する方法"
date: 2020-11-06T22:12:53+09:00
categories: []
tags: ['life', '1password']
draft: false
---

これまでずっと個人プランで使っていた[1Password](https://1password.com/jp/)をファミリープランに移行したのでまとめとく．

## lt;dr
Appleのサブスクリプションで1Passwordを購読している場合，プラン変更ができない．

* サポートに問い合わせる
* Apple サブスクリプションを解除する
* サポートに知らせ，`Apple subscription`フラグを外してもらう
* ログインし，`Invite People`から登録

既存の年間サブスクリプションの残期間はアカウントに適用してもらえた．


## プラン変更を試みる
僕はiOSアプリで1Passwordを使い始めたのでアカウント登録，購読をAppleのサブスクリプションで開始していた．(当時調べてアプリ内購読の方が安いだとか為替レートが変わらないだかの記事を読んだ気がする)

そして今回プランを変更しようと思い，アカウント情報などのページから変更できるだろうと見てみるとアプリ上もブラウザ上にも変更できる様な表示は見当たらなかった．
[サポートページ](https://support.1password.com/change-account-type/#if-you-have-an-individual-account)にはサインインして`Invite People`からアップグレードしろとある．
しかし，そんな表示すら無いのである．だがよく見ると以下のように書いてある．
>If you started your subscription with an in-app purchase, you won’t see the option to invite people. For help upgrading your account, contact 1Password Support.

まさに表示されていないので言われたとおりサポートに問い合わせる．

## サポートに問い合わせ
[サポートページ](https://support.1password.com/change-account-type/#if-you-have-an-individual-account)のリンクをたどって`I want to upgrade to 1Password Families`を選択し，専用フォームからDeepL翻訳でこしらえた以下の文章を貼り付けて，送信．
>hello,
>
>I am Suyong.
>I'm currently on an Apple subscription.
>I want to switch to a family plan and add one more person, but I can't find a way to do it.
>Can you tell me how to do this?
>
>I look forward to hearing from you.

するとすぐに返信が来る．
> 一部抜粋
>
>If you started your subscription using an in-app purchase on your Apple or Android device, you'll need to cancel your subscription with Apple or Google Play. After you cancel your subscription, or if you're still having trouble, reply to this message. 

 どうやら "AppleまたはAndroidデバイスでアプリ内購入を使用してサブスクリプションを開始した場合は、AppleまたはGooglePlayでサブスクリプションをキャンセルする必要がある" とのこと．

念の為以下の質問を返信．
* 今のアカウントのデータに影響は無いか
* 年間購読の残りの期間も失われてしまうのか

するとすぐまた返信が来る．サポートの対応がとても早い．
> 一部抜粋
>
>This process won't affect your data at all. 
>Once you confirm that you've cancelled your subscription, what I'll do is clear the "Apple subscription" flag from your account here on our side. 
>That's going to freeze your account (as the subscription is ended and you're outside of the 30-day trial period), and it will also enable the control for upgrading your account to a family account.
>It'll be very quick and I'll explain how to proceed in my next email, once I receive your confirmation. I'll also calculate how much time you have left in your subscription and I'll be happy to apply the credit that is due to your 1Password account (in the future, you'll be billed directly by us rather than by Apple).

"このプロセスは、データにまったく影響を与えない"，"サブスクリプションをキャンセルしたらフラグをクリアする"，"サブスクリプションの残りの期間はアカウントに適用する" とのこと．

### サブスクリプションを解除
iPhone上から[ サブスクリプションを解除 ](https://support.apple.com/ja-jp/HT202039)し，サポートにその旨を返信する．

### 1Password Familiesへアップグレード
すぐに返信が来てアップグレード手順を教えてくれた．

> 一部抜粋
>
> 1. Open your web browser and sign into your account: https://my.1password.com
> 2. In the menu on the right, click "Invite People..."
> 3. You'll get a pop-up with two options, one for upgrading your account to a family, and one for upgrading to a team (our business product) - click the family option, and follow the on-screen directions to upgrade your account
> 4. Add an additional family organizer in case you lose your sign-in details: https://support.1password.com/family-organizer/

手順通りにFamilies Planを選択，Billingタブから支払い登録すると一時的なアカウントフリーズが解除され無事にInvaite できるようになった．僕は既にクレジットカード情報を1Passwordに登録していたので自動的にカード情報がリスト表示され，選択するだけで入力を省くことができた．

しばらくするとBillingのView Invoicesから支払履歴を確認できる．

![](invoice.png)

なんだか`We miss you!`割引が適用されていた．
一時的にサブスクリプションが解約されてアカウントがフリーズになったからだろうか．

招待ユーザーはiOSアプリにてアカウント無し(購読なし)で使用していたが招待リンクからアカウントを作成し，ファミリー・グループとしてデータも引き継ぐことができた．
