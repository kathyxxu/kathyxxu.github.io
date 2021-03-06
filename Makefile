deploy:
	git checkout source
	bundle exec jekyll build
	git add -A
	git commit -m "update source"
	rm -rf /tmp/_site
	cp -R _site/ /tmp/_site
	git checkout master
	rm -r ./*
	cp -r /tmp/_site/* ./
	git add -A
	git commit -m "deploy blog"
	git push origin master
	git checkout source
	echo "deploy succeed"
	git push origin source
	echo "push source"