JEKYLL=bundle exec jekyll

build:
	$(JEKYLL) build

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean
	rm -rf node_modules

install:
	bundle install
	npm install

