# Terraform学習用 & 公開用

## Terraform環境構築

以下URLを参照してください。

https://zenn.dev/articles/15-terraform-aws-first

## 1. プロジェクトの初期化

まずは、Terraformプロジェクトの基礎を設定する。Bashターミナルを開き、以下のコマンドでTerraformプロジェクトの初期化を行う。

```bash
terraform init
```

## 2. コードのフォーマット

プロジェクトのコードを整理するために、以下のコマンドを実行して、Terraformファイルのフォーマットを整える。

```bash
terraform fmt
```
このコマンドは、一貫したスタイルでコードを整形する。

## 3. インフラ環境の変更内容の確認

変更を適用する前に、以下のコマンドでインフラ環境の変更内容を確認する。

```bash
terraform plan
```

このコマンドは、構築されるインフラの概要を表示し、コードに誤りがないかを確認するのに役立つ。

## 4. インフラ環境の反映

最後に、以下のコマンドでインフラ環境の変更を適用する。
-auto-approveオプションは、確認プロンプトをスキップして直接変更を適用する。

```bash
terraform apply -auto-approve
```

## 5. 後片付け

AWSは従量課金制なので、デモやテスト目的のインフラは使用後に破棄することが重要。
以下のコマンドで、Terraformを用いて構築したインフラを破棄できる。
このコマンドは、Terraformによって構築されたリソースを全て削除します。

```bash
terraform destroy -auto-approve
```