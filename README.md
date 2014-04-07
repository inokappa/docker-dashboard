# Docker Dashboard

## これ何？

 * dashing を使った稼働中の docker コンテナ等の情報を表示するダッシュボードです
 * ネタで作りました

##  使い方

#### git clone

```
git clone https://github.com/inokappa/docker-dashboard.git
```

#### Gemfile の修正

gem の docker-api を使うので Gemfile に追加して下さい。

```
gem 'docker-api'
```

追加したら `bundle install` して下さい。

```
bundle install
```

#### jobs/docker.rb の修正

jobs/docker.rb の以下を環境に合わせて修正して下さい。

```
#Please Change Docker API ENDPOINT
Docker.url='http://172.17.42.1:4243/'
```

#### dashing を起動する

```
cd ${PATH}/docker-dashing
dashing start
```

## Screen Shot

![](http://cdn-ak.f.st-hatena.com/images/fotolife/i/inokara/20140407/20140407005256.png)

## More Infomation

Check out http://shopify.github.com/dashing for more information.
