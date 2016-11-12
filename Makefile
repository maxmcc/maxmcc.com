JEKYLL=bundle exec jekyll

build:
	$(JEKYLL) build --trace

server:
	$(JEKYLL) serve

clean:
	$(JEKYLL) clean

setup:
	bundle install
	npm install

netlify-autodeploy: setup build
