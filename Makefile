JEKYLL=bundle exec jekyll

build:
	$(JEKYLL) build

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean

install:
	bundle install
	npm install

