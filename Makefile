JEKYLL=bundle exec jekyll

build:
	$(JEKYLL) build --trace

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean

install:
	bundle install
	npm install

