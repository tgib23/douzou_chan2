anonymous user id : 1

Dauzou_Go_admin user id : 2
(OAuthログインするユーザはdb:seedで作成出来ない)

postのuser_idはそのpostを作った人
contribution の user_id はそのcontributionを作った人

## データの投入について

* プロダクション用のデータ投入
```
$ rails db:seed
```

* 開発用のデータ投入
```
$ rails db:seed:development
```

データの削除
```
$ rails console
> User.delete_all
> Post.delete_all
> Pic.delete_all
```


## 開発用リリースフロー

```
# rbenv local 2.3.0
# bundle install
# rake db:migrate
# rails db:seed
# cp -r <crt_path>/crt ./
# cp <env_path>/.env ./
# nohup pumactl start >> log/development.log &
```
