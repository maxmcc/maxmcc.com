JEKYLL=bundle exec jekyll

setup:
	bundle install
	npm install

build:
	$(JEKYLL) build --trace

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean

netlify-autodeploy: setup build
