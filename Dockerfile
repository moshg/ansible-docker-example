# AnsibleはターゲットサーバーにPythonがインストールされている必要があるため
# Pythonイメージを使用する
FROM python:3.12

# 公開鍵のパス
ARG PUBLIC_KEY_PATH=~/.ssh/id_ed25519.pub

# Ansibleに必要な依存をインストール
RUN apt-get update &&\
    apt-get install -y openssh-server sudo python3-apt --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# sshdを起動するためのディレクトリを作成
RUN mkdir -p /run/sshd

# ansibleユーザーを作成し、sudoグループに追加
RUN adduser ansible
RUN usermod -aG sudo ansible

# ansibleのパスワードをansibleに設定
RUN echo "ansible:ansible" | chpasswd

# 公開鍵を登録
RUN mkdir -p -m 700 /home/ansible/.ssh && chown ansible:ansible /home/ansible/.ssh
COPY --chmod=600 --chown=ansible:ansible $PUBLIC_KEY_PATH /home/ansible/.ssh/authorized_keys

# detachせずsshdを起動
CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22
