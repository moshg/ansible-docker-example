# Ansible with Docker

Dockerで起動したターゲットサーバーにAnsibleを実行する例。

## Ansibleのインストール

ドキュメント: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

上記ドキュメントに載っていない方法: [Rye](https://rye.astral.sh/)のtoolsとしてansibleをインストールする。

```sh
rye install ansible --include-dep ansible-core
```

## ターゲットコンテナの起動

1\. 生成済みの鍵を利用する場合、`.env`ファイルに公開鍵へのパスを記述する

```sh
echo "PUBLIC_KEY_PATH=<公開鍵のパス>" > .env
```

1'. 専用の鍵を生成する鍵を生成する場合、鍵を生成して`.env`ファイルに生成した公開鍵へのパスを記述する

```sh
mkdir .ssh
ssh-keygen -t ed25519 -f .ssh/id_ed25519 -C isucon-ansible -N ""
cp .env.example .env
```

2\. コンテナを起動する

```sh
docker compose up --build
```

3\. 動作確認としてコンテナにSSH接続する

```sh
ssh -i <秘密鍵のパス> -p 8080 ansible@127.0.0.1
```

## Ansibleの実行

```sh
ansible-playbook -i inventory.yaml appservers.yaml
```
