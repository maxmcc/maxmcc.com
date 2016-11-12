JEKYLL=bundle exec jekyll

build:
	bundle install
	npm install
	$(JEKYLL) build --trace

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean

install:
	bundle install
	npm install
