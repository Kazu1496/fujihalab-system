#!bin/bash

cd `dirname $0`


# basename `pwd` してstaging を含んでるか否かでenvを切り分け
is_staging=`pwd | awk '{print (split($0, stg, "\t"))}'`

if [[ -e `pwd|grep stg` ]]; then
	ra_env=staging
	else
	ra_env=production
fi
echo "------${ra_env}用のデプロイを実行します"

# ----

echo -e "pullします"
`git pull`
echo "serviceを落とします"
(kill -9 `cat tmp/pids/unicorn.pid`)

read -p "db: migrateを実行しますか？[Y/n]" yn
case "$yn" in 
	[yY]*) (bundle exec rails db:migrate RAILS_ENV=${ra_env});;
	*) echo "passed db:migrate";;
esac

read -p "assets:precompileを実行しますか？[Y/n]" yn
case "$yn" in 
	[yY]*) (bundle exec rails assets:precompile RAILS_ENV=${ra_env});;
	*) echo "passed assets precompile";;
esac


echo "unicornを再起動します"
(bundle exec unicorn_rails -c config/unicorn.conf.rb -D -E ${ra_env})

