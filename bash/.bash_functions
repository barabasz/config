# FUNCTIONS

# Find files, ignore directories & SVN and hide some errors
function ff() {
	find . -iname $1 2>&1 | grep -v .svn | grep -v .sass-cache | grep -v 'Permission denied' | grep -v 'Not a directory'
}

# Show http status code for any URL
function httpcode() {
	curl "$*" -IsS | grep "HTTP/"
}

# Create dir and cd into
function mkcd () {
	mkdir -p "$*"
	cd "$*"
}

# Add Google Chrome repo & install Chrome
function installChrome() {
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
	sudo apt update
	sudo apt install google-chrome-stable
}